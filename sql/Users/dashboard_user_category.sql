WITH
-- ACTIVE USERS
web_active AS (
   SELECT email FROM wfm_schema.tx_user_management
   WHERE is_active AND NOT is_delete AND email IS NOT NULL
),
mobile_active AS (
   SELECT email FROM wfm_schema.tx_user_mobile_management
   WHERE is_active AND NOT is_delete AND email IS NOT NULL
),
-- INACTIVE USERS
web_inactive AS (
   SELECT email FROM wfm_schema.tx_user_management
   WHERE NOT (is_active AND NOT is_delete) AND email IS NOT NULL
),
mobile_inactive AS (
   SELECT email FROM wfm_schema.tx_user_mobile_management
   WHERE NOT (is_active AND NOT is_delete) AND email IS NOT NULL
),
-- LDAP TELKOMSEL ACTIVE
ldap_tsel_web AS (
    SELECT email FROM wfm_schema.tx_user_management
    WHERE is_active AND NOT is_delete AND email LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%' AND email IS NOT NULL
),
ldap_tsel_mobile AS (
    SELECT email FROM wfm_schema.tx_user_mobile_management
    WHERE is_active AND NOT is_delete AND email LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%' AND email IS NOT NULL
),
-- NON-LDAP TELKOMSEL ACTIVE
nonldap_tsel_web AS (
    SELECT email FROM wfm_schema.tx_user_management
    WHERE is_active AND NOT is_delete AND email LIKE '%_x@telkomsel%' AND email IS NOT NULL
),
nonldap_tsel_mobile AS (
    SELECT email FROM wfm_schema.tx_user_mobile_management
    WHERE is_active AND NOT is_delete AND email LIKE '%_x@telkomsel%' AND email IS NOT NULL
),
-- NON-TELKOMSEL ACTIVE
non_tsel_web AS (
    SELECT email FROM wfm_schema.tx_user_management
    WHERE is_active AND NOT is_delete AND email NOT LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%' AND email IS NOT NULL
),
non_tsel_mobile AS (
    SELECT email FROM wfm_schema.tx_user_mobile_management
    WHERE is_active AND NOT is_delete AND email NOT LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%' AND email IS NOT NULL
)
-- FINAL SELECT
SELECT * FROM (
   SELECT
       'Active User' AS label,
       (SELECT COUNT(*) FROM (SELECT email FROM web_active UNION SELECT email FROM mobile_active) AS total_unique) AS value,
       'fas6 fa6-user-check' AS icon,
       'rgb(0, 200, 0)' AS color
   UNION ALL
   SELECT
       'Inactive User',
       (SELECT COUNT(*) FROM (SELECT email FROM web_inactive UNION SELECT email FROM mobile_inactive) AS total_unique),
       'fas6 fa6-user-slash',
       'rgb(200, 0, 0)'
   UNION ALL
    SELECT
        'LDAP Telkomsel Active',
        (SELECT COUNT(*) FROM (SELECT email FROM ldap_tsel_web UNION SELECT email FROM ldap_tsel_mobile) AS total_unique),
        'fas6 fa6-id-card',
        'rgb(255, 0, 0)'
    UNION ALL
    SELECT
        'Non-LDAP Telkomsel Active',
        (SELECT COUNT(*) FROM (SELECT email FROM nonldap_tsel_web UNION SELECT email FROM nonldap_tsel_mobile) AS total_unique),
        'fas6 fa6-user-secret',
        'rgb(0, 0, 255)'
    UNION ALL
    SELECT
        'Non-Telkomsel Active',
        (SELECT COUNT(*) FROM (SELECT email FROM non_tsel_web UNION SELECT email FROM non_tsel_mobile) AS total_unique),
        'fas6 fa6-user-astronaut',
        'rgb(255, 255, 0)'
) AS data
ORDER BY label;

