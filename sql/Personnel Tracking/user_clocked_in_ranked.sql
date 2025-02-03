-- View to get employee names with their roles and role codes
SELECT
    tumm.employee_name,
    STRING_AGG (
        tur.name,
        ', '
        ORDER BY
            tur.name
    ) AS role_names,
    STRING_AGG (
        tur.code,
        ', '
        ORDER BY
            tur.code
    ) AS role_codes
FROM
    wfm_schema.tx_user_mobile_management tumm
    LEFT JOIN wfm_schema.mapping_user_mobile_role mumr ON tumm.tx_user_mobile_management_id = mumr.tx_user_mobile_management_id
    INNER JOIN wfm_schema.tm_user_role tur ON mumr.role_id = tur.tm_user_role_id
GROUP BY
    tumm.employee_name;

-- View to get employee details with count of absences
SELECT
    tumm.area_id area_id,
    ta.area_name area_name,
    tumm.cluster_id cluster_id,
    tc.cluster_name cluster_name,
    tumm.employee_name employee_name,
    tumm.nop_id nop_id,
    tn.nop_name nop_name,
    tumm.phone_number phone_number,
    tumm.regional_id regional_id,
    tr.regional_name regional_name,
    vumalr.userid userid,
    tumm.username username,
    count(vumalr.absentime) as count_absentime
FROM
    (
        (
            (
                (
                    (
                        wfm_schema.tx_absen vumalr
                        INNER JOIN wfm_schema.tx_user_mobile_management tumm ON (vumalr.userid = tumm.tx_user_mobile_management_id)
                    )
                    LEFT JOIN wfm_schema.tm_area ta ON (tumm.area_id = ta.area_id)
                )
                LEFT JOIN wfm_schema.tm_regional tr ON (tumm.regional_id = tr.regional_id)
            )
            LEFT JOIN wfm_schema.tm_nop tn ON (tumm.nop_id = tn.nop_id)
        )
        LEFT JOIN wfm_schema.tm_cluster tc ON (tumm.cluster_id = tc.cluster_id)
    )
WHERE
    vumalr.absentype = true
GROUP BY
    tumm.cluster_id,
    ta.area_name,
    tumm.phone_number,
    tumm.username,
    tc.cluster_name,
    tn.nop_name,
    tumm.employee_name,
    tumm.area_id,
    tr.regional_name,
    tumm.regional_id,
    vumalr.userid,
    tumm.nop_id;

-- View to get ranked absences
WITH
    ranked_absences AS (
        SELECT
            tx_absen.id,
            tx_absen.absendate,
            tx_absen.absentype,
            tx_absen.userid,
            tx_absen.absentime,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime
            ) AS rankasc,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rankdesc
        FROM
            wfm_schema.tx_absen
    )
SELECT
    *
FROM
    ranked_absences ra
WHERE
    ra.rankasc = 1
    AND ra.absentype = true
    OR ra.rankdesc = 1
    AND ra.absentype = false;

-- View to get employee details with ranked absences for January 2025
WITH
    ranked_absences AS (
        SELECT
            tx_absen.id,
            tx_absen.absendate,
            tx_absen.absentype,
            tx_absen.userid,
            tx_absen.absentime,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime
            ) AS rankasc,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rankdesc
        FROM
            wfm_schema.tx_absen
    )
SELECT
    ra.userid userid,
    tumm.username username,
    tumm.employee_name,
    tumm.phone_number,
    count(ra.absentime) as count_absentime,
    tumm.area_id,
    ta.area_name,
    tumm.cluster_id,
    tc.cluster_name,
    tumm.nop_id nop_id,
    tn.nop_name nop_name,
    tumm.regional_id,
    tr.regional_name
FROM
    ranked_absences ra
    INNER JOIN wfm_schema.tx_user_mobile_management tumm ON (ra.userid = tumm.tx_user_mobile_management_id)
    LEFT JOIN wfm_schema.tm_area ta ON (tumm.area_id = ta.area_id)
    LEFT JOIN wfm_schema.tm_regional tr ON (tumm.regional_id = tr.regional_id)
    LEFT JOIN wfm_schema.tm_nop tn ON (tumm.nop_id = tn.nop_id)
    LEFT JOIN wfm_schema.tm_cluster tc ON (tumm.cluster_id = tc.cluster_id)
WHERE
    ra.rankasc = 1
    AND ra.absentype = true
    AND EXTRACT(
        YEAR
        FROM
            ra.absentime
    ) = 2025
    AND EXTRACT(
        MONTH
        FROM
            ra.absentime
    ) = 1
    AND tumm.area_id = 'Area1'
    AND tumm.regional_id = 'R01'
    AND tumm.nop_id = 'NOP1'
    AND tumm.cluster_id = 1
GROUP BY
    ra.userid,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    tumm.area_id,
    ta.area_name,
    tumm.regional_id,
    tr.regional_name,
    tumm.nop_id,
    tn.nop_name,
    tumm.cluster_id,
    tc.cluster_name;

-- View to get employee details with roles and ranked absences for January 2025
WITH
    ranked_absences AS (
        SELECT
            tx_absen.id,
            tx_absen.absendate,
            tx_absen.absentype,
            tx_absen.userid,
            tx_absen.absentime,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime
            ) AS rankasc,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rankdesc
        FROM
            wfm_schema.tx_absen
    )
