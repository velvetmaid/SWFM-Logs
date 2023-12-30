-- Select User List
SELECT
    tx_user_management.username AS username,
    tx_user_management.email AS email,
    tx_user_management.employee_name AS employe_name,
    tm_regional.regional_name AS regional_name,
    tm_cluster.cluster_name AS cluster_name,
    tm_area.area_name AS area_name
FROM
    tx_user_management
    JOIN tm_regional ON tx_user_management.regional_id = tm_regional.regional_id
    JOIN tm_cluster ON tx_user_management.cluster_id = tm_cluster.cluster_id
    JOIN tm_area ON tx_user_management.area_id = tm_area.area_id;

-- Select Absent
select
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
from
    wfm_schema.tx_absen a
    left join (
        select
            absendate,
            userid,
            min(absentime) timein
        from
            wfm_schema.tx_absen
        where
            absentype = true
        group by
            userid,
            absendate
    ) b on a.userid = b.userid
    and a.absendate = b.absendate
    left join (
        select
            absendate,
            userid,
            max(absentime) timeout
        from
            wfm_schema.tx_absen
        where
            absentype = false
        group by
            userid,
            absendate
    ) c on a.userid = c.userid
    and a.absendate = c.absendate
    left join (
        select
            a.ref_user_id,
            a.username,
            a.area_id,
            a.regional_id,
            a.ns_id,
            b.network_service_name,
            a.cluster_id,
            c.cluster_name,
            a.rtp
        from
            wfm_schema.tx_user_management a
            left join wfm_schema.tm_network_service b on a.ns_id = b.network_service_id
            left join wfm_schema.tm_cluster c on a.cluster_id = c.cluster_id
        where
            a.is_active = true
    ) d on a.userid = d.ref_user_id
group by
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
order by
    a.absendate desc;

