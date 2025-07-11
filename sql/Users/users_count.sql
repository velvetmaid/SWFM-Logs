WITH
    user_web AS (
        SELECT
            COUNT(*) AS user_web
        FROM
            wfm_schema.tx_user_management
    ),
    user_web_active AS (
        SELECT
            COUNT(*) AS user_web_active
        FROM
            wfm_schema.tx_user_management
        WHERE
            is_active
            and not is_delete
    ),
    user_web_inactive AS (
        SELECT
            COUNT(*) AS user_web_inactive
        FROM
            wfm_schema.tx_user_management
        WHERE
            NOT (
                is_active
                AND not is_delete
            )
    ),
    user_mobile AS (
        SELECT
            COUNT(*) AS user_mobile
        FROM
            wfm_schema.tx_user_mobile_management
    ),
    user_mobile_active AS (
        SELECT
            COUNT(*) AS user_mobile_active
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            is_active
            and not is_delete
    ),
    user_mobile_inactive AS (
        SELECT
            COUNT(*) AS user_mobile_inactive
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            NOT (
                is_active
                AND not is_delete
            )
    ),
    user_tsel_ldap_active AS (
        SELECT
            (
                SELECT
                    COUNT(*)
                FROM
                    wfm_schema.tx_user_management
                WHERE
                    email LIKE '%@telkomsel%'
                    AND is_active = true
                    AND is_delete = false
                    AND email NOT LIKE '%_x@telkomsel%'
            ) + (
                SELECT
                    COUNT(*)
                FROM
                    wfm_schema.tx_user_mobile_management
                WHERE
                    email LIKE '%@telkomsel%'
                    AND is_active = true
                    AND is_delete = false
                    AND email NOT LIKE '%_x@telkomsel%'
            ) AS user_tsel_ldap_active
    ),
    user_tsel_ldap_web_active AS (
        SELECT
            COUNT(*) AS user_tsel_ldap_web_active
        FROM
            wfm_schema.tx_user_management
        WHERE
            email LIKE '%@telkomsel%'
            AND is_active = true
            AND is_delete = false
            AND email NOT LIKE '%_x@telkomsel%'
    ),
    user_tsel_ldap_mobile_active AS (
        SELECT
            COUNT(*) AS user_tsel_ldap_mobile_active
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            email LIKE '%@telkomsel%'
            AND is_active = true
            AND is_delete = false
            AND email NOT LIKE '%_x@telkomsel%'
    ),
    user_tsel_non_ldap_active AS (
        SELECT
            (
                SELECT
                    COUNT(*)
                FROM
                    wfm_schema.tx_user_management
                WHERE
                    email LIKE '%_x@telkomsel%'
                    AND is_active = true
                    AND is_delete = false
            ) + (
                SELECT
                    COUNT(*)
                FROM
                    wfm_schema.tx_user_mobile_management
                WHERE
                    email LIKE '%_x@telkomsel%'
                    AND is_active = true
                    AND is_delete = false
            ) AS user_tsel_non_ldap_active
    ),
    user_tsel_non_ldap_web_active AS (
        SELECT
            COUNT(*) AS user_tsel_non_ldap_web_active
        FROM
            wfm_schema.tx_user_management
        WHERE
            email LIKE '%_x@telkomsel%'
            AND is_active = true
            AND is_delete = false
    ),
    user_tsel_non_ldap_mobile_active AS (
        SELECT
            COUNT(*) AS user_tsel_non_ldap_mobile_active
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            email LIKE '%_x@telkomsel%'
            AND is_active = true
            AND is_delete = false
    ),
    user_non_tsel_active AS (
        SELECT
            (
                SELECT
                    COUNT(*)
                FROM
                    wfm_schema.tx_user_management
                WHERE
                    (
                        email NOT LIKE '%@telkomsel%'
                        AND email NOT LIKE '%_x@telkomsel%'
                    )
                    AND is_active = true
                    AND is_delete = false
            ) + (
                SELECT
                    COUNT(*)
                FROM
                    wfm_schema.tx_user_mobile_management
                WHERE
                    (
                        email NOT LIKE '%@telkomsel%'
                        AND email NOT LIKE '%_x@telkomsel%'
                    )
                    AND is_active = true
                    AND is_delete = false
            ) AS user_non_tsel_active
    ),
    user_non_tsel_web_active AS (
        SELECT
            COUNT(*) AS user_non_tsel_web_active
        FROM
            wfm_schema.tx_user_management
        WHERE
            (
                email NOT LIKE '%@telkomsel%'
                AND email NOT LIKE '%_x@telkomsel%'
            )
            AND is_active = true
            AND is_delete = false
    ),
    user_non_tsel_mobile_active AS (
        SELECT
            COUNT(*) AS user_non_tsel_mobile_active
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            (
                email NOT LIKE '%@telkomsel%'
                AND email NOT LIKE '%_x@telkomsel%'
            )
            AND is_active = true
            AND is_delete = false
    )
SELECT
    *
