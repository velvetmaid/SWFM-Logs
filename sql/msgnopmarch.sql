-- wfm_schema.vw_message_spv_to_nop source
CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to_nop AS WITH spv_wo_to AS (
    SELECT
        a_1.phone_number,
        a_1.nop_id,
        b_1.nop_name,
        e.cluster_id
    FROM
        wfm_schema.tx_user_management a_1
        JOIN wfm_schema.tm_nop b_1 ON b_1.nop_id :: text = a_1.nop_id :: text
        JOIN wfm_schema.tx_user_role c ON c.ref_user_id = a_1.ref_user_id
        JOIN wfm_schema.tm_user_role d ON d.tm_user_role_id = c.role_id
        JOIN wfm_schema.tm_mapping_cluster_nop e ON a_1.nop_id :: text = e.nop_id :: text
    WHERE
        a_1.is_active = true
        AND a_1.is_delete = false
        AND d.code :: text = 'SVTO' :: text
        AND a_1.nop_id :: text <> '' :: text
        AND a_1.cluster_id = 0
    GROUP BY
        a_1.phone_number,
        a_1.nop_id,
        b_1.nop_name,
        e.cluster_id
    ORDER BY
        a_1.phone_number
),
msg_spv_to AS (
    SELECT
        a_1.cluster_id,
        a_1.message
    FROM
        wfm_schema.vw_message_spv_to_cluster a_1
)
SELECT
    a.phone_number,
    b.message
FROM
    spv_wo_to a
    JOIN msg_spv_to b ON a.cluster_id = b.cluster_id
GROUP BY
    a.phone_number,
    a.cluster_id,
    b.message
ORDER BY
    a.phone_number,
    a.cluster_id;