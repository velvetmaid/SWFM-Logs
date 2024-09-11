CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to_nop AS WITH spv_wo_to AS (
    SELECT
        a.phone_number,
        a.nop_id,
        b.nop_name,
        e.cluster_id
    FROM
        wfm_schema.tx_user_management a
        JOIN wfm_schema.tm_nop b ON b.nop_id = a.nop_id
        JOIN wfm_schema.tx_user_role c ON c.ref_user_id = a.ref_user_id
        JOIN wfm_schema.tm_user_role d ON d.tm_user_role_id = c.role_id
        JOIN wfm_schema.tm_mapping_cluster_nop e ON a.nop_id = e.nop_id
    WHERE
        a.is_active = true
        AND a.is_delete = false
        AND d.code = 'SVTO'
        AND (
            a.nop_id <> ''
            AND a.cluster_id = 0
        )
    GROUP BY
        a.phone_number,
        a.nop_id,
        b.nop_name,
        e.cluster_id
    order by
        a.phone_number
),
msg_spv_to AS (
    SELECT
        a.cluster_id,
        a.message
    FROM
        wfm_schema.vw_message_spv_to_cluster a
)
SELECT
    a.phone_number,
    b.message
FROM
    spv_wo_to a
    JOIN msg_spv_to b ON a.cluster_id = b.cluster_id
group by
    a.phone_number,
    a.cluster_id,
    b.message
order by
    a.phone_number,
    a.cluster_id