FROM
    user_web,
    user_web_active,
    user_web_inactive,
    user_mobile,
    user_mobile_active,
    user_mobile_inactive,
    user_tsel_ldap_active,
    user_tsel_ldap_web_active,
    user_tsel_ldap_mobile_active,
    user_tsel_non_ldap_active,
    user_tsel_non_ldap_web_active,
    user_tsel_non_ldap_mobile_active,
    user_non_tsel_active,
    user_non_tsel_web_active,
    user_non_tsel_mobile_active;

-- This query counts the number of users in various categories:
WITH
    user_web_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_management
        WHERE
            is_active
            AND NOT is_delete
    ),
    user_web_inactive AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_management
        WHERE
            NOT (
                is_active
                AND NOT is_delete
            )
    ),
    user_mobile_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            is_active
            AND NOT is_delete
    ),
    user_mobile_inactive AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            NOT (
                is_active
                AND NOT is_delete
            )
    ),
    tsel_ldap_web_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_management
        WHERE
            email LIKE '%@telkomsel%'
            AND NOT email LIKE '%_x@telkomsel%'
            AND is_active
            AND NOT is_delete
    ),
    tsel_ldap_mobile_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            email LIKE '%@telkomsel%'
            AND NOT email LIKE '%_x@telkomsel%'
            AND is_active
            AND NOT is_delete
    ),
    tsel_non_ldap_web_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_management
        WHERE
            email LIKE '%_x@telkomsel%'
            AND is_active
            AND NOT is_delete
    ),
    tsel_non_ldap_mobile_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            email LIKE '%_x@telkomsel%'
            AND is_active
            AND NOT is_delete
    ),
    non_tsel_web_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_management
        WHERE
            email NOT LIKE '%@telkomsel%'
            AND email NOT LIKE '%_x@telkomsel%'
            AND is_active
            AND NOT is_delete
    ),
    non_tsel_mobile_active AS (
        SELECT
            COUNT(*) AS val
        FROM
            wfm_schema.tx_user_mobile_management
        WHERE
            email NOT LIKE '%@telkomsel%'
            AND email NOT LIKE '%_x@telkomsel%'
            AND is_active
            AND NOT is_delete
    )
SELECT
    'active' AS users,
    uwa.val AS user_web,
    uma.val AS user_mobile,
    (uwa.val + uma.val) AS total
FROM
    user_web_active uwa,
    user_mobile_active uma
UNION ALL
SELECT
    'inactive',
    uwi.val,
    umi.val,
    (uwi.val + umi.val)
FROM
    user_web_inactive uwi,
    user_mobile_inactive umi
UNION ALL

SELECT
    'tsel_ldap_active',
    tlwa.val,
    tlma.val,
    (tlwa.val + tlma.val)
FROM
    tsel_ldap_web_active tlwa,
    tsel_ldap_mobile_active tlma
UNION ALL
SELECT
    'tsel_non_ldap_active',
    tnlwa.val,
    tnlma.val,
    (tnlwa.val + tnlma.val)
FROM
    tsel_non_ldap_web_active tnlwa,
    tsel_non_ldap_mobile_active tnlma
UNION ALL
SELECT
    'non_tsel_active',
    ntwa.val,
    ntma.val,
    (ntwa.val + ntma.val)
FROM
    non_tsel_web_active ntwa,
    non_tsel_mobile_active ntma
order by
    users;


-- This query counts the number of users in various categories, including active and inactive users, as well as those from Telkomsel and non-Telkomsel domains, both for web and mobile platforms.
-- It also distinguishes between LDAP and non-LDAP users based on their email addresses.
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
SELECT
    'Active User' AS user_kategory,
    (SELECT COUNT(*) FROM web_active) AS user_web,
    (SELECT COUNT(*) FROM mobile_active) AS user_mobile,
    (SELECT COUNT(*) FROM (SELECT email FROM web_active UNION SELECT email FROM mobile_active) AS total_unique) AS total
UNION ALL
SELECT
    'Inactive User',
    (SELECT COUNT(*) FROM web_inactive),
    (SELECT COUNT(*) FROM mobile_inactive),
    (SELECT COUNT(*) FROM (SELECT email FROM web_inactive UNION SELECT email FROM mobile_inactive) AS total_unique)
UNION ALL
SELECT
    'LDAP Telkomsel Active',
    (SELECT COUNT(*) FROM ldap_tsel_web),
    (SELECT COUNT(*) FROM ldap_tsel_mobile),
    (SELECT COUNT(*) FROM (SELECT email FROM ldap_tsel_web UNION SELECT email FROM ldap_tsel_mobile) AS total_unique)
UNION ALL
SELECT
    'Non-LDAP Telkomsel Active',
    (SELECT COUNT(*) FROM nonldap_tsel_web),
    (SELECT COUNT(*) FROM nonldap_tsel_mobile),
    (SELECT COUNT(*) FROM (SELECT email FROM nonldap_tsel_web UNION SELECT email FROM nonldap_tsel_mobile) AS total_unique)
UNION ALL
SELECT
    'Non-Telkomsel Active',
    (SELECT COUNT(*) FROM non_tsel_web),
    (SELECT COUNT(*) FROM non_tsel_mobile),
    (SELECT COUNT(*) FROM (SELECT email FROM non_tsel_web UNION SELECT email FROM non_tsel_mobile) AS total_unique);
