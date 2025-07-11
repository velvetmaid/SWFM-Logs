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
        a.is_active,
        a.is_delete
    FROM
        {tx_user_management} a
        LEFT JOIN {tm_area} b ON a.area_id = b.area_id
        LEFT JOIN {tm_regional} c ON a.regional_id = c.regional_id
        LEFT JOIN {tm_nop} d ON a.nop_id = d.nop_id
        LEFT JOIN {tm_cluster} e ON a.cluster_id = e.cluster_id
        LEFT JOIN {tx_user_role} tu ON a.ref_user_id = tu.ref_user_id
        LEFT JOIN {tm_user_role} t ON tu.role_id = t.tm_user_role_id
    WHERE 
        ((@Area = '') OR (a.area_id = @Area)) 
        AND ((@Regional = '') OR (a.regional_id = @Regional)) 
        AND ((@NOP = '') OR (a.nop_id = @NOP))
        AND ((@Cluster = 0) OR (a.cluster_id = @Cluster))
        AND a.email IS NOT NULL and trim(a.email) <> '' 
    GROUP BY
        a.employee_name, a.email, a.phone_number, b.area_name, c.regional_name, d.nop_name, e.cluster_name, a.is_active, a.is_delete
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
        a.is_active,
        a.is_delete
    FROM
        {tx_user_mobile_management} a
        LEFT JOIN {tm_area} b ON a.area_id = b.area_id
        LEFT JOIN {tm_regional} c ON a.regional_id = c.regional_id
        LEFT JOIN {tm_nop} d ON a.nop_id = d.nop_id
        LEFT JOIN {tm_cluster} e ON a.cluster_id = e.cluster_id
        LEFT JOIN {mapping_user_mobile_role} m ON a.tx_user_mobile_management_id = m.tx_user_mobile_management_id
        LEFT JOIN {tm_user_role} t ON m.role_id = t.tm_user_role_id
    WHERE 
        ((@Area = '') OR (a.area_id = @Area)) 
        AND ((@Regional = '') OR (a.regional_id = @Regional)) 
        AND ((@NOP = '') OR (a.nop_id = @NOP))
        AND ((@Cluster = 0) OR (a.cluster_id = @Cluster))
        AND a.email IS NOT NULL and trim(a.email) <> '' 
    GROUP BY
        a.employee_name, a.email, a.phone_number, b.area_name, c.regional_name, d.nop_name, e.cluster_name, a.is_active, a.is_delete
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
        WHEN email LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%' THEN 'LDAP TELKOMSEL'
        when email LIKE '%_x@telkomsel%' then 'NON-LDAP TELKOMSEL'
        ELSE 'NON-TELKOMSEL'
    END AS category,
    case
        when is_active = true AND is_delete = false then true 
        else false
    end as active,
    COUNT(*) OVER() AS FullCount
FROM
    combined_users
WHERE 
    (
        (@Status = 1 AND is_active AND NOT is_delete)
        OR (@Status = 2 AND NOT (is_active AND NOT is_delete))
        OR (@Status NOT IN (1, 2))
    ) 
    AND
    (
        (@Category = 1 AND email LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%')
        OR (@Category = 2 AND email LIKE '%_x@telkomsel%')
        OR (@Category = 3 AND email NOT LIKE '%@telkomsel%' AND email NOT LIKE '%_x@telkomsel%')
        OR (@Category NOT IN (1, 2, 3))
    )
GROUP BY
    email, is_active, is_delete
ORDER BY
    name
OFFSET @StartIndex ROWS
FETCH NEXT @MaxRecords ROWS ONLY;