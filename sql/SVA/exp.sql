WITH user_web AS (
    SELECT
        CAST(ref_user_id AS varchar) AS id,
        employee_name,
        email
    FROM
        wfm_schema.tx_user_management
    WHERE
        is_active
        AND NOT is_delete
),
user_mobile AS (
    SELECT
        CAST(tx_user_mobile_management_id AS varchar) AS id,
        employee_name,
        email
    FROM
        wfm_schema.tx_user_mobile_management
    WHERE
        is_active
        AND NOT is_delete
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
        wfm_schema.tx_cmsite_header tch
        LEFT JOIN sla_eventlog approval ON approval.transaction_id = tch.cmsite_id :: varchar
        AND approval.activity_name = 'Approval By Manager NOS'
        LEFT JOIN sla_eventlog closed ON closed.transaction_id = tch.cmsite_id :: varchar
        AND closed.activity_name = 'Work Approval by NOS MGR'
    WHERE
        tch.status NOT IN ('WAITING ACTIVITY APPROVAL', 'CANCELED')
        AND tch.draft_status = 'READY FOR FMS'
)
select
    tch.cmsite_id,
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
    vcc.total_price,
    tch.notes,
    UPPER(tch.area_id) AS area_id,
    vsm.area_name,
    vsm.regional_name,
    vsm.nop_name,
    vsm.cluster_name,
    CASE
        WHEN tch.draft_approve_date = DATE '1900-01-01' THEN NULL
        WHEN tch.cm_urgency = 'HIGH' THEN tch.draft_approve_date + INTERVAL '2 days'
        ELSE tch.draft_approve_date + INTERVAL '30 days'
    END AS due_time,
    sla.is_sla,
    uw.employee_name AS created_by,
    um.employee_name AS pic_name,
    tch.created_at,
    tch.take_over_at,
    tch.request_permit_at,
    tch.follow_up_at,
    tch.checkin_at,
    tch.closed_at
FROM
    wfm_schema.tx_cmsite_header tch
    LEFT JOIN user_web uw ON tch.created_by = uw.id
    LEFT JOIN user_mobile um ON tch.pic_id = um.id
    LEFT JOIN wfm_schema.vw_site_mapping_info vsm ON tch.site_id = vsm.site_id
    LEFT JOIN sla ON tch.cmsite_id = sla.cmsite_id
    left join wfm_schema.vw_cm_catalog vcc on tch.cmsite_id = vcc.cmsite_id;

-- alter table wfm_schema.tx_cmsite_header
WITH user_web AS (
    SELECT
        CAST(ref_user_id AS varchar) AS id,
        employee_name,
        email
    FROM
        { tx_user_management }
    WHERE
        is_active
        AND NOT is_delete
),
user_mobile AS (
    SELECT
        CAST(tx_user_mobile_management_id AS varchar) AS id,
        employee_name,
        email
    FROM
        { tx_user_mobile_management }
    WHERE
        is_active
        AND NOT is_delete
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
        { tx_cmsite_header } tch
        LEFT JOIN sla_eventlog approval ON approval.transaction_id = tch.cmsite_id :: varchar
        AND approval.activity_name = 'Approval By Manager NOS'
        LEFT JOIN sla_eventlog closed ON closed.transaction_id = tch.cmsite_id :: varchar
        AND closed.activity_name = 'Work Approval by NOS MGR'
    WHERE
        tch.status NOT IN ('WAITING ACTIVITY APPROVAL', 'CANCELED')
        AND tch.draft_status = 'READY FOR FMS'
)
select
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
    tch.take_over_at,
    tch.request_permit_at,
    tch.follow_up_at,
    tch.checkin_at,
    tch.closed_at
FROM
    { tx_cmsite_header } tch
    LEFT JOIN { vw_site_mapping_info } vsm ON tch.site_id = vsm.site_id
    LEFT JOIN user_web uw ON tch.created_by = uw.id
    LEFT JOIN user_mobile um ON tch.pic_id = um.id
    LEFT JOIN sla ON tch.cmsite_id = sla.cmsite_id
    left join { vw_cm_catalog } vcc on tch.cmsite_id = vcc.cmsite_id
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
        tch.status = @Status
        OR @Status = ''
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
ORDER BY
    tch.cmsite_id ASC;

-- 
-- 
SELECT
    tch.ticket_no,
    vsm.cluster_name,
    vsm.nop_name,
    vsm.regional_name,
    vsm.area_name,
    CASE
        WHEN tcci.is_add_other THEN tcci.catalog_name_other
        ELSE cat.catalog_name
    END AS catalog_name,
    tcci.quantity,
    CAST(
        CASE
            WHEN tcci.is_add_other = true
            OR (
                cat.catalog_price_other IS NOT NULL
                AND cat.catalog_price_other <> ''
            ) THEN CAST(tcci.catalog_price_other AS INTEGER)
            WHEN cat.lumpsum_qty <> 0 THEN 0
            WHEN cat.catalog_price_other IS NULL
            OR cat.catalog_price_other = '' THEN cat.catalog_price
            ELSE CAST(tcci.catalog_price_other AS INTEGER)
        END AS BIGINT
    ) AS price,
    tcci.total,
    tcci.remark
FROM
    {tx_cmsite_header} tch
    INNER JOIN {vw_site_mapping_info} vsm ON tch.site_id = vsm.site_id
    LEFT JOIN {tx_cmsite_catalog_item} tcci ON tch.cmsite_id = tcci.cmsite_header_id
    LEFT JOIN {tm_catalog} cat ON tcci.catalog_id = cat.catalog_id
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
        tch.status = @Status
        OR @Status = ''
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
ORDER BY
    tch.cmsite_id ASC;