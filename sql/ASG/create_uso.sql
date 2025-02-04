-- wfm_uso_schema.tx_asset_safe_guard definition
-- Drop table
-- DROP TABLE wfm_uso_schema.tx_asset_safe_guard;
CREATE TABLE
    wfm_uso_schema.tx_asset_safe_guard (
        tx_asset_safe_guard_id SERIAL PRIMARY KEY,
        ticket_no varchar(25),
        site_id VARCHAR(25) REFERENCES wfm_uso_schema.tm_site(site_id),
        nama_penjaga varchar(255),
        phone_num varchar(25),
        type_pengamanan_site_id INT,
        regular_fee INT,
        total_fee INT,
        type_payment varchar(25),
        bank_name varchar(25),
        bank_account varchar(25),
        bank_account_name varchar(25),
        notes varchar(255),
        created_by BIGINT,
        created_at TIMESTAMP WITHOUT TIME ZONE,
        modified_by BIGINT,
        modified_at TIMESTAMP WITHOUT TIME ZONE,
        review varchar(255),
        is_approve bool,
        approve_at TIMESTAMP WITHOUT TIME ZONE,
        approve_by INT,
        approve_status varchar(255),
        period_at TIMESTAMP WITHOUT TIME ZONE,
        is_active bool,
        month_period INT,
        year_period INT
    );

-- wfm_uso_schema.tx_asset_safe_guard_file definition
-- Drop table
-- DROP TABLE wfm_uso_schema.tx_asset_safe_guard_file;
CREATE TABLE
    wfm_uso_schema.tx_asset_safe_guard_file (
        tx_asset_safe_guard_file_id VARCHAR(50) PRIMARY KEY,
        tx_asset_safe_guard_id INT REFERENCES wfm_uso_schema.tx_asset_safe_guard(tx_asset_safe_guard_id),
        file_name varchar(255),
        file_sftp_id varchar(50),
        file_category varchar(255)
    );