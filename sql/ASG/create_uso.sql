-- wfm_uso_schema.tx_asset_safe_guard definition
CREATE TABLE
    wfm_uso_schema.tx_asset_safe_guard (
        -- Primary Key
        tx_asset_safe_guard_id BIGSERIAL PRIMARY KEY,
        -- Foreign Keys & Identifiers
        ticket_no VARCHAR(25) NOT NULL,
        site_id VARCHAR(25) REFERENCES wfm_uso_schema.tm_site (site_id) NOT NULL,
        area_id VARCHAR(5) NOT NULL,
        regional_id VARCHAR(5) NOT NULL,
        nop_id VARCHAR(30) NOT NULL,
        cluster_id INT NOT NULL,
        -- Main Information
        guard_name VARCHAR(255) NOT NULL,
        phone_number VARCHAR(25) NOT NULL,
        site_security_type VARCHAR(50) NOT NULL,
        payment_type VARCHAR(25) NOT NULL,
        bank_name VARCHAR(25),
        bank_account VARCHAR(25),
        bank_account_name VARCHAR(25),
        -- Financial Information
        fee_pjs INT NOT NULL,
        fee_jasa_pjs INT NOT NULL,
        total_fee INT NOT NULL,
        -- Status & Approval
        notes VARCHAR(255),
        status VARCHAR(255) NOT NULL,
        approve_by INT,
        approve_name VARCHAR(255),
        approve_at TIMESTAMP WITHOUT TIME ZONE,
        -- Active & Period Info
        is_exclude BOOLEAN DEFAULT false NOT NULL,
        month_period INT NOT NULL,
        year_period INT NOT NULL,
        -- Audit Information
        created_by BIGINT NOT NULL,
        created_at TIMESTAMP WITHOUT TIME ZONE NOT NULL,
        modified_by BIGINT,
        modified_at TIMESTAMP WITHOUT TIME ZONE
    );

-- wfm_uso_schema.tx_asset_safe_guard_file definition
CREATE TABLE
    wfm_uso_schema.tx_asset_safe_guard_file (
        tx_asset_safe_guard_file_id VARCHAR(50) PRIMARY KEY,
        tx_asset_safe_guard_id INT REFERENCES wfm_uso_schema.tx_asset_safe_guard (tx_asset_safe_guard_id) NOT NULL,
        file_name varchar(255) NOT NULL,
        file_sftp_id varchar(50) NOT NULL
    );