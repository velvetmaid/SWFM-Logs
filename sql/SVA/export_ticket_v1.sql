-- Based on OS synax
WITH user_web AS (
    SELECT
        CAST(ref_user_id AS varchar) AS id,
        employee_name,
        email
    FROM
        {tx_user_management}
    group by
        ref_user_id,
        employee_name,
        email
),
user_mobile AS (
    SELECT
        CAST(tx_user_mobile_management_id AS varchar) AS id,
        employee_name,
        email
    FROM
        {tx_user_mobile_management}
    group by
        tx_user_mobile_management_id,
        employee_name,
        email
),
sla_eventlog AS (
    SELECT
        transaction_id,
        activity_name,
        max(action_on) as action_on
    FROM
        wfm_admin_schema.tx_eventlog
    WHERE
        application_name = 'WFM'
        AND process_id = '46'
        AND activity_name IN (
            'Approval By Manager NOS',
            'Work Approval by NOS MGR'
        )
    group by
        transaction_id,
        activity_name
),
sla AS (
    SELECT
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
        END AS is_sla
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
activity AS (
    SELECT 
        cmsite_header_id, 
        asset_activity_category_name 
    FROM 
        {tx_cmsite_assetrelatedactivity} 
    where 
        asset_activity_category_name <> ''

)
select
    tch.ticket_no,
    tch.status,
    tch.draft_status,
    tch.site_id,
    vsm.site_name,
    tch.cm_type,
    tch.cm_urgency,
    activity.asset_activity_category_name,
    tch.issue_category,
    tch.issue_explanation,
    tch.service_layer,
    tch.notes,
    vsm.area_name,
    vsm.regional_name,
    vsm.nop_name,
    vsm.cluster_name,
    vcc.total_price,
    CASE
        WHEN tch.draft_approve_date = DATE '1900-01-01' THEN NULL
        WHEN tch.cm_urgency = 'HIGH' THEN tch.draft_approve_date + INTERVAL '2 days'
        ELSE tch.draft_approve_date + INTERVAL '30 days'
    END AS due_time,
    sla.is_sla,
    uw.employee_name AS created_by,
    um.employee_name AS pic_name,
    tch.created_at,
    tch.draft_approve_date AS draft_approve_at,
    tch.ready_for_fms_time AS ready_for_fms_at,
    tch.take_over_at,
    tch.request_permit_at,
    tch.follow_up_at,
    tch.checkin_at,
    tch.submit_date as submit_at,
    tch.closed_at
FROM
    {tx_cmsite_header} tch
    LEFT JOIN {vw_site_mapping_info} vsm ON tch.site_id = vsm.site_id
    LEFT JOIN user_web uw ON tch.created_by = uw.id
    LEFT JOIN user_mobile um ON tch.pic_id = um.id
    LEFT JOIN sla ON tch.cmsite_id = sla.cmsite_id
    LEFT JOIN activity ON activity.cmsite_header_id = tch.cmsite_id
    left join {vw_cm_catalog} vcc on tch.cmsite_id = vcc.cmsite_id
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
ORDER BY
    tch.cmsite_id ASC;