SELECT
    ra.userid userid,
    tumm.username username,
    tumm.employee_name,
    STRING_AGG (
        tur.name,
        ', '
        ORDER BY
            tur.name
    ) AS roles_name,
    STRING_AGG (
        tur.code,
        ', '
        ORDER BY
            tur.code
    ) AS roles_code,
    tumm.phone_number,
    count(ra.absentime) as count_absentime,
    tumm.area_id,
    ta.area_name,
    tumm.regional_id,
    tr.regional_name,
    tumm.nop_id nop_id,
    tn.nop_name nop_name,
    tumm.cluster_id,
    tc.cluster_name
FROM
    ranked_absences ra
    INNER JOIN wfm_schema.tx_user_mobile_management tumm ON ra.userid = tumm.tx_user_mobile_management_id
    LEFT JOIN wfm_schema.mapping_user_mobile_role mumr ON tumm.tx_user_mobile_management_id = mumr.tx_user_mobile_management_id
    INNER JOIN wfm_schema.tm_user_role tur ON mumr.role_id = tur.tm_user_role_id
    LEFT JOIN wfm_schema.tm_area ta ON tumm.area_id = ta.area_id
    LEFT JOIN wfm_schema.tm_regional tr ON tumm.regional_id = tr.regional_id
    LEFT JOIN wfm_schema.tm_nop tn ON tumm.nop_id = tn.nop_id
    LEFT JOIN wfm_schema.tm_cluster tc ON tumm.cluster_id = tc.cluster_id
WHERE
    ra.rankasc = 1
    AND ra.absentype = true
    AND EXTRACT(
        YEAR
        FROM
            ra.absentime
    ) = 2025
    AND EXTRACT(
        MONTH
        FROM
            ra.absentime
    ) = 1
    AND tumm.area_id = 'Area1'
    AND tumm.regional_id = 'R01'
    AND tumm.nop_id = 'NOP1'
    AND tumm.cluster_id = 1
    AND tur.code = 'MUSERTS'
GROUP BY
    ra.userid,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    tumm.area_id,
    ta.area_name,
    tumm.regional_id,
    tr.regional_name,
    tumm.nop_id,
    tn.nop_name,
    tumm.cluster_id,
    tc.cluster_name;

-- View to get employee details with distinct roles and ranked absences for January 2025
WITH
    ranked_absences AS (
        SELECT
            tx_absen.id,
            tx_absen.absendate,
            tx_absen.absentype,
            tx_absen.userid,
            tx_absen.absentime,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime
            ) AS rankasc,
            row_number() OVER (
                PARTITION BY
                    tx_absen.userid,
                    tx_absen.absendate
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rankdesc
        FROM
            wfm_schema.tx_absen
    ),
    distinct_roles AS (
        SELECT DISTINCT
            mumr.tx_user_mobile_management_id,
            tur.code,
            tur.name
        FROM
            wfm_schema.mapping_user_mobile_role mumr
            INNER JOIN wfm_schema.tm_user_role tur ON mumr.role_id = tur.tm_user_role_id
        WHERE
            tur.code = 'MUSERTS'
    )
SELECT
    ra.userid,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    COUNT(DISTINCT ra.absentime) AS count_absentime,
    tumm.area_id,
    ta.area_name,
    tumm.regional_id,
    tr.regional_name,
    tumm.nop_id,
    tn.nop_name,
    tumm.cluster_id,
    tc.cluster_name,
    STRING_AGG (
        dr.name,
        ', '
        ORDER BY
            dr.name
    ) AS roles_name,
    STRING_AGG (
        dr.code,
        ', '
        ORDER BY
            dr.code
    ) AS roles_code
FROM
    ranked_absences ra
    INNER JOIN wfm_schema.tx_user_mobile_management tumm ON ra.userid = tumm.tx_user_mobile_management_id
    INNER JOIN distinct_roles dr ON tumm.tx_user_mobile_management_id = dr.tx_user_mobile_management_id
    LEFT JOIN wfm_schema.tm_area ta ON tumm.area_id = ta.area_id
    LEFT JOIN wfm_schema.tm_regional tr ON tumm.regional_id = tr.regional_id
    LEFT JOIN wfm_schema.tm_nop tn ON tumm.nop_id = tn.nop_id
    LEFT JOIN wfm_schema.tm_cluster tc ON tumm.cluster_id = tc.cluster_id
WHERE
    ra.rankasc = 1
    AND ra.absentype = true
    AND EXTRACT(
        YEAR
        FROM
            ra.absentime
    ) = 2025
    AND EXTRACT(
        MONTH
        FROM
            ra.absentime
    ) = 1
    AND tumm.area_id = 'Area1'
    AND tumm.regional_id = 'R01'
    AND tumm.nop_id = 'NOP1'
    AND tumm.cluster_id = 1
GROUP BY
    ra.userid,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    tumm.area_id,
    ta.area_name,
    tumm.regional_id,
    tr.regional_name,
    tumm.nop_id,
    tn.nop_name,
    tumm.cluster_id,
    tc.cluster_name;