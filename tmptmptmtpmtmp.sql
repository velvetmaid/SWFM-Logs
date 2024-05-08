-- wfm_schema.vw_user_mobile_ticket_status_count source
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_ticket_status_count AS
SELECT
    a.status,
    a.pic_id,
    b.tx_user_mobile_management_id,
    b.employee_name,
    count(*) AS count_status
FROM
    wfm_schema.tx_ticket_terr_opr a
    JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id :: text = b.tx_user_mobile_management_id :: character varying :: text
GROUP BY
    a.status,
    a.pic_id,
    b.tx_user_mobile_management_id,
    b.employee_name;