-- Create user mobile management
CREATE TABLE wfm_schema.tx_user_mobile_management (
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    role_id INT,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255)
) -- Create mapping_user_mobile_role unused
CREATE TABLE wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_management_id INT,
    tx_user_mobile_management_id INT,
    role_id INT,
    ref_user_id INT,
    role_name VARCHAR(255),
    role_code VARCHAR(255)
) -- Create mapping_user_mobile_role
CREATE TABLE wfm_schema.tm_user_mobile_role (
    tm_user_mobile_role_id SERIAL PRIMARY KEY,
    code varchar(50),
    name varchar(255),
    description varchar(255),
    created_by varchar(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by varchar(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by varchar(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN
) ----------UP PROD 24/10/2023-----------------
CREATE TABLE IF NOT EXISTS wfm_schema.bps_exportpdf_form (
    bps_exportpdf_form_id SERIAL PRIMARY KEY,
    nama_vendor VARCHAR(255),
    job_title VARCHAR(255),
    responsibility_name1 VARCHAR(255),
    responsibility_job_title1 VARCHAR(255),
    responsibility_name2 VARCHAR(255),
    responsibility_job_title2 VARCHAR(255),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at time without time zone
) CREATE TABLE IF NOT EXISTS wfm_schema.bps_monitoring (
    bps_monitoring_id SERIAL PRIMARY KEY,
    no_ticket VARCHAR(255),
    status_ticket VARCHAR(255),
    ref_number VARCHAR(255),
    source_ticket VARCHAR(255),
    group_ticket VARCHAR(255),
    mbp_unit VARCHAR(255),
    site_class VARCHAR(255),
    site_id VARCHAR(255),
    site_name VARCHAR(255),
    user_requestor VARCHAR(255),
    role_name VARCHAR(255),
    assignee_name VARCHAR(255),
    cancel_note VARCHAR(255),
    last_alarm_clear VARCHAR(255),
    resolution_category1 VARCHAR(255),
    resolution_category2 VARCHAR(255),
    resolution_category3 VARCHAR(255),
    issue_category VARCHAR(255),
    root_category1 VARCHAR(255),
    root_category2 VARCHAR(255),
    root_category3 VARCHAR(255),
    resolution_action VARCHAR(255),
    user_submiter VARCHAR(255),
    preparation_time TIMESTAMP WITHOUT TIME ZONE,
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    request_time TIMESTAMP WITHOUT TIME ZONE,
    ack_time TIMESTAMP WITHOUT TIME ZONE,
    departure_time TIMESTAMP WITHOUT TIME ZONE,
    arrival_time TIMESTAMP WITHOUT TIME ZONE,
    cancel_time TIMESTAMP WITHOUT TIME ZONE,
    rh_stop_time TIMESTAMP WITHOUT TIME ZONE,
    leave_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_approver VARCHAR(255),
    running_hour_start_photo VARCHAR(50),
    running_hour_stop_photo VARCHAR(50),
    kwhphoto_before VARCHAR(50),
    kwhphoto_after VARCHAR(50),
    rectifierphoto_before VARCHAR(50),
    rectifierphoto_after VARCHAR(50),
    btsphoto_before VARCHAR(50),
    btsphoto_after VARCHAR(50),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    rh_start_time TIMESTAMP WITHOUT TIME ZONE,
    note VARCHAR(255),
    need_key BOOLEAN,
    kwhmeter BOOLEAN,
    running_hour_start NUMERIC,
    running_hour_stop NUMERIC,
    assignee_id INT,
    note_mobile VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support (
    ticket_technical_support_id SERIAL PRIMARY KEY,
    site_id VARCHAR(25),
    cluster_area VARCHAR(25),
    category VARCHAR(25),
    ticket_subject VARCHAR(50),
    job_details VARCHAR(255),
    job_targets VARCHAR(255),
    sla_start TIMESTAMP WITHOUT TIME ZONE,
    sla_end TIMESTAMP WITHOUT TIME ZONE,
    sla_range VARCHAR(25),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    no_ticket UNIQUE VARCHAR(25),
    activity_name VARCHAR(255),
    role_name VARCHAR(255),
    respone_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_submitter VARCHAR(255),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    user_approve VARCHAR(255),
    note VARCHAR(255),
    review VARCHAR(255),
    status VARCHAR(25),
    rootcause1 VARCHAR(255),
    rootcause2 VARCHAR(255),
    rootcause3 VARCHAR(255),
    rootcause_remark VARCHAR(255),
    resolution_action VARCHAR(255),
    pic_id VARCHAR(255),
    pic_name VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    issue_category VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support_file (
    ticket_technical_support_file_id SERIAL PRIMARY KEY,
    ticket_technical_support_id INT,
    file_name VARCHAR(255),
    file_uploader VARCHAR(255),
    file_uploader_role VARCHAR(255),
    created_at VARCHAR(255),
    file_sftp_id VARCHAR(255) -- CONSTRAINT ticket_technical_support_file_pkey PRIMARY KEY (ticket_technical_support_file_id),
    -- CONSTRAINT ticket_technical_support_file_ticket_technical_support_id_fkey FOREIGN KEY (ticket_technical_support_id)
    -- REFERENCES wfm_schema.ticket_technical_support (ticket_technical_support_id) MATCH SIMPLE
    -- ON UPDATE NO ACTION
    -- ON DELETE NO ACTION
);

---------------END PROD 24/10/23
-- LAST PROD 29/OCT/23
CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support (
    ticket_technical_support_id INT NOT NULL DEFAULT nextval(
        'wfm_schema.ticket_technical_support_ticket_technical_support_id_seq' :: regclass
    ),
    site_id VARCHAR(25),
    cluster_area VARCHAR(25),
    category VARCHAR(25),
    ticket_subject VARCHAR(50),
    job_details VARCHAR(255),
    job_targets VARCHAR(255),
    sla_start TIMESTAMP WITHOUT TIME ZONE,
    sla_end TIMESTAMP WITHOUT TIME ZONE,
    sla_range VARCHAR(25),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    no_ticket VARCHAR(25),
    activity_name VARCHAR(255),
    role_name VARCHAR(255),
    respone_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_submitter VARCHAR(255),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    user_approve VARCHAR(255),
    note VARCHAR(255),
    review VARCHAR(255),
    status VARCHAR(25),
    rootcause1 VARCHAR(255),
    rootcause2 VARCHAR(255),
    rootcause3 VARCHAR(255),
    rootcause_remark VARCHAR(255),
    resolution_action VARCHAR(255),
    pic_id VARCHAR(255),
    pic_name VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    issue_category VARCHAR(255),
    is_asset_change BOOLEAN,
    CONSTRAINT ticket_technical_support_pkey PRIMARY KEY (ticket_technical_support_id),
    CONSTRAINT ticket_technical_support_no_ticket_key UNIQUE (no_ticket)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support_file (
    ticket_technical_support_file_id INT NOT NULL DEFAULT nextval(
        'wfm_schema.ticket_technical_support_file_ticket_technical_support_file_seq' :: regclass
    ),
    ticket_technical_support_id INT,
    file_name VARCHAR(255),
    file_uploader VARCHAR(255),
    file_uploader_role VARCHAR(255),
    created_at VARCHAR(255),
    file_sftp_id VARCHAR(255),
    CONSTRAINT ticket_technical_support_file_pkey PRIMARY KEY (ticket_technical_support_file_id)
);

END;

-- END LAST PROD 29/OCT/23
-- User and role mobile
BEGIN;

CREATE TABLE IF NOT EXISTS wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_management_id INT,
    tx_user_mobile_management_id INT,
    role_id INT,
    ref_user_id INT,
    role_name VARCHAR(255),
    role_code VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

-- JSON Structure local var
{ "mapping_user_mobile_role": { "mapping_user_mobile_role_id": 1,
"tx_user_management": 1,
"tx_user_mobile_management_id": 1,
"role_id": 1,
"ref_user_id": 1 } } CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_mobile_management (
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    role_id INT,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);

END;

-- End user role
-- Asset Safe Guard
CREATE TABLE IF NOT EXISTS wfm_schema.tx_asset_safe_guard (
    asset_safe_guard_id SERIAL PRIMARY KEY,
    no_ticket VARCHAR(25),
    site_id VARCHAR(25),
    nama_penjaga VARCHAR(255),
    phone_num VARCHAR(25),
    type_pengamanan_site_id INT,
    regular_fee INT,
    total_fee INT,
    type_payment VARCHAR(25),
    bank_name VARCHAR(25),
    bank_account VARCHAR(25),
    bank_account_name VARCHAR(25),
    notes VARCHAR(255),
    created_by BIGINT,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by BIGINT,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    approve_status VARCHAR(25),
    approver_name VARCHAR(25),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    review VARCHAR(255),
    --    CONSTRAINT asset_safe_guard_pkey PRIMARY KEY (asset_safe_guard_id),
    --    CONSTRAINT asset_safe_guard_no_ticket_key UNIQUE (no_ticket),
    --    CONSTRAINT asset_safe_guard_type_pengamanan_site_id_fkey FOREIGN KEY (type_pengamanan_site_id)
    --        REFERENCES wfm_schema.tm_type_pengamanan_site (tm_type_pengamanan_site_id) MATCH SIMPLE
    --        ON UPDATE NO ACTION
    --        ON DELETE NO ACTION
) CREATE TABLE IF NOT EXISTS wfm_schema.tx_asset_safe_guard_file (
    asset_safe_guard_file_id SERIAL PRIMARY KEY,
    asset_safe_guard INT,
    file_name VARCHAR(255),
    file_content BYTEA,
    file_sftp_id VARCHAR(50)
) -- End Asset Safe Guard
--#################### Migrasi mobile user ####################--
BEGIN;

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_management (
    tx_user_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    role_id INT,
    is_organic BOOLEAN,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_mobile_management (
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    ref_user_id INT,
    ref_user_id_before INT,
    partner_id INT,
    description VARCHAR(255),
    -- New column phone number
    phone_number VARCHAR(25),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_role (
    id SERIAL PRIMARY KEY,
    role_id INT,
    ref_user_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

CREATE TABLE IF NOT EXISTS wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_mobile_management_id INT,
    role_id INT,
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

END;

--#################### End migration mobile user ####################--
-- 
-- NEW  CGL Imbas Petir --
CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl (
    tx_cgl_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    status VARCHAR(255),
    total_price DECIMAL,
    name VARCHAR(255),
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    tower_height DECIMAL,
    site_id VARCHAR(255),
    site_name VARCHAR(255),
    building_height DECIMAL,
    incident_date TIMESTAMP WITHOUT TIME ZONE,
    total_resident INT,
    boq_file_name VARCHAR(255),
    boq_file BYTEA,
    boq_file_sftp_id VARCHAR(255),
    isapproveboq BOOLEAN,
    approveboq_at TIMESTAMP WITHOUT TIME ZONE,
    approveboq_by INT,
    isrejectedboq BOOLEAN,
    rejectedboq_at TIMESTAMP WITHOUT TIME ZONE,
    rejectedboq_by INT,
    stw_file_name VARCHAR(255),
    stw_file BYTEA,
    stw_file_sftp_id VARCHAR(255),
    evidence_date TIMESTAMP WITHOUT TIME ZONE,
    bmkg_file_name VARCHAR(255),
    bmkg_file BYTEA,
    bmkg_file_sftp_id VARCHAR(255),
    request_user VARCHAR(255),
    request_date TIMESTAMP WITHOUT TIME ZONE,
    jumlah_barang_terverifikaksi INT,
    spi_number VARCHAR(255),
    spi_file_name VARCHAR(255),
    spi_file BYTEA,
    spi_file_sftp_id VARCHAR(255),
    spph_file_name VARCHAR(255),
    spph_file BYTEA,
    spph_file_sftp_id VARCHAR(255),
    daisy_number VARCHAR(255),
    daisy_file_name VARCHAR(255),
    daisy_file BYTEA,
    daisy_file_sftp_id VARCHAR(255),
    sph_file_name VARCHAR(255),
    sph_file BYTEA,
    sph_file_sftp_id VARCHAR(255),
    ba_kesepakatan_negosiasi_file_name VARCHAR(255),
    ba_kesepakatan_negosiasi_file BYTEA,
    ba_kesepakatan_negosiasi_file_sftp_id VARCHAR(255),
    nodin_number VARCHAR(255),
    nodin_file_name VARCHAR(255),
    nodin_file BYTEA,
    nodin_file_sftp_id VARCHAR(255),
    notes TEXT,
    cluster_area VARCHAR(255),
    iscommcase BOOLEAN,
    isverify BOOLEAN,
    verifiy_at TIMESTAMP WITHOUT TIME ZONE,
    verifiy_by INT,
    isapprovenop BOOLEAN,
    approvenop_at TIMESTAMP WITHOUT TIME ZONE,
    approvenop_by INT,
    isapprovensmgr BOOLEAN,
    approvensmgr_at TIMESTAMP WITHOUT TIME ZONE,
    approvensmgr_by INT,
    isapprovenosmgr BOOLEAN,
    approvenosmgr_at TIMESTAMP WITHOUT TIME ZONE,
    approvenosmgr_by INT,
    is_submitted BOOLEAN,
    submitted_by INT,
    is_rejected BOOLEAN,
    rejected_by INT,
    keterangan_commcase VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_tower_olo (
    tx_cgl_olo_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    tower_name VARCHAR(255),
    operator VARCHAR(255),
    foto_rumah BYTEA,
    foto_rumah_sftp_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_tower_grounding_site (
    tx_cgl_grounding_site_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    label VARCHAR(255),
    nilai_pengukuran DECIMAL,
    status_grounding VARCHAR(255),
    foto_rumah BYTEA,
    foto_rumah_sftp_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_residents_data_warga (
    tx_cgl_residents_data_warga_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    nama_warga VARCHAR(255),
    no_ktp VARCHAR(255),
    no_kk VARCHAR(255),
    alamat TEXT,
    koordinate_rumah TEXT,
    distance_status VARCHAR(255),
    distance_to_site_m VARCHAR(255),
    document_report_file_name VARCHAR(255),
    document_report_file BYTEA,
    document_report_file_sftp_id VARCHAR(255),
    document_ba_investigation_file_name VARCHAR(255),
    document_ba_investigation_file BYTEA,
    document_ba_investigation_file_sftp_id VARCHAR(255),
    report_date TIMESTAMP WITHOUT TIME ZONE,
    jumlah_barang INT,
    price_estimation DECIMAL,
    foto_rumah BYTEA,
    foto_rumah_sftp_id VARCHAR(255),
    foto_ktp BYTEA,
    foto_ktp_sftp_id VARCHAR(255),
    foto_kk BYTEA,
    foto_kk_sftp_id VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_residents_barang (
    tx_cgl_residents_barang_id SERIAL PRIMARY KEY,
    tx_cgl_residents_data_warga_id INT,
    pemilik VARCHAR(255),
    ticket_no VARCHAR(255),
    kode_barang VARCHAR(255),
    label VARCHAR(255),
    deskripsi_barang VARCHAR(255),
    nomor_part VARCHAR(255),
    nomor_serial VARCHAR(255),
    foto_barang BYTEA,
    foto_barang_sftp_id VARCHAR(255),
    claim_action VARCHAR(255),
    status VARCHAR(255),
    qty INT,
    estimation_price DECIMAL,
    approved_price DECIMAL,
    total_price DECIMAL,
    tm_catalogue_brand_id INT,
    tm_catalogue_brand_item_id INT,
    tm_catalogue_brand_type_id INT,
    tm_catalogue_brand_size_id INT
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_operational_fee (
    tx_cgl_operational_fee_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    item_description VARCHAR(255),
    qty INT,
    price DECIMAL,
    fee DECIMAL,
    total DECIMAL
);

-- CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_olo (
--     tx_cgl_olo_id SERIAL PRIMARY KEY,
--     ticket_no VARCHAR(255),
--     tower_name VARCHAR(255),
--     operator VARCHAR(255),
--     foto_rumah BYTEA
-- );
CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand (
    tm_catalogue_brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(255),
    brand_code VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand_item (
    tm_catalogue_brand_item_id SERIAL PRIMARY KEY,
    item_code VARCHAR(255),
    item_name VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand_type (
    tm_catalogue_brand_type_id SERIAL PRIMARY KEY,
    tm_catalogue_brand_item_id INT,
    type_code VARCHAR(255),
    type_name VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_catalogue_brand_size (
    tm_catalogue_brand_size_id SERIAL PRIMARY KEY,
    tm_catalogue_brand_item_id INT,
    tm_catalogue_brand_type_id INT,
    size_code VARCHAR(255),
    size_name VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

-- CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_mobile (
--     tx_cgl_mobile_id SERIAL PRIMARY KEY,
--     ticket_no VARCHAR(255),
--     site_id VARCHAR(255),
--     tower_height DECIMAL,
--     building_height DECIMAL,
--     catatan TEXT,
--     cluster_area VARCHAR(255),
--     incident_date TIMESTAMP WITHOUT TIME ZONE,
--     created_by VARCHAR(255),
--     created_at TIMESTAMP WITHOUT TIME ZONE,
--     modified_by VARCHAR(255),
--     modified_at TIMESTAMP WITHOUT TIME ZONE
-- )
-- 
-- TOWER INFO
-- 
CREATE TABLE wfm_schema.tm_tower_info (
    tower_info_id SERIAL PRIMARY KEY,
    site_id VARCHAR(25),
    tower_type VARCHAR(50),
    tower_height DECIMAL,
    land_type VARCHAR(25),
    building_type VARCHAR(25),
    building_height DECIMAL,
    building_space DECIMAL,
    building_floor DECIMAL,
    building_spot DECIMAL,
    systems VARCHAR(25),
    include_pool VARCHAR(25)
);

-- 
\ COPY wfm_schema.tm_tower_info (
    site_id,
    tower_type,
    tower_height,
    land_type,
    building_type,
    building_height,
    building_space,
    building_floor,
    building_spot,
    systems,
    include_pool
)
FROM
    'C:/Users/23358275/Documents/tower_info rmv id.csv' DELIMITER E '\t' CSV HEADER;

-- 
\ COPY wfm_schema.tm_tower_info (
    site_id,
    tower_type,
    tower_height,
    land_type,
    building_type,
    building_height,
    building_space,
    building_floor,
    building_spot,
    systems,
    include_pool
)
FROM
    'C:/Users/23358275/Documents/tower_info rmv id.csv' DELIMITER ';' CSV HEADER;

CREATE TABLE wfm_schema.tm_file_template (
    tm_file_template_id SERIAL PRIMARY KEY,
    file_name TEXT,
    file_binary BYTEA,
    file_sftp_id VARCHAR(50),
    file_action VARCHAR(25)
);

-- Recap PLN
CREATE TABLE IF NOT EXISTS wfm_schema.tx_recap_pln_ticket (
    tx_ticket_recap_pln_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    site_id VARCHAR(50),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE IF NOT EXISTS wfm_schema.tx_recap_pln (
    tx_recap_pln_id SERIAL PRIMARY KEY,
    ticket_no VARCHAR(255),
    site_id VARCHAR(50),
    asset_terdapat_di_site VARCHAR(50),
    asset_terpasang VARCHAR(50),
    asset_rusak VARCHAR(50),
    asset_aktif VARCHAR(50),
    asset_dicuri VARCHAR(50),
    tsel_barcode VARCHAR(255),
    nama_asset VARCHAR(255),
    merk_asset VARCHAR(255),
    category_asset VARCHAR(255),
    serial_number VARCHAR(255),
    asset_owner VARCHAR(255),
    foto_dekat_tagging BYTEA,
    foto_dekat_tagging_name VARCHAR(255),
    foto_dekat_tagging_location VARCHAR(255),
    foto_jauh_tagging BYTEA,
    foto_jauh_tagging_name VARCHAR(255),
    foto_jauh_tagging_location VARCHAR(255),
    foto_dekat_saat_ini BYTEA,
    foto_dekat_saat_ini_name VARCHAR(255),
    foto_dekat_saat_ini_location VARCHAR(255),
    foto_jauh_saat_ini BYTEA,
    foto_jauh_saat_ini_name VARCHAR(255),
    foto_jauh_saat_ini_location VARCHAR(255),
    keterangan VARCHAR(255),
    daya_listrik NUMERIC(8, 2),
    foto_daya_listrik BYTEA,
    foto_daya_listrik_name VARCHAR(255),
    foto_daya_listrik_location VARCHAR(255),
    id_pelanggan_pln VARCHAR(50),
    foto_id_pelanggan_pln BYTEA,
    foto_id_pelanggan_pln_name VARCHAR(255),
    foto_id_pelanggan_pln_location VARCHAR(255),
    id_pelanggan_pln_existing VARCHAR(50),
    id_pelanggan_pln_perubahan VARCHAR(50),
    foto_id_pelanggan_pln_perubahan BYTEA,
    foto_id_pelanggan_pln_perubahan_name VARCHAR(255),
    foto_id_pelanggan_pln_perubahan_location VARCHAR(255),
    sumber_catuan VARCHAR(255),
    pengukuran_kwh_bulan_lalu NUMERIC(8, 2),
    foto_pengukuran_kwh_bulan_lalu BYTEA,
    foto_pengukuran_kwh_bulan_lalu_name VARCHAR(255),
    foto_pengukuran_kwh_bulan_lalu_location VARCHAR(255),
    pengukuran_kwh_bulan_sekarang NUMERIC(8, 2),
    foto_pengukuran_kwh_bulan_sekarang BYTEA,
    foto_pengukuran_kwh_bulan_sekarang_name VARCHAR(255),
    foto_pengukuran_kwh_bulan_sekarang_location VARCHAR(255),
    durasi_pengukuran_lalu_sekarang integer,
    sistem_tegangan NUMERIC(8, 2),
    panel_distribusi_utama VARCHAR(50),
    cek_kabel VARCHAR(50),
    cek_kabel_keterangan VARCHAR(255),
    cek_baut_terminal VARCHAR(50),
    cek_baut_terminal_keterangan VARCHAR(255),
    cek_baut_mcb VARCHAR(50),
    cek_baut_mcb_keterangan VARCHAR(255),
    lampu_indikator_rst VARCHAR(50),
    lampu_indikator_rst_keterangan VARCHAR(255),
    cos_genset VARCHAR(50),
    cos_genset_keterangan VARCHAR(255),
    foto_checkpanel_distribusi_utama BYTEA,
    foto_checkpanel_distribusi_utama_name VARCHAR(255),
    foto_checkpanel_distribusi_utama_location VARCHAR(255),
    teg_phase_rn NUMERIC(10, 2),
    foto_teg_phase_rn BYTEA,
    foto_teg_phase_rn_name VARCHAR(255),
    foto_teg_phase_rn_location VARCHAR(255),
    teg_phase_sn NUMERIC(10, 2),
    foto_teg_phase_sn BYTEA,
    foto_teg_phase_sn_name VARCHAR(255),
    foto_teg_phase_sn_location VARCHAR(255),
    teg_phase_tn NUMERIC(10, 2),
    foto_teg_phase_tn BYTEA,
    foto_teg_phase_tn_name VARCHAR(255),
    foto_teg_phase_tn_location VARCHAR(255),
    teg_phase_rt NUMERIC(10, 2),
    foto_teg_phase_rt BYTEA,
    foto_teg_phase_rt_name VARCHAR(255),
    foto_teg_phase_rt_location VARCHAR(255),
    teg_phase_st NUMERIC(10, 2),
    foto_teg_phase_st BYTEA,
    foto_teg_phase_st_name VARCHAR(255),
    foto_teg_phase_st_location VARCHAR(255),
    teg_phase_rs NUMERIC(10, 2),
    foto_teg_phase_rs BYTEA,
    foto_teg_phase_rs_name VARCHAR(255),
    foto_teg_phase_rs_location VARCHAR(255),
    teg_phase_gn NUMERIC(10, 2),
    foto_teg_phase_gn BYTEA,
    foto_teg_phase_gn_name VARCHAR(255),
    foto_teg_phase_gn_location VARCHAR(255),
    total_arus_phase_r NUMERIC(10, 2),
    foto_total_arus_phase_r BYTEA,
    foto_total_arus_phase_r_name VARCHAR(255),
    foto_total_arus_phase_r_location VARCHAR(255),
    total_arus_phase_s NUMERIC(10, 2),
    foto_total_arus_phase_s BYTEA,
    foto_total_arus_phase_s_name VARCHAR(255),
    foto_total_arus_phase_s_location VARCHAR(255),
    total_arus_phase_t NUMERIC(10, 2),
    foto_total_arus_phase_t BYTEA,
    foto_total_arus_phase_t_name VARCHAR(255),
    foto_total_arus_phase_t_location VARCHAR(255),
    total_arus_frek NUMERIC(10, 2),
    foto_total_arus_frek BYTEA,
    foto_total_arus_frek_name VARCHAR(255),
    foto_total_arus_frek_location VARCHAR(255),
    arester_phase_r VARCHAR(50),
    arester_phase_s VARCHAR(50),
    arester_phase_t VARCHAR(50),
    arester_phase_n VARCHAR(50),
    foto_arester_kwh BYTEA,
    foto_arester_kwh_name VARCHAR(255),
    foto_arester_kwh_location VARCHAR(255),
    description VARCHAR(255),
    start_period_at TIMESTAMP WITHOUT TIME ZONE,
    end_period_at TIMESTAMP WITHOUT TIME ZONE,
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN
);

CREATE TABLE IF NOT EXISTS wfm_schema.tm_power_pln_pelanggan (
    tm_power_pln_pelanggan SERIAL PRIMARY KEY,
    id_pelanggan_nomor VARCHAR(50),
    id_pelanggan_name VARCHAR(255),
    site_id VARCHAR(25),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    nop_id VARCHAR(30),
    cluster_id VARCHAR(30),
    jenis_inquiry VARCHAR(100),
    tarif_terpasang VARCHAR(50),
    daya_terpasang VARCHAR(50),
    skema_bayar VARCHAR(100),
    prefix VARCHAR(100),
    wilayah_pln VARCHAR(255),
    area_pln VARCHAR(255),
    status_id_pelanggan VARCHAR(100),
    amr_status VARCHAR(100),
    asset_holder VARCHAR(100),
    denom_prepaid VARCHAR(100),
    status_ttc VARCHAR(100),
    tp_name VARCHAR(100),
    tower_type VARCHAR(100)
);


-- no	area	regional	nop	siteid	prefix	sitename	alamat	koordinat	towerholder	typepmsite	categorysite	idpelnomor	idpelnama	jenissite	jenisbill	tarif	daya	status

CREATE TABLE IF NOT EXISTS wfm_schema.dummy_pln_pelanggan (
    id SERIAL PRIMARY KEY,
    area VARCHAR,
    regional VARCHAR,
    nop VARCHAR,
    siteid VARCHAR,
    prefix VARCHAR,
    sitename VARCHAR,
    alamat VARCHAR,
    koordinat VARCHAR,
    towerholder VARCHAR,
    typepmsite VARCHAR,
    categorysite VARCHAR,
    idpelnomor VARCHAR,
    idpelnama VARCHAR,
    jenissite VARCHAR,
    jenisbill VARCHAR,
    tarif VARCHAR,
    daya VARCHAR,
    status VARCHAR
);