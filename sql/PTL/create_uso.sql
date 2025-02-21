-- wfm_uso_schema.tx_pengisian_token_listrik_header definition
CREATE TABLE
    wfm_uso_schema.tx_pengisian_token_listrik_header (
        tx_pengisian_token_listrik_header_id SERIAL PRIMARY KEY,
        ticket_no VARCHAR(100) UNIQUE,
        ref_ticket_no_last VARCHAR(100),
        ticket_ipas_id VARCHAR(100),
        id_pelanggan VARCHAR(50),
        id_pelanggan_name VARCHAR(100),
        site_id VARCHAR(25) REFERENCES wfm_uso_schema.tm_site (site_id),
        area_id VARCHAR(5),
        regional_id VARCHAR(5),
        nop_id VARCHAR(30),
        cluster_id INT,
        status VARCHAR(100),
        bulan INT,
        tahun INT,
        kwh_awal NUMERIC(15, 2),
        kwh_akhir NUMERIC(15, 2),
        tanggal_pengisian TIMESTAMP WITHOUT TIME ZONE,
        tanggal_pengisian_terakhir TIMESTAMP WITHOUT TIME ZONE,
        selisih_hari INT,
        pemakaian_kwh_perhari NUMERIC(15, 2),
        estimasi_pengisian_selanjutnya TIMESTAMP WITHOUT TIME ZONE,
        total_kwh_token NUMERIC(15, 2),
        total_kwh_token_terakhir NUMERIC(15, 2),
        total_pengisian_kwh_token NUMERIC(15, 2),
        total_denom_prepaid BIGINT,
        daya_terpasang VARCHAR(50),
        created_by INT,
        created_name VARCHAR(150),
        created_at TIMESTAMP WITHOUT TIME ZONE,
        take_over_by INT,
        take_over_name VARCHAR(150),
        take_over_at TIMESTAMP WITHOUT TIME ZONE,
        request_permit_by INT,
        request_permit_name VARCHAR(150),
        request_permit_at TIMESTAMP WITHOUT TIME ZONE,
        follow_up_by INT,
        follow_up_name VARCHAR(150),
        follow_up_at TIMESTAMP WITHOUT TIME ZONE,
        checkin_by INT,
        checkin_name VARCHAR(150),
        checkin_at TIMESTAMP WITHOUT TIME ZONE,
        submitted_by INT,
        submitted_name VARCHAR(150),
        submitted_at TIMESTAMP WITHOUT TIME ZONE,
        approved_by INT,
        approved_name VARCHAR(150),
        approved_at TIMESTAMP WITHOUT TIME ZONE,
        acknowledge_nop_by INT,
        acknowledge_nop_name VARCHAR(150),
        acknowledge_nop_at TIMESTAMP WITHOUT TIME ZONE,
        is_exclude bool
    );

-- wfm_uso_schema.tx_pengisian_token_listrik definition
CREATE TABLE
    wfm_uso_schema.tx_pengisian_token_listrik (
        tx_pengisian_token_listrik_id SERIAL PRIMARY KEY,
        tx_pengisian_token_listrik_header_id INT REFERENCES wfm_uso_schema.tx_pengisian_token_listrik_header (tx_pengisian_token_listrik_header_id),
        ref_ticket_no VARCHAR(100),
        id_pelanggan VARCHAR(50),
        billing_id VARCHAR(100),
        no_token VARCHAR(50),
        kwh_token NUMERIC(15, 2),
        denom_prepaid BIGINT,
        daya VARCHAR(50),
        kwh_sebelum_pengisian NUMERIC(15, 2),
        foto_kwh_sebelum_pengisian_guuid VARCHAR(255),
        kwh_setelah_pengisian NUMERIC(15, 2),
        foto_kwh_setelah_pengisian_guuid VARCHAR(255),
        status_pengisian_token VARCHAR(100),
        foto_evidence_guuid VARCHAR(255),
        note text
    );