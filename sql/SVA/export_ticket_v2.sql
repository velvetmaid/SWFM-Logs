-- Based on OS syntax v1
WITH eventlog AS (
    SELECT
        transaction_id,
        MAX(
            CASE
                WHEN activity_name = 'Review Draft by NOP'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_by_nop,
        MAX(
            CASE
                WHEN activity_name = 'Approval by Manager NOP'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_mgr_nop,
        MAX(
            CASE
                WHEN activity_name = 'Approval by NOS'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_nos,
        MAX(
            CASE
                WHEN activity_name = 'Approval by Manager NOS'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_mgr_nos,
        MAX(
            CASE
                WHEN lower(action_name) = 'take over' THEN action_on
            END
        ) AS take_over,
        MAX(
            CASE
                WHEN lower(action_name) = 'request permit' THEN action_on
            END
        ) AS request_permit,
        MAX(
            CASE
                WHEN lower(action_name) = 'follow up' THEN action_on
            END
        ) AS follow_up,
        MAX(
            CASE
                WHEN lower(action_name) = 'check in'
                or lower(actioner_name) LIKE '%check in%' THEN action_on
            END
        ) AS check_in,
        MAX(
            CASE
                WHEN activity_name = 'Work Approve by SPVTO'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_spvto,
        MAX(
            CASE
                WHEN activity_name = 'Work Approve by NOP'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_nop,
        MAX(
            CASE
                WHEN activity_name = 'Work Approve by NOS'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_nos,
        MAX(
            CASE
                WHEN activity_name = 'Work Approval by NOS MGR'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_mgr_nos
    FROM
        {tx_eventlog}
    WHERE
        application_name = 'WFM'
        AND process_id = '46'
        AND (
            lower(action_name) IN (
                'submit',
                'take over',
                'request permit',
                'follow up',
                'check in',
                'approve'
            )
            or lower(actioner_name) = 'check in'
        )
    GROUP BY
        transaction_id
),
tx_diff_time AS (
    SELECT
        tch.cmsite_id,
        EXTRACT(
            EPOCH
            FROM
                (e.draft_approve_by_nop - tch.created_at)
        ) AS diff_created_to_drat_nop_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.draft_approve_mgr_nop - e.draft_approve_by_nop)
        ) AS diff_drat_nop_to_mgr_nop_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.draft_approve_nos - e.draft_approve_mgr_nop)
        ) AS diff_draft_mgr_nop_to_nos_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.draft_approve_mgr_nos - e.draft_approve_nos)
        ) AS diff_draft_nos_to_mgr_nos_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.take_over - e.draft_approve_mgr_nos)
        ) AS diff_draft_mgr_nos_to_takeover_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.request_permit - e.take_over)
        ) AS diff_takeover_to_requestpermit_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.follow_up - e.request_permit)
        ) AS diff_requestpermit_to_followup_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.check_in - e.follow_up)
        ) AS diff_followup_to_checkin_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_spvto - e.check_in)
        ) AS diff_checkin_to_spvto_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_nop - e.work_approve_spvto)
        ) AS diff_spvto_to_nop_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_nos - e.work_approve_nop)
        ) AS diff_nop_to_nos_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_mgr_nos - e.work_approve_nos)
        ) AS diff_nos_to_mgrnos_sec
    FROM
        {tx_cmsite_header} tch
        LEFT JOIN eventlog e ON tch.cmsite_id :: varchar = e.transaction_id
    WHERE
        not tch.asset_change
),
sla_eventlog AS (
    SELECT
        transaction_id,
        activity_name,
        action_on
    FROM
        {tx_eventlog}
    WHERE
        application_name = 'WFM'
        AND process_id = '46'
        AND activity_name IN (
            'Approval By Manager NOS',
            'Work Approval by NOS MGR'
        )
),
sla as (
    select
        tch.cmsite_id,
        CASE
            WHEN (
                CASE
                    WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
                    ELSE 30 * 24 * 60
                END
            ) >= (
                CASE
                    WHEN tch.closed_at = DATE '1900-01-01' THEN EXTRACT(
                        EPOCH
                        FROM
                            (closed.action_on - approval.action_on)
                    ) / 60
                    ELSE EXTRACT(
                        EPOCH
                        FROM
                            (tch.closed_at - tch.draft_approve_date)
                    ) / 60
                END
            ) THEN TRUE
            ELSE FALSE
        END AS is_in_sla,
        CASE
            WHEN tch.closed_at = DATE '1900-01-01' THEN EXTRACT(
                EPOCH
                FROM
                    (closed.action_on - approval.action_on)
            ) / 60
            ELSE EXTRACT(
                EPOCH
                FROM
                    (tch.closed_at - tch.draft_approve_date)
            ) / 60
        END AS mttr,
        tch.ready_for_fms_time + (
            CASE
                WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
                ELSE 30 * 24 * 60
            END
        ) * INTERVAL '1 minute' AS sla_end,
        CASE
            WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
            ELSE 30 * 24 * 60
        END AS sla_param
    FROM
        {tx_cmsite_header} tch
        LEFT JOIN sla_eventlog approval ON approval.transaction_id = tch.cmsite_id :: varchar
        AND approval.activity_name = 'Approval By Manager NOS'
        LEFT JOIN sla_eventlog closed ON closed.transaction_id = tch.cmsite_id :: varchar
        AND closed.activity_name = 'Work Approval by NOS MGR'
    WHERE
        tch.status NOT IN ('WAITING ACTIVITY APPROVAL', 'CANCELED')
        AND tch.draft_status = 'READY FOR FMS'
),
user_web AS (
    SELECT
        cast(ref_user_id as varchar) as id,
        employee_name,
        email
    FROM
        {tx_user_management}
    WHERE
        is_active
        AND NOT is_delete
),
user_mobile as (
    select
        cast(tx_user_mobile_management_id as varchar) as id,
        employee_name,
        email
    from
        {tx_user_mobile_management} tumm
    where
        is_active
        and not is_delete
),
regional as (
    select
        regional_id,
        regional_name
    from
        {tm_regional}
),
nop as (
    select
        nop_id,
        nop_name
    from
        {tm_nop}
),
cluster as (
    select
        cluster_id,
        cluster_name
    from
        {tm_cluster}
)
SELECT
    tch.ticket_no,
    tch.status,
    tch.draft_status,
    tch.site_id,
    vsm.site_name,
    tch.cm_type,
    tch.cm_urgency,
    tch.issue_category,
    tch.issue_explanation,
    tch.service_layer,
    tch.notes,
    upper(tch.area_id) as area_name,
    r.regional_name,
    n.nop_name,
    c.cluster_name,
    CASE
        WHEN tch.draft_approve_date = DATE '1900-01-01' THEN NULL
        WHEN tch.cm_urgency = 'HIGH' THEN tch.draft_approve_date + INTERVAL '2 days'
        ELSE tch.draft_approve_date + INTERVAL '30 days'
    END AS due_time,
    sla.is_in_sla,
    uw.employee_name as created_by,
    um.employee_name as pic_name,
    tch.created_at,
    e.draft_approve_by_nop,
    e.draft_approve_mgr_nop,
    e.draft_approve_nos,
    e.draft_approve_mgr_nos,
    e.take_over,
    e.request_permit,
    e.follow_up,
    e.check_in,
    e.work_approve_spvto,
    e.work_approve_nop,
    e.work_approve_nos,
    e.work_approve_mgr_nos,
    wfm_schema.get_diff_duration_text_hours(dt.diff_created_to_drat_nop_sec) AS created_to_drat_nop,
    wfm_schema.get_diff_duration_text_hours(dt.diff_drat_nop_to_mgr_nop_sec) AS drat_nop_to_mgr_nop,
    wfm_schema.get_diff_duration_text_hours(dt.diff_draft_mgr_nop_to_nos_sec) AS draft_mgr_nop_to_nos,
    wfm_schema.get_diff_duration_text_hours(dt.diff_draft_nos_to_mgr_nos_sec) AS draft_nos_to_mgr_nos,
    wfm_schema.get_diff_duration_text_hours(dt.diff_draft_mgr_nos_to_takeover_sec) AS draft_mgr_nos_to_takeover,
    wfm_schema.get_diff_duration_text_hours(dt.diff_takeover_to_requestpermit_sec) AS takeover_to_requestpermit,
    wfm_schema.get_diff_duration_text_hours(dt.diff_requestpermit_to_followup_sec) AS requestpermit_to_followup,
    wfm_schema.get_diff_duration_text_hours(dt.diff_followup_to_checkin_sec) AS followup_to_checkin,
    wfm_schema.get_diff_duration_text_hours(dt.diff_checkin_to_spvto_sec) AS checkin_to_spvto,
    wfm_schema.get_diff_duration_text_hours(dt.diff_spvto_to_nop_sec) AS approve_spvto_to_nop,
    wfm_schema.get_diff_duration_text_hours(dt.diff_nop_to_nos_sec) AS approve_nop_to_nos,
    wfm_schema.get_diff_duration_text_hours(dt.diff_nos_to_mgrnos_sec) AS approve_nos_to_mgrnos
