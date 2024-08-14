SELECT
    concat(txa.userid, to_char(txa.absendate, 'ddmmyyyy')) as tx_attendance_id,
    txa.absendate as attendance_date,
    txa.userid as user_id,
    MIN(
        CASE
            WHEN txa.absentype = true THEN txa.absentime
        END
    ) AS clock_in,
    MAX(
        CASE
            WHEN txa.absentype = false THEN txa.absentime
        END
    ) AS clock_out,
    MAX(
        CASE
            WHEN txa.absentype = false THEN txa.absentime
        END
    ) - MIN(
        CASE
            WHEN txa.absentype = true THEN txa.absentime
        END
    ) AS working_hour,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    ta.area_id,
    ta.area_name,
    tr.regional_id,
    tr.regional_name,
    tn.nop_id,
    tn.nop_name,
    tc.cluster_id,
    tc.cluster_name
FROM
    wfm_schema.tx_absen txa
    LEFT JOIN wfm_schema.tx_user_mobile_management tumm ON txa.userid = tumm.tx_user_mobile_management_id
    OR txa.userid = tumm.ref_user_id_before
    LEFT JOIN wfm_schema.tm_area ta ON tumm.area_id = ta.area_id
    LEFT JOIN wfm_schema.tm_regional tr ON tumm.regional_id = tr.regional_id
    LEFT JOIN wfm_schema.tm_nop tn ON tumm.nop_id = tn.nop_id
    LEFT JOIN wfm_schema.tm_cluster tc ON tumm.cluster_id = tc.cluster_id
WHERE
    tumm.is_active = true
    AND EXTRACT(
        YEAR
        FROM
            txa.absendate
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            txa.absendate
    ) BETWEEN 7
    AND 7
GROUP BY
    txa.absendate,
    txa.userid,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    ta.area_id,
    tr.regional_id,
    tn.nop_id,
    tc.cluster_id
ORDER BY
    txa.absendate ASC;