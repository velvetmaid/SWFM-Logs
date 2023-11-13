[3:07 PM, 11/13/2023]
(
    tm_etsa_site_administration_id SERIAL PRIMARY KEY,
    site_id VARCHAR(255),
    tm_etsa_reference_bast_id VARCHAR(255),
    created_by BIGINT,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by BIGINT,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    is_active Boolean
);

INSERT INTO wfm_schema.tm_etsa_site_administration(site_id)
SELECT site_id FROM wfm_schema.tx_site;