FROM
    {tx_cmsite_header} tch
    LEFT JOIN {vw_site_mapping_info} vsm ON tch.site_id = vsm.site_id
    LEFT JOIN user_web uw ON tch.created_by = uw.id
    left join user_mobile um on tch.pic_id = um.id
    left join regional r on tch.regional_id = r.regional_id
    left join nop n on tch.nop_id = n.nop_id
    left join cluster c on tch.cluster_id = c.cluster_id
    left join sla on tch.cmsite_id = sla.cmsite_id
    left join eventlog e on tch.cmsite_id :: varchar = e.transaction_id
    LEFT JOIN tx_diff_time dt ON tch.cmsite_id = dt.cmsite_id
WHERE
    (
        CAST(tch.created_at AS DATE) >= @DateStart
        OR @DateStart = '#1900-01-01#'
    )
    AND (
        CAST(tch.created_at AS DATE) <= @DateEnd
        OR @DateEnd = '#1900-01-01#'
    )
    AND (
        @Area = ''
        OR vsm.area_id = @Area
    )
    AND (
        @Regional = ''
        OR vsm.regional_id = @Regional
    )
    AND (
        @NOP = ''
        OR vsm.nop_id = @NOP
    )
    AND (
        @Cluster = 0
        OR vsm.cluster_id = @Cluster
    )
    AND (
        LOWER(tch.ticket_no) LIKE '%' || LOWER(@Search) || '%'
        OR LOWER(tch.site_id) LIKE '%' || LOWER(@Search) || '%'
    )
    AND (
        tch.cm_type = @Type
        OR @Type = ''
    )
    AND (
        UPPER(tch.status) = UPPER(@Status)
        OR @Status = ''
        OR UPPER(tch.draft_status) = UPPER(@Status)
    )
    AND (
        (
            @IsRelated = 'RELATED'
            AND tch.asset_change = TRUE
        )
        OR (
            @IsRelated = 'NON-RELATED'
            AND tch.asset_change = FALSE
        )
        OR (
            @IsRelated NOT IN ('RELATED', 'NON-RELATED')
        )
    )
    AND (
        tch.vendor_code IS NULL
        OR tch.vendor_code = ''
    )
