-- Select all users attendance summary
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
            {tx_absen}
    ),
    distinct_roles AS (
        SELECT DISTINCT
            mumr.tx_user_mobile_management_id,
            tur.code,
            tur.name
        FROM
            {mapping_user_mobile_role} mumr
        INNER JOIN {tm_user_role} tur ON mumr.role_id = tur.tm_user_role_id
        WHERE
            (tur.code = @Role OR @Role = '')
    )
SELECT
    ra.userid,
    tumm.username,
    tumm.employee_name,
    STRING_AGG(DISTINCT dr.name, ', ' ORDER BY dr.name) AS roles_name,
    STRING_AGG(DISTINCT dr.code, ', ' ORDER BY dr.code) AS roles_code,
    tumm.phone_number,
    COUNT(DISTINCT ra.absentime) AS count_absentime,
    to_char(@AbsentDate, 'Month, YYYY') AS period,
    tumm.area_id,
    ta.area_name,
    tumm.regional_id,
    tr.regional_name,
    tumm.nop_id,
    tn.nop_name,
    tumm.cluster_id,
    tc.cluster_name
FROM
    ranked_absences ra
    INNER JOIN {tx_user_mobile_management} tumm ON ra.userid = tumm.tx_user_mobile_management_id
    INNER JOIN distinct_roles dr ON tumm.tx_user_mobile_management_id = dr.tx_user_mobile_management_id
    LEFT JOIN {tm_area} ta ON tumm.area_id = ta.area_id
    LEFT JOIN {tm_regional} tr ON tumm.regional_id = tr.regional_id
    LEFT JOIN {tm_nop} tn ON tumm.nop_id = tn.nop_id
    LEFT JOIN {tm_cluster} tc ON tumm.cluster_id = tc.cluster_id
WHERE
    ra.rankasc = 1
    AND ra.absentype = true
    AND EXTRACT(
        YEAR
        FROM
            ra.absentime
    ) = EXTRACT(
        YEAR
        FROM
            @AbsentDate
    )
    AND EXTRACT(
        MONTH
        FROM
            ra.absentime
    ) = EXTRACT(
        MONTH
        FROM
            @AbsentDate
    )
    AND (tumm.area_id = @Area_Id OR @Area_Id = '')
    AND (tumm.regional_id = @Regional_Id OR @Regional_Id = '')
    AND (tumm.nop_id = @NOP_Id OR @NOP_Id = '')
    AND (tumm.cluster_id = @Cluster_Id OR @Cluster_Id = 0)
    AND UPPER(tumm.employee_name) LIKE '%' || UPPER(@Search) || '%'
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
    tc.cluster_name
OFFSET @StartIndex ROWS FETCH NEXT @MaxRecords ROWS ONLY;


-- Count total rows
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
            {tx_absen}
    ),
    distinct_roles AS (
        SELECT DISTINCT
            mumr.tx_user_mobile_management_id,
            tur.code,
            tur.name
        FROM
            {mapping_user_mobile_role} mumr
        INNER JOIN {tm_user_role} tur ON mumr.role_id = tur.tm_user_role_id
        WHERE
            (tur.code = @Role OR @Role = '')
    )
SELECT
    COUNT(*) AS total_rows
FROM
    ranked_absences ra
    INNER JOIN {tx_user_mobile_management} tumm ON ra.userid = tumm.tx_user_mobile_management_id
    INNER JOIN distinct_roles dr ON tumm.tx_user_mobile_management_id = dr.tx_user_mobile_management_id
    LEFT JOIN {tm_area} ta ON tumm.area_id = ta.area_id
    LEFT JOIN {tm_regional} tr ON tumm.regional_id = tr.regional_id
    LEFT JOIN {tm_nop} tn ON tumm.nop_id = tn.nop_id
    LEFT JOIN {tm_cluster} tc ON tumm.cluster_id = tc.cluster_id
WHERE
    ra.rankasc = 1
    AND ra.absentype = true
    AND EXTRACT(
        YEAR
        FROM
            ra.absentime
    ) = EXTRACT(
        YEAR
        FROM
            @AbsentDate
    )
    AND EXTRACT(
        MONTH
        FROM
            ra.absentime
    ) = EXTRACT(
        MONTH
        FROM
            @AbsentDate
    )
    AND (tumm.area_id = @Area_Id OR @Area_Id = '')
    AND (tumm.regional_id = @Regional_Id OR @Regional_Id = '')
    AND (tumm.nop_id = @NOP_Id OR @NOP_Id = '')
    AND (tumm.cluster_id = @Cluster_Id OR @Cluster_Id = 0)
    AND UPPER(tumm.employee_name) LIKE '%' || UPPER(@Search) || '%';
