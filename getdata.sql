-- User Web
SELECT
    a.employee_name,
    a.email,
    a.area_id,
    c.regional_name,
    b.nop_name
FROM
    wfm_schema.tx_user_management a
    LEFT JOIN wfm_schema.tm_nop b ON a.nop_id = b.nop_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
WHERE
    a.is_active = TRUE
    AND a.is_delete = FALSE;

-- User Mobile
SELECT
    a.employee_name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name,
    string_agg(DISTINCT t.name :: text, ', ' :: text) AS role_name
FROM
    wfm_schema.tx_user_mobile_management a
    LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
    LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
    LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
    INNER JOIN wfm_schema.mapping_user_mobile_role m ON a.tx_user_mobile_management_id = m.tx_user_mobile_management_id
    INNER JOIN wfm_schema.tm_user_role t ON m.role_id = t.tm_user_role_id
WHERE
    a.is_active = TRUE
    AND a.is_delete = FALSE
    AND (
        t.code = 'MUSERTS'
        OR t.code = 'MUSERMBP'
    )
GROUP BY
    a.employee_name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name;

SELECT
    a.employee_name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name
FROM
    wfm_schema.tx_user_management a
    LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
    LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
    LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
WHERE
    a.is_active = TRUE
    AND a.is_delete = FALSE;

-- GET CLUSTER BY NOP
select
    *
from
    wfm_schema.tm_nop tn
    inner join wfm_schema.tm_mapping_cluster_nop tmcn on tn.nop_id = tmcn.nop_id
    inner join wfm_schema.tm_cluster tc on tmcn.cluster_id = tc.cluster_id
where
    tn.nop_name = 'NOP BOGOR'