order by
    tch.cmsite_id asc;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Based on OS syntax v2
-- This query is an updated version of the previous one
-- Current used in sql/SVA/export_ticket_v2.sql
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
WITH eventlog AS (
    SELECT
        transaction_id,
        MAX(
            CASE
                WHEN activity_name = 'Review Draft by NOP'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_by_nop,
        MAX(
            CASE
                WHEN activity_name = 'Approval by Manager NOP'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_mgr_nop,
        MAX(
            CASE
                WHEN activity_name = 'Approval by NOS'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_nos,
        MAX(
            CASE
                WHEN activity_name = 'Approval by Manager NOS'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS draft_approve_mgr_nos,
        MAX(
            CASE
                WHEN lower(action_name) = 'take over' THEN action_on
            END
        ) AS take_over,
        MAX(
            CASE
                WHEN lower(action_name) = 'request permit' THEN action_on
            END
        ) AS request_permit,
        MAX(
            CASE
                WHEN lower(action_name) = 'follow up' THEN action_on
            END
        ) AS follow_up,
        MAX(
            CASE
                WHEN lower(action_name) = 'check in'
                or lower(actioner_name) LIKE '%check in%' THEN action_on
            END
        ) AS check_in,
        MAX(
            CASE
                WHEN activity_name = 'Work Approve by SPVTO'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_spvto,
        MAX(
            CASE
                WHEN activity_name = 'Work Approve by NOP'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_nop,
        MAX(
            CASE
                WHEN activity_name = 'Work Approve by NOS'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_nos,
        MAX(
            CASE
                WHEN activity_name = 'Work Approval by NOS MGR'
                AND action_name = 'Approve' THEN action_on
            END
        ) AS work_approve_mgr_nos
    FROM
        wfm_admin_schema.tx_eventlog
    WHERE
        application_name = 'WFM'
        AND process_id = '46'
        AND (
            lower(action_name) IN (
                'submit',
                'take over',
                'request permit',
                'follow up',
                'check in',
                'approve'
            )
            or lower(actioner_name) = 'check in'
        )
    GROUP BY
        transaction_id
),
tx_diff_time AS (
    SELECT
        tch.cmsite_id,
        EXTRACT(
            EPOCH
            FROM
                (e.request_permit - e.take_over)
        ) AS diff_takeover_to_requestpermit_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.follow_up - e.request_permit)
        ) AS diff_requestpermit_to_followup_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.check_in - e.follow_up)
        ) AS diff_followup_to_checkin_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_spvto - e.check_in)
        ) AS diff_checkin_to_spvto_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_nop - e.work_approve_spvto)
        ) AS diff_spvto_to_nop_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_nos - e.work_approve_nop)
        ) AS diff_nop_to_nos_sec,
        EXTRACT(
            EPOCH
            FROM
                (e.work_approve_mgr_nos - e.work_approve_nos)
        ) AS diff_nos_to_mgrnos_sec
    FROM
        {tx_cmsite_header} tch
        LEFT JOIN eventlog e ON tch.cmsite_id :: varchar = e.transaction_id
    WHERE
        not tch.asset_change
),
sla_eventlog AS (
    SELECT
        transaction_id,
        activity_name,
        action_on
    FROM
        wfm_admin_schema.tx_eventlog
    WHERE
        application_name = 'WFM'
        AND process_id = '46'
        AND activity_name IN (
            'Approval By Manager NOS',
            'Work Approval by NOS MGR'
        )
),
sla as (
    select
        tch.cmsite_id,
        CASE
            WHEN (
                CASE
                    WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
                    ELSE 30 * 24 * 60
                END
            ) >= (
                CASE
                    WHEN tch.closed_at = DATE '1900-01-01' THEN EXTRACT(
                        EPOCH
                        FROM
                            (closed.action_on - approval.action_on)
                    ) / 60
                    ELSE EXTRACT(
                        EPOCH
                        FROM
                            (tch.closed_at - tch.draft_approve_date)
                    ) / 60
                END
            ) THEN TRUE
            ELSE FALSE
        END AS is_in_sla,
        CASE
            WHEN tch.closed_at = DATE '1900-01-01' THEN EXTRACT(
                EPOCH
                FROM
                    (closed.action_on - approval.action_on)
            ) / 60
            ELSE EXTRACT(
                EPOCH
                FROM
                    (tch.closed_at - tch.draft_approve_date)
            ) / 60
        END AS mttr,
        tch.ready_for_fms_time + (
            CASE
                WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
                ELSE 30 * 24 * 60
            END
        ) * INTERVAL '1 minute' AS sla_end,
        CASE
            WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
            ELSE 30 * 24 * 60
        END AS sla_param
    FROM
        {tx_cmsite_header} tch
        LEFT JOIN sla_eventlog approval ON approval.transaction_id = tch.cmsite_id :: varchar
        AND approval.activity_name = 'Approval By Manager NOS'
        LEFT JOIN sla_eventlog closed ON closed.transaction_id = tch.cmsite_id :: varchar
        AND closed.activity_name = 'Work Approval by NOS MGR'
    WHERE
        tch.status NOT IN ('WAITING ACTIVITY APPROVAL', 'CANCELED')
        AND tch.draft_status = 'READY FOR FMS'
),
user_web AS (
    SELECT
        cast(ref_user_id as varchar) as id,
        employee_name,
        email
    FROM
        {tx_user_management}
    WHERE
        is_active
        AND NOT is_delete
),
user_mobile as (
    select
        cast(tx_user_mobile_management_id as varchar) as id,
        employee_name,
        email
    from
        {tx_user_mobile_management} tumm
    where
        is_active
        and not is_delete
),
regional as (
    select
        regional_id,
        regional_name
    from
        {tm_regional}
),
nop as (
    select
        nop_id,
        nop_name
    from
        {tm_nop}
),
cluster as (
    select
        cluster_id,
        cluster_name
    from
        {tm_cluster}
)
SELECT
    tch.ticket_no,
    tch.status,
    tch.draft_status,
    tch.site_id,
    vsm.site_name,
    tch.cm_type,
    tch.cm_urgency,
    tch.issue_category,
    tch.issue_explanation,
    tch.service_layer,
    tch.notes,
    upper(tch.area_id) as area_name,
    r.regional_name,
    n.nop_name,
    c.cluster_name,
    sla.is_in_sla,
    uw.employee_name as created_by,
    um.employee_name as pic_name,
    CASE
        WHEN EXTRACT(YEAR FROM tch.created_at) = 1900 THEN NULL
        ELSE tch.created_at
    END AS created_at,
    CASE
        WHEN EXTRACT(YEAR FROM tch.ready_for_fms_time) = 1900 THEN NULL
        ELSE tch.ready_for_fms_time
    END AS ready_for_fms_time,
    CASE
        WHEN EXTRACT(YEAR FROM e.take_over) = 1900 THEN NULL
        ELSE e.take_over
    END AS take_over,
    CASE
        WHEN EXTRACT(YEAR FROM e.request_permit) = 1900 THEN NULL
        ELSE e.request_permit
    END AS request_permit,
    CASE
        WHEN EXTRACT(YEAR FROM e.follow_up) = 1900 THEN NULL
        ELSE e.follow_up
    END AS follow_up,
    CASE
        WHEN EXTRACT(YEAR FROM e.check_in) = 1900 THEN NULL
        ELSE e.check_in
    END AS check_in,
    CASE
        WHEN EXTRACT(YEAR FROM tch.submit_date) = 1900 THEN NULL
        ELSE tch.submit_date
    END AS submit_date,
    CASE
        WHEN EXTRACT(YEAR FROM tch.closed_at) = 1900 THEN NULL
        ELSE tch.closed_at
    END AS closed_at,
    CASE
        WHEN tch.draft_approve_date = DATE '1900-01-01' THEN NULL
        WHEN tch.cm_urgency = 'HIGH' THEN tch.draft_approve_date + INTERVAL '2 days'
        ELSE tch.draft_approve_date + INTERVAL '30 days'
    END AS due_time,
    CASE
        WHEN EXTRACT(YEAR FROM e.work_approve_spvto) = 1900 THEN NULL
        ELSE e.work_approve_spvto
    END AS work_approve_spvto,
    CASE
        WHEN EXTRACT(YEAR FROM e.work_approve_nop) = 1900 THEN NULL
        ELSE e.work_approve_nop
    END AS work_approve_nop,
    CASE
        WHEN EXTRACT(YEAR FROM e.work_approve_nos) = 1900 THEN NULL
        ELSE e.work_approve_nos
    END AS work_approve_nos,
    CASE
        WHEN EXTRACT(YEAR FROM e.work_approve_mgr_nos) = 1900 THEN NULL
        ELSE e.work_approve_mgr_nos
    END AS work_approve_mgr_nos,
    wfm_schema.get_diff_duration_text_hours(dt.diff_takeover_to_requestpermit_sec) AS takeover_to_requestpermit,
    wfm_schema.get_diff_duration_text_hours(dt.diff_requestpermit_to_followup_sec) AS requestpermit_to_followup,
    wfm_schema.get_diff_duration_text_hours(dt.diff_followup_to_checkin_sec) AS followup_to_checkin,
    wfm_schema.get_diff_duration_text_hours(dt.diff_checkin_to_spvto_sec) AS checkin_to_spvto,
    wfm_schema.get_diff_duration_text_hours(dt.diff_spvto_to_nop_sec) AS approve_spvto_to_nop,
    wfm_schema.get_diff_duration_text_hours(dt.diff_nop_to_nos_sec) AS approve_nop_to_nos,
    wfm_schema.get_diff_duration_text_hours(dt.diff_nos_to_mgrnos_sec) AS approve_nos_to_mgrnos
