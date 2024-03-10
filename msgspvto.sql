SELECT
    a.phone_number,
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.' :: text AS message
FROM
    wfm_schema.tx_user_management a
    LEFT JOIN wfm_schema.tx_user_role b ON b.ref_user_id = a.ref_user_id
    LEFT JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
WHERE
    c.code = 'SVTO'
GROUP BY
    a.phone_number;

-- ####
-- ####
-- ####
CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to AS WITH ranked_spv_to AS (
    SELECT
        DISTINCT a.phone_number,
        a.cluster_id,
        d.cluster_name
    FROM
        wfm_schema.tx_user_management a
        INNER JOIN wfm_schema.tx_user_role b ON b.ref_user_id = a.ref_user_id
        INNER JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
        INNER JOIN wfm_schema.tm_cluster d ON d.cluster_id = a.cluster_id
    WHERE
        a.is_active = true
        AND a.is_delete = false
        AND c.code = 'SVTO'
        AND a.cluster_id <> 0
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
            WHEN ranked_absen.absentype THEN 'Clock In'
            ELSE 'Clock Out'
        END AS clock_status
    FROM
        wfm_schema.tx_user_mobile_management a
        JOIN wfm_schema.mapping_user_mobile_role b ON b.tx_user_mobile_management_id = a.tx_user_mobile_management_id
        JOIN wfm_schema.tm_user_role c ON c.tm_user_role_id = b.role_id
        JOIN (
            SELECT
                tx_absen.userid,
                tx_absen.absentype,
                rank() OVER (
                    PARTITION BY tx_absen.userid
                    ORDER BY
                        tx_absen.absentime DESC
                ) AS rank_amount
            FROM
                wfm_schema.tx_absen
        ) ranked_absen ON a.tx_user_mobile_management_id = ranked_absen.userid
        LEFT JOIN wfm_schema.tx_ticket_terr_opr t ON a.tx_user_mobile_management_id :: VARCHAR = t.pic_id
    WHERE
        a.is_active = true
        AND a.is_delete = false
        AND (
            c.code = 'MUSERTS'
            OR c.code = 'MUSERMBP'
        )
        AND ranked_absen.rank_amount < 2
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
                WHEN tx_ticket_terr_opr.status = 'ASSIGNED' THEN 1
                ELSE NULL
            END
        ) AS open_ticket,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'SUBMITTED' THEN 1
                ELSE NULL
            END
        ) AS close_ticket
    FROM
        wfm_schema.tx_ticket_terr_opr
    WHERE
        tx_ticket_terr_opr.created_at >= (CURRENT_DATE - '1 day' :: interval)
        AND tx_ticket_terr_opr.created_at < CURRENT_DATE
    GROUP BY
        tx_ticket_terr_opr.pic_id
),
ticket_total_count AS (
    SELECT
        tx_ticket_terr_opr.pic_id,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'ASSIGNED'
                OR tx_ticket_terr_opr.status = 'SUBMITTED' THEN 1
                ELSE NULL
            END
        ) AS total_all_ticket,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'ASSIGNED' THEN 1
                ELSE NULL
            END
        ) AS total_open_ticket,
        count(
            CASE
                WHEN tx_ticket_terr_opr.status = 'SUBMITTED' THEN 1
                ELSE NULL
            END
        ) AS total_close_ticket
    FROM
        wfm_schema.tx_ticket_terr_opr
    WHERE
        tx_ticket_terr_opr.created_at >= (CURRENT_DATE - '1 day' :: interval)
        AND tx_ticket_terr_opr.created_at < CURRENT_DATE
)
SELECT
    ranked_spv_to.phone_number,
    (
        (
            (
                'TS/MBP Performance Report
----------------------------------------
Dear SPV TO, berikut adalah performance TS/MBP ' || ranked_spv_to.cluster_name
            ) || ' :' '
Total Ticket : ' || ticket_total_count.total_all_ticket '
Total Open : ' || ticket_total_count.total_open_ticket '
Total Close : ' || ticket_total_count.total_close_ticket
        ) || string_agg(
            format(
                '
%s. %s / %s / %s / %s / %s',
                ranked_staff_to.seq_no,
                ranked_staff_to.staffname,
                ranked_staff_to.clock_status,
                COALESCE(
                    ticket_info.take_over_ticket,
                    '0'
                ),
                COALESCE(ticket_info.open_ticket, '0'),
                COALESCE(ticket_info.close_ticket, '0')
            ),
            ''
            ORDER BY
                ranked_staff_to.seq_no
        )
    ) || '
----------------------------------------
Keterangan
1. [nama], [status clock in], [jumlah tiket takeover h-1], [jumlah tiket open h-1], [jumlah tiket close h-1]' AS message
FROM
    ranked_spv_to
    LEFT JOIN ranked_staff_to ON ranked_spv_to.cluster_id = ranked_staff_to.cluster_id
    LEFT JOIN ticket_info ON ticket_info.pic_id = ranked_staff_to.tx_user_mobile_management_id :: VARCHAR
    LEFT JOIN ticket_total_count ON ticket_total_count.cluster_id = ranked_spv_to.cluster_id
GROUP BY
    ranked_spv_to.phone_number,
    ranked_spv_to.cluster_name
ORDER BY
    ranked_spv_to.phone_number,
    ranked_spv_to.cluster_name;