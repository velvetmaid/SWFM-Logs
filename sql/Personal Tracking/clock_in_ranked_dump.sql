SELECT
    DISTINCT ON (a.employee_name) a.employee_name AS staffname,
    dense_rank() OVER (
        PARTITION BY a.cluster_id
        ORDER BY
            a.employee_name
    ) AS seq_no,
    a.cluster_id,
    a.tx_user_mobile_management_id,
    CASE
        WHEN ranked_clockin.absentype THEN 'Clock In'
        ELSE 'Clock Out'
    END AS clock_status,
    ranked_clockin.rank_amount_in,
    ranked_clockin.absentime
FROM
    wfm_schema.tx_user_mobile_management a
    JOIN wfm_schema.mapping_user_mobile_role b ON b.tx_user_mobile_management_id = a.tx_user_mobile_management_id
    JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
    JOIN (
        SELECT
            tx_absen.userid,
            tx_absen.absentype,
            tx_absen.absentime,
            rank() OVER (
                PARTITION BY tx_absen.userid
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rank_amount_in
        FROM
            wfm_schema.tx_absen
    ) ranked_clockin ON a.tx_user_mobile_management_id = ranked_clockin.userid
    JOIN (
        SELECT
            tx_absen.userid,
            tx_absen.absentype,
            tx_absen.absentime,
            rank() OVER (
                PARTITION BY tx_absen.userid
                ORDER BY
                    tx_absen.absentime ASC
            ) AS rank_amount_out
        FROM
            wfm_schema.tx_absen
    ) ranked_clockout ON a.tx_user_mobile_management_id = ranked_clockout.userid
    LEFT JOIN wfm_schema.tx_ticket_terr_opr t ON a.tx_user_mobile_management_id :: VARCHAR = t.pic_id
WHERE
    a.is_active = true
    AND a.is_delete = false
    AND (
        c.code = 'MUSERTS'
        OR c.code = 'MUSERMBP'
    ) -- AND ranked_clockin.rank_amount < 2
    and ranked_clockin.absentime >= (CURRENT_DATE - '1 day' :: interval) WITH clock_in_out AS (
        SELECT
            ROW_NUMBER() OVER (
                ORDER BY
                    absentime DESC
            ) AS first_row,
            ROW_NUMBER() OVER (
                ORDER BY
                    absentime ASC
            ) AS last_row,
            rank() OVER (
                PARTITION BY tx_absen.userid
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rank_amount_in
        FROM
            wfm_schema.tx_absen
            INNER JOIN wfm_schema.tx_user_mobile_management ON tx_absen.userid = tx_user_mobile_management.tx_user_mobile_management_id
        WHERE
            absentime >= (CURRENT_DATE - '1 day' :: interval);

ORDER BY
    absentime DESC
)
SELECT
    first_row,
    last_row,
    rank_amount_in
FROM
    clock_in_out
WHERE
    clock_in_out.first_row = 1
    OR clock_in_out.last_row = 1;

-- 
-- 
-- 
WITH first_clock_in AS (
    SELECT
        tx_absen.userid,
        MIN(tx_absen.absentime) AS first_in_time
    FROM
        wfm_schema.tx_absen
    WHERE
        tx_absen.absentype = TRUE
        AND tx_absen.absentime >= (CURRENT_DATE - INTERVAL '1 day')
    GROUP BY
        tx_absen.userid
),
last_clock_out AS (
    SELECT
        tx_absen.userid,
        MAX(tx_absen.absentime) AS last_out_time
    FROM
        wfm_schema.tx_absen
    WHERE
        tx_absen.absentype = FALSE
        AND tx_absen.absentime >= (CURRENT_DATE - INTERVAL '1 day')
    GROUP BY
        tx_absen.userid
),
intervals AS (
    SELECT
        ci.userid,
        ci.first_in_time,
        co.last_out_time,
        ROUND(
            EXTRACT(
                EPOCH
                FROM
                    (co.last_out_time - ci.first_in_time)
            ) / 3600
        ) AS hours_interval
    FROM
        first_clock_in ci
        JOIN last_clock_out co ON ci.userid = co.userid
)
SELECT
    a.employee_name AS staffname,
    a.cluster_id,
    a.tx_user_mobile_management_id,
    i.first_in_time,
    i.last_out_time,
    i.hours_interval
FROM
    wfm_schema.tx_user_mobile_management a
    JOIN intervals i ON a.tx_user_mobile_management_id = i.userid
    JOIN wfm_schema.mapping_user_mobile_role b ON b.tx_user_mobile_management_id = a.tx_user_mobile_management_id
    JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
WHERE
    a.is_active = true
    AND a.is_delete = false
    AND (
        c.code = 'MUSERTS'
        OR c.code = 'MUSERMBP'
    );