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
GROUP BY
    a.employee_name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name;

-- User Web
SELECT
    a.employee_name as name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name,
    string_agg(DISTINCT t.name :: text, ', ' :: text) AS role_name
FROM
    wfm_schema.tx_user_management a
    LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
    LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
    LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
    INNER JOIN wfm_schema.tx_user_role tu ON a.ref_user_id = tu.ref_user_id
    INNER JOIN wfm_schema.tm_user_role t ON tu.role_id = t.tm_user_role_id
WHERE
    a.is_active = TRUE
    AND a.is_delete = FALSE
GROUP BY
    a.employee_name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name
ORDER BY
    a.employee_name;

-- User Web
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
    AND a.is_delete = FALSE
ORDER BY
    a.employee_name;

-- GET CLUSTER BY NOP
select
    *
from
    wfm_schema.tm_nop tn
    inner join wfm_schema.tm_mapping_cluster_nop tmcn on tn.nop_id = tmcn.nop_id
    inner join wfm_schema.tm_cluster tc on tmcn.cluster_id = tc.cluster_id
where
    tn.nop_name = 'NOP BOGOR'



-- User Web and Mobile Combined
SELECT
    a.employee_name AS name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name,
    string_agg(DISTINCT t.name::text, ', ') AS role_name,
    'WEB' AS source_user
FROM
    wfm_schema.tx_user_management a
    LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
    LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
    LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
    INNER JOIN wfm_schema.tx_user_role tu ON a.ref_user_id = tu.ref_user_id
    INNER JOIN wfm_schema.tm_user_role t ON tu.role_id = t.tm_user_role_id
WHERE
    a.is_active = TRUE
    AND a.is_delete = FALSE
GROUP BY
    a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
UNION
SELECT
    a.employee_name AS name,
    a.email,
    b.area_name,
    c.regional_name,
    d.nop_name,
    e.cluster_name,
    string_agg(DISTINCT t.name::text, ', ') AS role_name,
    'MOBILE' AS source_user
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
GROUP BY
    a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
ORDER BY name;


-- User Web and Mobile Combined with Full Outer Join
WITH web_users AS (
    SELECT
        a.employee_name AS name,
        a.email,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_web
    FROM
        wfm_schema.tx_user_management a
        LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
        LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
        LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
        LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
        INNER JOIN wfm_schema.tx_user_role tu ON a.ref_user_id = tu.ref_user_id
        INNER JOIN wfm_schema.tm_user_role t ON tu.role_id = t.tm_user_role_id
    WHERE
        a.is_active = TRUE
        AND a.is_delete = FALSE
    GROUP BY
        a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
),
mobile_users AS (
    SELECT
        a.employee_name AS name,
        a.email,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_mobile
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
    GROUP BY
        a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
)
SELECT
    COALESCE(w.email, m.email) AS email,
    COALESCE(w.name, m.name) AS name,
    COALESCE(w.area_name, m.area_name) AS area_name,
    COALESCE(w.regional_name, m.regional_name) AS regional_name,
    COALESCE(w.nop_name, m.nop_name) AS nop_name,
    COALESCE(w.cluster_name, m.cluster_name) AS cluster_name,
    CONCAT_WS(', ', w.role_web, m.role_mobile) AS role_name,
    CASE 
        WHEN w.email IS NOT NULL AND m.email IS NOT NULL THEN 'WEB, MOBILE'
        WHEN w.email IS NOT NULL THEN 'WEB'
        WHEN m.email IS NOT NULL THEN 'MOBILE'
        ELSE 'UNKNOWN'
    END AS source_user
FROM web_users w
FULL OUTER JOIN mobile_users m ON w.email = m.email
ORDER BY name;


-- 
WITH combined_users AS (
    SELECT
        a.employee_name AS name,
        a.email,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_name,
        'WEB' AS source_user
    FROM
        wfm_schema.tx_user_management a
        LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
        LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
        LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
        LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
        INNER JOIN wfm_schema.tx_user_role tu ON a.ref_user_id = tu.ref_user_id
        INNER JOIN wfm_schema.tm_user_role t ON tu.role_id = t.tm_user_role_id
    WHERE
        a.is_active = TRUE
        AND a.is_delete = FALSE
    GROUP BY
        a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
    UNION ALL
    SELECT
        a.employee_name AS name,
        a.email,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_name,
        'MOBILE' AS source_user
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
    GROUP BY
        a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
)
SELECT
    MIN(name) AS name,
    email,
    MIN(area_name) AS area_name,
    MIN(regional_name) AS regional_name,
    MIN(nop_name) AS nop_name,
    MIN(cluster_name) AS cluster_name,
    string_agg(DISTINCT role_name, ', ') AS role_name,
    string_agg(DISTINCT source_user, ', ') AS source_user
FROM
    combined_users
GROUP BY
    email
ORDER BY
    name;

-- 
WITH combined_users AS (
    SELECT
        a.employee_name AS name,
        a.email,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_name,
        'WEB' AS source_user
    FROM
        wfm_schema.tx_user_management a
        LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
        LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
        LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
        LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
        INNER JOIN wfm_schema.tx_user_role tu ON a.ref_user_id = tu.ref_user_id
        INNER JOIN wfm_schema.tm_user_role t ON tu.role_id = t.tm_user_role_id
    WHERE
        a.is_active = TRUE
        AND a.is_delete = FALSE
    GROUP BY
        a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
    UNION ALL
    SELECT
        a.employee_name AS name,
        a.email,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_name,
        'MOBILE' AS source_user
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
    GROUP BY
        a.employee_name, a.email, b.area_name, c.regional_name, d.nop_name, e.cluster_name
)
SELECT
    MIN(name) AS name,
    email,
    MIN(area_name) AS area_name,
    MIN(regional_name) AS regional_name,
    MIN(nop_name) AS nop_name,
    MIN(cluster_name) AS cluster_name,
    string_agg(DISTINCT role_name, ', ') AS role_name,
    string_agg(DISTINCT source_user, ', ') AS source_user,
    CASE 
        WHEN email ILIKE '%@telkomsel%' THEN TRUE
        ELSE FALSE
    END AS is_telkomsel_user
FROM
    combined_users
GROUP BY
    email
ORDER BY
    name;
