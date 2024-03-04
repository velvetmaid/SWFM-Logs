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
    e.cluster_name
FROM
    wfm_schema.tx_user_mobile_management a
    LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
    LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
    LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
WHERE
    a.area_id = 'Area4';

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
    a.area_id = 'Area4';