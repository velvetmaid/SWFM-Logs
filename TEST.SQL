-- wfm_schema.vw_message_spv_to source
CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to AS WITH ranked_spv_to AS (
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
                WHEN tx_ticket_terr_opr.status = 'CLOSED' THEN 1
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
                WHEN a.status = 'ASSIGNED' THEN 1
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
        a.created_at >= (CURRENT_DATE - '1 day' :: interval)
        AND a.created_at < CURRENT_DATE
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
                ranked_staff_to.clock_status,
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
1. [nama], [status clock in], [jumlah tiket takeover h-1], [jumlah tiket open h-1], [jumlah tiket close h-1]' AS message
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
    

select * from wfm_schema.tx_absen  
   
select * from wfm_schema.asset_safe_guard where file_sftp_id is not null

select * from wfm_schema.ticket_technical_support tts where activity_name is not null

select left(inap_ticket_no)aarom wfm_schema.tx_ticket_terr_opr ttto   ass

select * from wfm_schema.tx_user_management tumm where email like '%staffnop%'


CREATE TABLE wfm_schema.tx_recap_pln (
    tx_recap_pln_id SERIAL PRIMARY KEY,
    ticket_no varchar(255),
    site_id varchar(50),
    asset_terdapat_di_site varchar(50),
    asset_terpasang varchar(50),
    asset_rusak varchar(50),
    note_asset_rusak text,
    asset_aktif varchar(50),
    asset_dicuri varchar(50),
    tsel_barcode varchar(255),
    nama_asset varchar(255),
    merk_asset varchar(255),
    category_asset varchar(255),
    serial_number varchar(255),
    asset_owner varchar(255),
    status varchar(255),
    foto_dekat_tagging bytea,
    foto_dekat_tagging_name varchar(255),
    foto_dekat_tagging_location varchar(255),

    foto_jauh_tagging bytea,
    foto_jauh_tagging_name varchar(255),
    foto_jauh_tagging_location varchar(255),

    foto_dekat_saat_ini bytea,
    foto_dekat_saat_ini_name varchar(255),
    foto_dekat_saat_ini_location varchar(255),

    foto_jauh_saat_ini bytea,
    foto_jauh_saat_ini_name varchar(255),
    foto_jauh_saat_ini_location varchar(255),

    keterangan varchar(255),
    daya_listrik_ipas numeric,
    daya_sesuai varchar(50),
    daya_listrik numeric,
    foto_daya_listrik bytea,
    foto_daya_listrik_name varchar(255),
    foto_daya_listrik_location varchar(255),

    id_pelanggan_pln_ipas varchar(50),
    foto_id_pelanggan_pln_ipas bytea,
    foto_id_pelanggan_pln_ipas_name varchar(255),
    foto_id_pelanggan_pln_ipas_location varchar(255),

    id_pelanggan_sesuai varchar(50),
    id_pelanggan_terbaca varchar(50),
    id_pelanggan_pln varchar(50),
    foto_id_pelanggan_pln bytea,
    foto_id_pelanggan_pln_name varchar(255),
    foto_id_pelanggan_pln_location varchar(255),

    id_pelanggan_pln_perubahan varchar(50),
    foto_id_pelanggan_pln_perubahan bytea,
    foto_id_pelanggan_pln_perubahan_name varchar(255),
    foto_id_pelanggan_pln_perubahan_location varchar(255),

    sumber_catuan varchar(255),
    pengukuran_kwh_bulan_lalu numeric(8, 2),
    foto_pengukuran_kwh_bulan_lalu bytea,
    foto_pengukuran_kwh_bulan_lalu_name varchar(255),
    foto_pengukuran_kwh_bulan_lalu_location varchar(255),

    pengukuran_kwh_bulan_sekarang numeric(8, 2),
    foto_pengukuran_kwh_bulan_sekarang bytea,
    foto_pengukuran_kwh_bulan_sekarang_name varchar(255),
    foto_pengukuran_kwh_bulan_sekarang_location varchar(255),

    durasi_pengukuran_lalu_sekarang INT,
    sistem_tegangan numeric(8, 2),
    no_laporan varchar(255),
    foto_laporan bytea,
    foto_laporan_name varchar(255),
    foto_laporan_location varchar(255),

    schedule_date TIMESTAMP WITHOUT TIME ZONE,
    actual_date TIMESTAMP WITHOUT TIME ZONE,
    score DECIMAL,
    site_operator VARCHAR(255),
    type_power VARCHAR(255),
    type_maintenance VARCHAR(255),
    maintenance VARCHAR(100),
    rtp VARCHAR(255),
	response_time TIMESTAMP WITHOUT TIME ZONE,
	submmit_at TIMESTAMP WITHOUT TIME ZONE,
	submit_by INT,
	approve_at TIMESTAMP WITHOUT TIME ZONE,
	approve_by INT,
    start_period_at TIMESTAMP WITHOUT TIME ZONE,
    end_period_at TIMESTAMP WITHOUT TIME ZONE,
    note varchar(255),
    pic_id varchar(255),
	pic_name varchar(255),
	ref_ticket_no varchar(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by varchar(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    -- 
    -- unused
    panel_distribusi_utama varchar(50),
    cek_kabel varchar(50),
    cek_kabel_keterangan varchar(255),
    cek_baut_terminal varchar(50),
    cek_baut_terminal_keterangan varchar(255),
    cek_baut_mcb varchar(50),
    cek_baut_mcb_keterangan varchar(255),
    lampu_indikator_rst varchar(50),
    lampu_indikator_rst_keterangan varchar(255),
    cos_genset varchar(50),
    cos_genset_keterangan varchar(255),
    foto_checkpanel_distribusi_utama bytea,
    foto_checkpanel_distribusi_utama_name varchar(255),
    foto_checkpanel_distribusi_utama_location varchar(255),

    teg_phase_rn numeric(10, 2),
    foto_teg_phase_rn bytea,
    foto_teg_phase_rn_name varchar(255),
    foto_teg_phase_rn_location varchar(255),

    teg_phase_sn numeric(10, 2),
    foto_teg_phase_sn bytea,
    foto_teg_phase_sn_name varchar(255),
    foto_teg_phase_sn_location varchar(255),

    teg_phase_tn numeric(10, 2),
    foto_teg_phase_tn bytea,
    foto_teg_phase_tn_name varchar(255),
    foto_teg_phase_tn_location varchar(255),

    teg_phase_rt numeric(10, 2),
    foto_teg_phase_rt bytea,
    foto_teg_phase_rt_name varchar(255),
    foto_teg_phase_rt_location varchar(255),

    teg_phase_st numeric(10, 2),
    foto_teg_phase_st bytea,
    foto_teg_phase_st_name varchar(255),
    foto_teg_phase_st_location varchar(255),

    teg_phase_rs numeric(10, 2),
    foto_teg_phase_rs bytea,
    foto_teg_phase_rs_name varchar(255),
    foto_teg_phase_rs_location varchar(255),

    teg_phase_gn numeric(10, 2),
    foto_teg_phase_gn bytea,
    foto_teg_phase_gn_name varchar(255),
    foto_teg_phase_gn_location varchar(255),

    total_arus_phase_r numeric(10, 2),
    foto_total_arus_phase_r bytea,
    foto_total_arus_phase_r_name varchar(255),
    foto_total_arus_phase_r_location varchar(255),

    total_arus_phase_s numeric(10, 2),
    foto_total_arus_phase_s bytea,
    foto_total_arus_phase_s_name varchar(255),
    foto_total_arus_phase_s_location varchar(255),

    total_arus_phase_t numeric(10, 2),
    foto_total_arus_phase_t bytea,
    foto_total_arus_phase_t_name varchar(255),
    foto_total_arus_phase_t_location varchar(255),

    total_arus_frek numeric(10, 2),
    foto_total_arus_frek bytea,
    foto_total_arus_frek_name varchar(255),
    foto_total_arus_frek_location varchar(255),

    arester_phase_r varchar(50),
    arester_phase_s varchar(50),
    arester_phase_t varchar(50),
    arester_phase_n varchar(50),
    foto_arester_kwh bytea,
    foto_arester_kwh_name varchar(255),
    foto_arester_kwh_location varchar(255),

    description varchar(255)
);


select * from wfm_schema.tm_nop where nop_name like '%B%'

select * from wfm_schema.tx_user_management tum where area_id = 'Area4'

select * from wfm_schema.tx_recap_pln where site_id like 'BJI%'

select * from wfm_schema.tx_user_management tum where username like '%nop%'

select * from wfm_schema.tx_user_management where phone_number like '61%'

select * from wfm_schema.tx_absen ta 

select distinct status from wfm_schema.tx_ticket_terr_opr ttto 

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
    END AS clock_status,
    ranked_absen.rank_amount,
    ranked_absen.absentime
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
    AND ranked_absen.rank_amount < 2 and ranked_absen.absentime >= (CURRENT_DATE - '1 day' :: interval)