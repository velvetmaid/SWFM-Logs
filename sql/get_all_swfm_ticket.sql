-- INAP
(
    SELECT
        'INAP' as prefix,
        ticket_no,
        site_id,
        ticket_type,
        status,
        created_at,
        closed_at
    FROM
        wfm_schema.tx_ticket_terr_opr
)
UNION ALL
-- SVA
(
    SELECT
        'SVA' as prefix,
        ticket_no,
        site_id,
        cm_type as ticket_type,
        status,
        created_at,
        closed_at
    FROM
        wfm_schema.tx_cmsite_header
)
UNION ALL
-- FNA
(
    SELECT
        'FNA' as prefix,
        no_ticket as ticket_no,
        site_id,
        concat (category, ' ', ticket_subject) as ticket_type,
        status,
        created_at,
        approve_time as closed_at
    FROM
        wfm_schema.ticket_technical_support
)
UNION ALL
-- PM
(
    SELECT
        'PM' as prefix,
        a.pm_ticket_site_id as ticket_no,
        a.tx_site_id as site_id,
        b.type_site_name as ticket_type,
        a.status,
        a.created_at,
        a.approved_at as closed_at
    FROM
        wfm_schema.tx_pm_ticket_site a
        left join wfm_schema.tm_type_site b on a.type_site_id = b.type_site_id
)
UNION ALL
-- ASG
(
    SELECT
        'ASG' as prefix,
        no_ticket as ticket_no,
        site_id,
        CONCAT (
            'PJS - ',
            CASE
                WHEN type_pengamanan_site_id = 1 THEN 'REGULER'
                WHEN type_pengamanan_site_id = 2 THEN '24 JAM'
            END
        ) AS ticket_type,
        approve_status as status,
        created_at,
        approve_at as closed_at
    FROM
        wfm_schema.asset_safe_guard
)
-- PKM
UNION ALL
(
    SELECT
        'PKM' as prefix,
        ticket_no,
        site_id,
        'PENCATATAN KWH METER' as ticket_type,
        status,
        created_at,
        approve_at as closed_at
    FROM
        wfm_schema.tx_recap_pln
)
UNION ALL
-- PTL
(
    SELECT
        'PTL' as prefix,
        ticket_no,
        site_id,
        'PENGISIAN TOKEN LISTRIK' as ticket_type,
        status,
        created_at,
        acknowledge_nop_at as closed_at
    FROM
        wfm_schema.tx_pengisian_token_listrik_header
)
-- CGL
UNION ALL
(
    SELECT
        'CGL' as prefix,
        a.ticket_no,
        a.site_id,
        'IMBAS PETIR' as ticket_type,
        a.status,
        a.request_date,
        b.created_on as closed_at
    FROM
        wfm_schema.tx_cgl a
        INNER JOIN (
            SELECT
                *
            FROM
                wfm_admin_schema.tx_eventlog
            WHERE
                process_name = 'CGL'
                AND action_name = 'COMPLETED SPE RELEASED'
            ORDER BY
                created_on DESC
            LIMIT
                1
        ) b ON a.tx_cgl_id::varchar = b.transaction_id
)
-- BBM
UNION ALL
(
    SELECT
        'BBM' as prefix,
        ticket_number as ticket_no,
        site_id,
        category as ticket_type,
        status,
        created_at,
        approve_time as closed_at
    FROM
        wfm_schema.tx_bbm_genset_refill
)