-- ALTER Query
-- This query counts the number of users in various categories, including active and inactive users, as well as those from Telkomsel and non-Telkomsel domains, both for web and mobile platforms.
-- It also distinguishes between LDAP and non-LDAP users based on their email addresses.
WITH 
filtered_user_web AS (
    SELECT email, is_active, is_delete
    FROM {tx_user_management}
    WHERE email IS NOT NULL
    AND ((@Area = '') OR (area_id = @Area)) 
    AND ((@Regional = '') OR (regional_id = @Regional)) 
    AND ((@NOP = '') OR (nop_id = @NOP))
    AND ((@Cluster = 0) OR (cluster_id = @Cluster))
),
filtered_user_mobile AS (
    SELECT email, is_active, is_delete
    FROM {tx_user_mobile_management}
    WHERE email IS NOT NULL
    AND ((@Area = '') OR (area_id = @Area)) 
    AND ((@Regional = '') OR (regional_id = @Regional)) 
    AND ((@NOP = '') OR (nop_id = @NOP))
    AND ((@Cluster = 0) OR (cluster_id = @Cluster))
),
-- ACTIVE USERS
active_web AS (
    SELECT email FROM filtered_user_web
    WHERE is_active AND NOT is_delete
),
active_mobile AS (
    SELECT email FROM filtered_user_mobile
    WHERE is_active AND NOT is_delete
),
-- INACTIVE USERS
inactive_web AS (
    SELECT email FROM filtered_user_web
    WHERE NOT (is_active AND NOT is_delete)
),
inactive_mobile AS (
    SELECT email FROM filtered_user_mobile
    WHERE NOT (is_active AND NOT is_delete)
),
-- LDAP TELKOMSEL
ldap_tsel_web AS (
    SELECT email FROM active_web
    WHERE email LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%'
),
ldap_tsel_mobile AS (
    SELECT email FROM active_mobile
    WHERE email LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%'
),
-- NON-LDAP TELKOMSEL
nonldap_tsel_web AS (
    SELECT email FROM active_web
    WHERE email LIKE '%_x@telkomsel%'
),
nonldap_tsel_mobile AS (
    SELECT email FROM active_mobile
    WHERE email LIKE '%_x@telkomsel%'
),
-- NON-TELKOMSEL
non_tsel_web AS (
    SELECT email FROM active_web
    WHERE email NOT LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%'
),
non_tsel_mobile AS (
    SELECT email FROM active_mobile
    WHERE email NOT LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%'
)
-- FINAL SELECT (dashboard format)
SELECT * FROM (
    SELECT
        'Active User' AS label,
        (SELECT COUNT(*) FROM (SELECT email FROM active_web UNION SELECT email FROM active_mobile) AS total_unique) AS value,
        'fas6 fa6-user-check' AS icon,
        'rgba(0, 200, 10, 1)' AS color
    UNION ALL
    SELECT
        'Inactive User',
        (SELECT COUNT(*) FROM (SELECT email FROM inactive_web UNION SELECT email FROM inactive_mobile) AS total_unique),
        'fas6 fa6-user-slash',
        'rgba(200, 0, 0, 1)'
    UNION ALL
    SELECT
        'LDAP Telkomsel Active',
        (SELECT COUNT(*) FROM (SELECT email FROM ldap_tsel_web UNION SELECT email FROM ldap_tsel_mobile) AS total_unique),
        'fas6 fa6-id-card',
        'rgba(255, 0, 0, 1)'
    UNION ALL
    SELECT
        'Non-LDAP Telkomsel Active',
        (SELECT COUNT(*) FROM (SELECT email FROM nonldap_tsel_web UNION SELECT email FROM nonldap_tsel_mobile) AS total_unique),
        'fas6 fa6-user-secret',
        'rgba(0, 0, 255, 1)'
    UNION ALL
    SELECT
        'Non-Telkomsel Active',
        (SELECT COUNT(*) FROM (SELECT email FROM non_tsel_web UNION SELECT email FROM non_tsel_mobile) AS total_unique),
        'fas6 fa6-user-astronaut',
        'rgba(150, 0, 200, 1)'
) AS data
ORDER BY label;


