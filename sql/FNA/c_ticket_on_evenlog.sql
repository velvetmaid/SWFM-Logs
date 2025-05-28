select * from wfm_schema.ticket_technical_support tts 
inner join wfm_admin_schema.tx_eventlog tel 
on tts.ticket_technical_support_id::varchar = tel.transaction_id
where tts.status <> 'CANCELED' and tel.action = 'CANCELED';

WITH latest_cancel AS (
    SELECT 
        tts.ticket_technical_support_id, 
        tts.no_ticket, 
        tts.status, 
        tts.modified_at,
        tel.transaction_id, 
        tel.action_name,
        tel.created_on,
        ROW_NUMBER() OVER (
            PARTITION BY tts.ticket_technical_support_id 
            ORDER BY tel.created_on DESC
        ) AS rn
    FROM wfm_schema.ticket_technical_support tts
    INNER JOIN wfm_admin_schema.tx_eventlog tel 
        ON tts.ticket_technical_support_id::varchar = tel.transaction_id
    WHERE 
        tts.status <> 'CANCELED' 
        AND tel.action_name = 'CANCELED' 
        AND tel.process_name = 'Technical Support' 
        AND EXTRACT(YEAR FROM tel.created_on) = 2025
)
SELECT 
    ticket_technical_support_id, 
    no_ticket, 
    status,
    modified_at,
    transaction_id, 
    action_name, 
    created_on
FROM latest_cancel
WHERE rn = 1;

-- TEMP
{
"WITH latest_cancel AS (\r\n    SELECT \r\n        tts.ticket_technical_support_id, \r\n        tts.no_ticket, \r\n        tts.status, \r\n        tts.modified_at,\r\n        tel.transaction_id, \r\n        tel.action_name,\r\n        tel.created_on,\r\n        ROW_NUMBER() OVER (\r\n            PARTITION BY tts.ticket_technical_support_id \r\n            ORDER BY tel.created_on DESC\r\n        ) AS rn\r\n    FROM wfm_schema.ticket_technical_support tts\r\n    INNER JOIN wfm_admin_schema.tx_eventlog tel \r\n        ON tts.ticket_technical_support_id::varchar = tel.transaction_id\r\n    WHERE \r\n        tts.status <> 'CANCELED' \r\n        AND tel.action_name = 'CANCELED' \r\n        AND tel.process_name = 'Technical Support' \r\n        AND EXTRACT(YEAR FROM tel.created_on) = 2025\r\n        AND tts.modified_at <= tel.created_on\r\n)\r\nSELECT \r\n    ticket_technical_support_id, \r\n    no_ticket, \r\n    status,\r\n    modified_at,\r\n    transaction_id, \r\n    action_name, \r\n    created_on\r\nFROM latest_cancel\r\nWHERE rn = 1": [
	{
		"ticket_technical_support_id" : 52435,
		"no_ticket" : "TSM-2024-000000048861",
		"status" : "SUBMITTED"
	},
	{
		"ticket_technical_support_id" : 315497,
		"no_ticket" : "FNA-202503-000000001392",
		"status" : "CLOSED"
	}
]}
