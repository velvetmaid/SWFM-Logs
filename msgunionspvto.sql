CREATE
OR REPLACE VIEW wfm_schema.vw_message_spv_to_cluster AS
SELECT
    *
FROM
    wfm_schema.vw_message_spv_to_sample
UNION
SELECT
    *
FROM
    wfm_schema.vw_message_spv_to_no_sample