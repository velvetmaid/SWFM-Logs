CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to_sample AS
WITH ranked_spv_to AS (
    SELECT
--        DISTINCT d.phone_number,
        a.cluster_id,
        a.cluster_name
    FROM
        wfm_schema.tm_cluster a
--        LEFT JOIN wfm_schema.tx_user_management d ON d.cluster_id = a.cluster_id
--        JOIN wfm_schema.tx_user_role b ON b.ref_user_id = d.ref_user_id
--        JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
--    WHERE
--        a.is_active = true
--        AND a.is_delete = false
--        AND c.code :: text = 'SVTO' :: text
),
clock_in_out_intervals AS (
    SELECT
        tx_absen.userid,
        min(
            CASE
                WHEN tx_absen.absentype = true THEN tx_absen.absentime
                ELSE NULL :: timestamp without time zone
            END
        ) AS first_in_time,
        COALESCE(
            max(
                CASE
                    WHEN tx_absen.absentype = false THEN tx_absen.absentime
                    ELSE NULL :: timestamp without time zone
                END
            ),
            max(
                CASE
                    WHEN tx_absen.absentype = true THEN tx_absen.absentime
                    ELSE NULL :: timestamp without time zone
                END
            )
        ) AS last_out_time
    FROM
        wfm_schema.tx_absen
    WHERE
        tx_absen.absentime >= (CURRENT_DATE - '1 day' :: interval)
    GROUP BY
        tx_absen.userid
),
intervals_calculated AS (
    SELECT
        clock_in_out_intervals.userid,
        clock_in_out_intervals.first_in_time,
        clock_in_out_intervals.last_out_time,
        CASE
            WHEN clock_in_out_intervals.last_out_time IS NOT NULL THEN round(
                date_part(
                    'epoch' :: text,
                    clock_in_out_intervals.last_out_time - clock_in_out_intervals.first_in_time
                ) / 3600 :: double precision
            )
            ELSE 0 :: double precision
        END AS hours_worked
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
        CASE
            WHEN a.cluster_id = 0 THEN e.cluster_id
            ELSE a.cluster_id
        END AS cluster_id,
        a.tx_user_mobile_management_id,
        ic.first_in_time,
        ic.last_out_time,
        ic.hours_worked
    FROM
        wfm_schema.tx_user_mobile_management a
        JOIN intervals_calculated ic ON a.tx_user_mobile_management_id = ic.userid
        JOIN wfm_schema.mapping_user_mobile_role b ON b.tx_user_mobile_management_id = a.tx_user_mobile_management_id
        JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
        LEFT JOIN wfm_schema.tx_ticket_terr_opr d ON a.tx_user_mobile_management_id :: varchar = d.pic_id
        INNER JOIN wfm_schema.tx_site e ON d.site_id = e.site_id
    WHERE
        a.is_active = true
        AND a.is_delete = false
        AND a.is_monitoring = false
        AND (
            c.code :: text = 'MUSERTS' :: text
            OR c.code :: text = 'MUSERMBP' :: text
        )
        AND d.created_at >= (CURRENT_DATE - '1 day' :: interval)
    ORDER BY
        a.employee_name,
        ic.first_in_time
),
ticket_info AS (
    SELECT
        a.pic_id,
        count(
            CASE
                WHEN a.status :: text = 'IN PROGRESS' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS take_over_ticket,
        count(
            CASE
                WHEN a.status :: text = 'ASSIGNED' :: text
                OR a.status :: text = 'CANCELED' :: text
                OR a.status :: text = 'ESCALATED TO CTS' :: text
                OR a.status :: text = 'ESCALATED TO INSERA' :: text
                OR a.status :: text = 'NEW' :: text
                OR a.status :: text = 'RESOLVED' :: text
                OR a.status :: text = 'SUBMITTED' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS open_ticket,
        count(
            CASE
                WHEN a.status :: text = 'CLOSED' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS close_ticket
    FROM
        wfm_schema.tx_ticket_terr_opr a
    WHERE
        a.created_at >= (CURRENT_DATE - '1 day' :: interval)
    GROUP BY
        a.pic_id
),
ticket_total_count AS (
    SELECT
        b.cluster_id,
        count(
            CASE
                WHEN a.status :: text = 'ASSIGNED' :: text
                OR a.status :: text = 'CANCELED' :: text
                OR a.status :: text = 'CLOSED' :: text
                OR a.status :: text = 'ESCALATED TO CTS' :: text
                OR a.status :: text = 'ESCALATED TO INSERA' :: text
                OR a.status :: text = 'IN PROGRESS' :: text
                OR a.status :: text = 'NEW' :: text
                OR a.status :: text = 'RESOLVED' :: text
                OR a.status :: text = 'SUBMITTED' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS total_all_ticket,
        count(
            CASE
                WHEN a.status :: text = 'IN PROGRESS' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS total_take_over_ticket,
        count(
            CASE
                WHEN a.status :: text = 'ASSIGNED' :: text
                OR a.status :: text = 'CANCELED' :: text
                OR a.status :: text = 'ESCALATED TO CTS' :: text
                OR a.status :: text = 'ESCALATED TO INSERA' :: text
                OR a.status :: text = 'NEW' :: text
                OR a.status :: text = 'RESOLVED' :: text
                OR a.status :: text = 'SUBMITTED' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS total_open_ticket,
        count(
            CASE
                WHEN a.status :: text = 'CLOSED' :: text THEN 1
                ELSE NULL :: integer
            END
        ) AS total_close_ticket
    FROM
        wfm_schema.tx_ticket_terr_opr a
        JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id :: text = b.tx_user_mobile_management_id :: character varying :: text
    WHERE
        a.created_at >= (CURRENT_DATE - '1 day' :: interval)
    GROUP BY
        b.cluster_id
)
SELECT
    '6281314612387' as phone_number :: VARCHAR,
    ranked_spv_to.cluster_id,
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
Full Day ' :: text || to_char(
                                                            CURRENT_DATE - '1 day' :: interval,
                                                            'DD FMMonth YYYY' :: text
                                                        )
                                                    ) || '
Dear SPV TO, berikut adalah performance TS/MBP ' :: text
                                                ) || ranked_spv_to.cluster_name :: text
                                            ) || ' :' :: text
                                        ) || '
Total Ticket : ' :: text
                                    ) || ticket_total_count.total_all_ticket
                                ) || '
