CREATE TABLE IF NOT EXISTS wfm_schema.tx_cgl_operational_fee_history (
    id varchar(50) primary key,
    tx_cgl_operational_fee_id BIGINT REFERENCES wfm_schema.tx_cgl_operational_fee (tx_cgl_operational_fee_id),
    metadata text,
    created_metadata text
);

drop table wfm_schema.tx_cgl_operational_fee_history;

775646d0ac28142f