--TEST OUTPUT
WITH combined_users AS (
    SELECT
        a.employee_name AS name,
        a.email,
        a.phone_number,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_name,
        'WEB' AS source_user,
        a.created_at,
        a.is_active,
        a.is_delete
    FROM
        wfm_schema.tx_user_management a
        LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
        LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
        LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
        LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
        LEFT JOIN wfm_schema.tx_user_role tu ON a.ref_user_id = tu.ref_user_id
        LEFT JOIN wfm_schema.tm_user_role t ON tu.role_id = t.tm_user_role_id
    WHERE 
        a.email IS NOT NULL and trim(a.email) <> '' 
    GROUP BY
        a.employee_name, a.email, a.phone_number, b.area_name, c.regional_name, d.nop_name, e.cluster_name, a.created_at, a.is_active, a.is_delete
    UNION ALL
    SELECT
        a.employee_name AS name,
        a.email,
        a.phone_number,
        b.area_name,
        c.regional_name,
        d.nop_name,
        e.cluster_name,
        string_agg(DISTINCT t.name::text, ', ') AS role_name,
        'MOBILE' AS source_user,
        a.created_at,
        a.is_active,
        a.is_delete
    FROM
        wfm_schema.tx_user_mobile_management a
        LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
        LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
        LEFT JOIN wfm_schema.tm_nop d ON a.nop_id = d.nop_id
        LEFT JOIN wfm_schema.tm_cluster e ON a.cluster_id = e.cluster_id
        LEFT JOIN {mapping_user_mobile_role} m ON a.tx_user_mobile_management_id = m.tx_user_mobile_management_id
        LEFT JOIN wfm_schema.tm_user_role t ON m.role_id = t.tm_user_role_id
    WHERE 
        ((@Area = '') OR (a.area_id = @Area)) 
        AND ((@Regional = '') OR (a.regional_id = @Regional)) 
        AND ((@NOP = '') OR (a.nop_id = @NOP))
        AND ((@Cluster = 0) OR (a.cluster_id = @Cluster))
        AND a.email IS NOT NULL and trim(a.email) <> '' 
    GROUP BY
        a.employee_name, a.email, a.phone_number, b.area_name, c.regional_name, d.nop_name, e.cluster_name, a.created_at, a.is_active, a.is_delete
)
SELECT
    MIN(name) AS name,
    email,
    MIN(phone_number),
    MIN(area_name) AS area_name,
    MIN(regional_name) AS regional_name,
    MIN(nop_name) AS nop_name,
    MIN(cluster_name) AS cluster_name,
    string_agg(DISTINCT role_name, ', ') AS role,
    string_agg(DISTINCT source_user, ', ') AS source_user,
    CASE 
        WHEN email LIKE '%@telkomsel.co.id' AND email NOT LIKE '%_x@telkomsel.co.id' THEN 'LDAP TELKOMSEL'
        when email LIKE '%_x@telkomsel.co.id' then 'NON-LDAP TELKOMSEL'
        ELSE 'NON-TELKOMSEL'
    END AS category,
        string_agg(DISTINCT
    CASE 
        WHEN source_user = 'WEB' THEN 'WEB: ' || TO_CHAR(created_at, 'DD-Mon-YYYY')
        WHEN source_user = 'MOBILE' THEN 'MOBILE: ' || TO_CHAR(created_at, 'DD-Mon-YYYY')
    END, ', '
    ) AS created_info,
    case
        when is_active = true AND is_delete = false then true 
        else false
    end as active,
    COUNT(*) OVER() AS FullCount
FROM
    combined_users
GROUP BY
    email, is_active, is_delete
ORDER BY
    name;