select
    count(*) as total,
    m.role_id,
    t.name
from
    wfm_schema.tx_user_mobile_management a
    INNER JOIN wfm_schema.mapping_user_mobile_role m ON a.tx_user_mobile_management_id = m.tx_user_mobile_management_id
    INNER JOIN wfm_schema.tm_user_role t ON m.role_id = t.tm_user_role_id
group by
    t.tm_user_role_id,
    t.name,
    m.role_id;

    
DELETE FROM
    wfm_schema.mapping_user_mobile_role
WHERE
    role_id NOT IN (
        SELECT
            tm_user_role_id
        FROM
            wfm_schema.tm_user_role
        WHERE
            name IN (
                'Mobile User MBP',
                'Mobile User PM',
                'Mobile User TS',
                'NOP',
                'ENOM NVEEH'
            )
    );

SELECT
    *
FROM
    wfm_schema.mapping_user_mobile_role m
    JOIN wfm_schema.tm_user_role t ON m.role_id = t.tm_user_role_id
WHERE
    t.name NOT IN (
        'Mobile User MBP',
        'Mobile User PM',
        'Mobile User TS',
        'NOP',
        'ENOM NVEEH',
        'Mobile User Non ENOM'
    );

m.role_id t.name 17 Mobile User MBP 59 Mobile User PM 13 Mobile User TS 18 NOP 53 ENOM NVEEH