FROM
    {tx_cmsite_header} tch
    LEFT JOIN {vw_site_mapping_info} vsm ON tch.site_id = vsm.site_id
    LEFT JOIN user_web uw ON tch.created_by = uw.id
    left join user_mobile um on tch.pic_id = um.id
    left join regional r on tch.regional_id = r.regional_id
    left join nop n on tch.nop_id = n.nop_id
    left join cluster c on tch.cluster_id = c.cluster_id
    left join sla on tch.cmsite_id = sla.cmsite_id
    left join eventlog e on tch.cmsite_id :: varchar = e.transaction_id
    LEFT JOIN tx_diff_time dt ON tch.cmsite_id = dt.cmsite_id
where
    (
        CAST(tch.created_at AS DATE) >= @DateStart
        OR @DateStart = '#1900-01-01#'
    )
    AND (
        CAST(tch.created_at AS DATE) <= @DateEnd
        OR @DateEnd = '#1900-01-01#'
    )
    AND (
        @Area = ''
        OR vsm.area_id = @Area
    )
    AND (
        @Regional = ''
        OR vsm.regional_id = @Regional
    )
    AND (
        @NOP = ''
        OR vsm.nop_id = @NOP
    )
    AND (
        @Cluster = 0
        OR vsm.cluster_id = @Cluster
    )
    AND (
        LOWER(tch.ticket_no) LIKE '%' || LOWER(@Search) || '%'
        OR LOWER(tch.site_id) LIKE '%' || LOWER(@Search) || '%'
    )
    AND (
        tch.cm_type = @Type
        OR @Type = ''
    )
    AND (
        UPPER(tch.status) = UPPER(@Status)
        OR @Status = ''
        OR UPPER(tch.draft_status) = UPPER(@Status)
    )
    AND (
        (
            @IsRelated = 'RELATED'
            AND tch.asset_change = TRUE
        )
        OR (
            @IsRelated = 'NON-RELATED'
            AND tch.asset_change = FALSE
        )
        OR (
            @IsRelated NOT IN ('RELATED', 'NON-RELATED')
        )
    )
    AND (
        tch.vendor_code IS NULL
        OR tch.vendor_code = ''
    )
order by
    tch.cmsite_id asc;