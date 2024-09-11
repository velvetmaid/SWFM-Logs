-- wfm_schema.vw_message_spv_to source
CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to_cluster AS WITH ranked_spv_to AS (
    SELECT
        DISTINCT a.phone_number,
        a.cluster_id,
        d.cluster_name
    FROM
        wfm_schema.tx_user_management a
        JOIN wfm_schema.tx_user_role b ON b.ref_user_id = a.ref_user_id
        JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
        JOIN wfm_schema.tm_cluster d ON d.cluster_id = a.cluster_id
    WHERE
        a.is_active = true
        AND a.is_delete = false
        AND c.code = 'SVTO'
        AND a.cluster_id <> 0
),
clock_in_out_intervals AS (
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
        tx_absen.absentime >= (CURRENT_DATE - INTERVAL '1 day') -- tx_absen.absentime >= (CURRENT_DATE - '1 day' :: interval)
        -- AND tx_absen.absentime < CURRENT_DATE
    GROUP BY
        tx_absen.userid
),
intervals_calculated AS (
    SELECT
        userid,
        first_in_time,
        last_out_time,
        ROUND(
            EXTRACT(
                EPOCH
                FROM
                    (last_out_time - first_in_time)
            ) / 3600
        ) AS hours_worked
    FROM
        clock_in_out_intervals
),
ranked_staff_to AS (
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
            WHEN ic.first_in_time IS NOT NULL
            AND ic.last_out_time IS NOT NULL THEN 'Interval Captured'
            ELSE 'Incomplete Interval'
        END AS clock_status,
        ic.first_in_time,
        ic.last_out_time,
        ic.hours_worked
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
        ic.first_in_time
),
ticket_info AS (
    SELECT
        tx_ticket_terr_opr.pic_id,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'IN PROGRESS' THEN 1
                ELSE NULL
            END
        ) AS take_over_ticket,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'ASSIGNED'
                OR tx_ticket_terr_opr.status = 'CANCELED'
                OR tx_ticket_terr_opr.status = 'ESCALATED TO CTS'
                OR tx_ticket_terr_opr.status = 'ESCALATED TO INSERA' -- OR tx_ticket_terr_opr.status = 'IN PROGRESS'
                OR tx_ticket_terr_opr.status = 'NEW'
                OR tx_ticket_terr_opr.status = 'RESOLVED'
                OR tx_ticket_terr_opr.status = 'SUBMITTED' THEN 1
                ELSE NULL
            END
        ) AS open_ticket,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'CLOSED' THEN 1
                ELSE NULL
            END
        ) AS close_ticket
    FROM
        wfm_schema.tx_ticket_terr_opr
    WHERE
        -- tx_ticket_terr_opr.created_at >= (CURRENT_DATE - '1 day' :: interval)
        -- AND tx_ticket_terr_opr.created_at < CURRENT_DATE
        tx_ticket_terr_opr.created_at >=(CURRENT_DATE - INTERVAL '1 day')
    GROUP BY
        tx_ticket_terr_opr.pic_id
),
ticket_total_count AS (
    SELECT
        b.cluster_id,
        count(
            CASE
                WHEN a.status = 'ASSIGNED'
                OR a.status = 'CANCELED'
                OR a.status = 'CLOSED'
                OR a.status = 'ESCALATED TO CTS'
                OR a.status = 'ESCALATED TO INSERA'
                OR a.status = 'IN PROGRESS'
                OR a.status = 'NEW'
                OR a.status = 'RESOLVED'
                OR a.status = 'SUBMITTED' THEN 1
                ELSE NULL
            END
        ) AS total_all_ticket,
        count(
            CASE
                WHEN a.status = 'IN PROGRESS' THEN 1
                ELSE NULL
            END
        ) AS total_take_over_ticket,
        count(
            CASE
                WHEN a.status = 'ASSIGNED'
                OR a.status = 'CANCELED'
                OR a.status = 'ESCALATED TO CTS'
                OR a.status = 'ESCALATED TO INSERA' -- OR a.status = 'IN PROGRESS'
                OR a.status = 'NEW'
                OR a.status = 'RESOLVED'
                OR a.status = 'SUBMITTED' THEN 1
                ELSE NULL
            END
        ) AS total_open_ticket,
        count(
            CASE
                WHEN a.status = 'CLOSED' THEN 1
                ELSE NULL
            END
        ) AS total_close_ticket
    FROM
        wfm_schema.tx_ticket_terr_opr a
        JOIN wfm_schema.tx_site b ON a.site_id = b.site_id
    WHERE
        a.created_at >=(CURRENT_DATE - INTERVAL '1 day')
    GROUP BY
        b.cluster_id
)
SELECT
    ranked_spv_to.phone_number,
    (
        (
            (
                (
                    (
                        (
                            (
                                (
                                    (
                                        (
                                            (
                                                (
                                                    (
                                                        'TS/MBP Performance Report
----------------------------------------
Full Day ' || to_char(
                                                            CURRENT_DATE - '1 day' :: interval,
                                                            'TMDay, DD TMMonth YYYY'
                                                        )
                                                    ) || '
Dear SPV TO, berikut adalah performance TS/MBP '
                                                ) || ranked_spv_to.cluster_name
                                            ) || ' :'
                                        ) || '
Total Ticket : '
                                    ) || ticket_total_count.total_all_ticket
                                ) || '
Total Take Over : '
                            ) || ticket_total_count.total_take_over_ticket
                        ) || '
Total Open : '
                    ) || ticket_total_count.total_open_ticket
                ) || '
Total Close : '
            ) || ticket_total_count.total_close_ticket
        ) || string_agg(
            format(
                '
%s. %s / %s / %s / %s / %s',
                ranked_staff_to.seq_no,
                ranked_staff_to.staffname,
                ranked_staff_to.hours_worked,
                COALESCE(ticket_info.take_over_ticket, '0' :: bigint),
                COALESCE(ticket_info.open_ticket, '0' :: bigint),
                COALESCE(ticket_info.close_ticket, '0' :: bigint)
            ),
            ''
            ORDER BY
                ranked_staff_to.seq_no
        )
    ) || '

----------------------------------------
Keterangan
1. [nama], [durasi jam clock in], [jumlah tiket takeover h-1], [jumlah tiket open h-1], [jumlah tiket close h-1]' AS message
FROM
    ranked_spv_to
    LEFT JOIN ranked_staff_to ON ranked_spv_to.cluster_id = ranked_staff_to.cluster_id
    LEFT JOIN ticket_info ON ticket_info.pic_id = ranked_staff_to.tx_user_mobile_management_id :: VARCHAR
    JOIN ticket_total_count ON ticket_total_count.cluster_id = ranked_spv_to.cluster_id
GROUP BY
    ranked_spv_to.phone_number,
    ranked_spv_to.cluster_name,
    ticket_total_count.total_all_ticket,
    ticket_total_count.total_take_over_ticket,
    ticket_total_count.total_open_ticket,
    ticket_total_count.total_close_ticket
ORDER BY
    ranked_spv_to.phone_number,
    ranked_spv_to.cluster_name;