SELECT DISTINCT ON (tch.ticket_no) 
    tch.*, te.*, 
    tch.ticket_no, 
    tch.created_at, 
    te.activity_name, 
    te.actioner_name, 
    te.actioner_email, 
    te.action_name
FROM wfm_schema.tx_cmsite_header tch 
INNER JOIN wfm_admin_schema.tx_eventlog te 
    ON tch.cmsite_id::varchar = te.transaction_id
WHERE tch.ticket_no IN (
    'SVA-2025-xxxxxxxxxx'
) and te.process_name = 'Corrective Maintenance'
ORDER BY tch.ticket_no, te.created_on DESC;
