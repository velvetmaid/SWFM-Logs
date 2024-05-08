WITH clock_in_out_intervals AS (
    SELECT
        tx_absen.userid,
        MIN(
            CASE
                WHEN tx_absen.absentype = TRUE THEN tx_absen.absentime
            END
        ) AS first_in_time,
        MAX(
            CASE
                WHEN tx_absen.absentype = FALSE THEN tx_absen.absentime
            END
        ) AS last_out_time
    FROM
        wfm_schema.tx_absen
    WHERE
        tx_absen.absentime >= (CURRENT_DATE - INTERVAL '1 day')
    GROUP BY
        tx_absen.userid
),
intervals_calculated AS (
    SELECT
        userid,
        first_in_time,
        last_out_time,
        EXTRACT(
            EPOCH
            FROM
                (last_out_time - first_in_time)
        ) / 3600 AS hours_worked
    FROM
        clock_in_out_intervals
)
SELECT
    a.employee_name AS staffname,
    a.cluster_id,
    a.tx_user_mobile_management_id,
    CASE
        WHEN ic.first_in_time IS NOT NULL
        AND ic.last_out_time IS NOT NULL THEN 'Interval Captured'
        ELSE 'Incomplete Interval'
    END AS clock_status,
    ic.first_in_time,
    ic.last_out_time,
    ROUND(ic.hours_worked, 2) AS hours_worked
FROM
    wfm_schema.tx_user_mobile_management a
    JOIN intervals_calculated ic ON a.tx_user_mobile_management_id = ic.userid
    JOIN wfm_schema.mapping_user_mobile_role b ON b.tx_user_mobile_management_id = a.tx_user_mobile_management_id
    JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
WHERE
    a.is_active = true
    AND a.is_delete = false
    AND (
        c.code = 'MUSERTS'
        OR c.code = 'MUSERMBP'
    )
ORDER BY
    a.employee_name,
    ic.first_in_time;