Total Take Over : ' :: text
                            ) || ticket_total_count.total_take_over_ticket
                        ) || '
Total Open : ' :: text
                    ) || ticket_total_count.total_open_ticket
                ) || '
Total Close : ' :: text
            ) || ticket_total_count.total_close_ticket
        ) || string_agg(
            format(
                '
%s. %s / %s / %s / %s / %s' :: text,
                ranked_staff_to.seq_no,
                ranked_staff_to.staffname,
                ranked_staff_to.hours_worked,
                COALESCE(ticket_info.take_over_ticket, '0' :: bigint),
                COALESCE(ticket_info.open_ticket, '0' :: bigint),
                COALESCE(ticket_info.close_ticket, '0' :: bigint)
            ),
            '' :: text
            ORDER BY
                ranked_staff_to.seq_no
        )
    ) || '  

----------------------------------------
Keterangan
1. [nama], [durasi jam clock in], [jumlah tiket takeover h-1], [jumlah tiket open h-1], [jumlah tiket close h-1]' :: text AS message
FROM
    ranked_spv_to
    LEFT JOIN ranked_staff_to ON ranked_spv_to.cluster_id = ranked_staff_to.cluster_id
    LEFT JOIN ticket_info ON ticket_info.pic_id :: text = ranked_staff_to.tx_user_mobile_management_id :: character varying :: text
    LEFT JOIN ticket_total_count ON ticket_total_count.cluster_id = ranked_spv_to.cluster_id
GROUP BY
--    ranked_spv_to.phone_number,
    ranked_spv_to.cluster_id,
    ranked_spv_to.cluster_name,
    ticket_total_count.total_all_ticket,
    ticket_total_count.total_take_over_ticket,
    ticket_total_count.total_open_ticket,
    ticket_total_count.total_close_ticket
ORDER BY
--    ranked_spv_to.phone_number,
    ranked_spv_to.cluster_name;