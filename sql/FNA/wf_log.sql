select * from wfm_schema.ticket_technical_support tts 
where ticket_technical_support_id = 292614

select * from wfm_schema.ticket_technical_support tts 
inner join wfm_admin_schema.tx_eventlog te 
on tts.ticket_technical_support_id::varchar = te.transaction_id
where te.process_name = 'Technical Support'
limit 10

select 
tts.ticket_technical_support_id, 
tts.no_ticket,
set tts.take_over_at = MAX(CASE WHEN UPPER(te.action_name) = 'TAKE OVER' THEN te.created_on END) AS take_over_at,
set tts.request_permit_at = MAX(CASE WHEN UPPER(te.action_name) = 'REQUEST PERMIT' THEN te.created_on END) AS request_permit_at,
set tts.follow_up_at MAX(CASE WHEN UPPER(te.action_name) = 'FOLLOW UP' THEN te.created_on END) AS follow_up_at,
set tts.check_in_at MAX(CASE WHEN UPPER(te.action_name) = 'CHECK IN' THEN te.created_on END) AS check_in_at
from wfm_schema.ticket_technical_support tts 
inner join wfm_admin_schema.tx_eventlog te 
on tts.ticket_technical_support_id::varchar = te.transaction_id
where te.process_name = 'Technical Support'
GROUP BY tts.ticket_technical_support_id
order by tts.ticket_technical_support_id desc
limit 500

SELECT 
  tts.ticket_technical_support_id,
  tts.no_ticket,
  sub.take_over_at,
  sub.request_permit_at,
  sub.follow_up_at,
  sub.check_in_at
FROM wfm_schema.ticket_technical_support tts
JOIN (
  SELECT 
    te.transaction_id::varchar AS ticket_technical_support_id,
    MAX(CASE WHEN UPPER(te.action_name) = 'TAKE OVER' THEN te.created_on END) AS take_over_at,
    MAX(CASE WHEN UPPER(te.action_name) = 'REQUEST PERMIT' THEN te.created_on END) AS request_permit_at,
    MAX(CASE WHEN UPPER(te.action_name) = 'FOLLOW UP' THEN te.created_on END) AS follow_up_at,
    MAX(CASE WHEN UPPER(te.action_name) = 'CHECK IN' THEN te.created_on END) AS check_in_at
  FROM wfm_admin_schema.tx_eventlog te
  WHERE te.process_name = 'Technical Support'
  GROUP BY te.transaction_id
) sub ON tts.ticket_technical_support_id::varchar = sub.ticket_technical_support_id
LIMIT 50;

select action_name, created_on from wfm_admin_schema.tx_eventlog te 
where process_name = 'Technical Support'
and transaction_id = '346669'
order by created_on desc

SELECT COUNT(*)
FROM wfm_schema.ticket_technical_support tts
WHERE tts.created_at > '2024-12-01'
  AND EXISTS (
    SELECT 1
    FROM wfm_admin_schema.tx_eventlog te
    WHERE te.transaction_id = tts.ticket_technical_support_id::varchar
      AND te.process_name = 'Technical Support'
  );

SELECT 
  DATE_TRUNC('month', created_at) AS bulan,
  COUNT(*) AS jumlah_transaksi
FROM wfm_schema.ticket_technical_support
WHERE created_at >= '2024-12-01'
GROUP BY 1
ORDER BY 1;

SELECT 
  COUNT(*)
FROM wfm_schema.ticket_technical_support tts
WHERE tts.created_at >= '2024-12-01'
  AND tts.created_at < '2025-01-01'
  AND EXISTS (
    SELECT 1
    FROM wfm_admin_schema.tx_eventlog te
    WHERE te.transaction_id = tts.ticket_technical_support_id::varchar
      AND te.process_name = 'Technical Support'
  );

SELECT 
  tts.ticket_technical_support_id,
  tts.no_ticket
FROM wfm_schema.ticket_technical_support tts
WHERE tts.created_at >= '2024-12-01'
  AND tts.created_at < '2025-01-01'
  AND EXISTS (
    SELECT 1
    FROM wfm_admin_schema.tx_eventlog te
    WHERE te.transaction_id = tts.ticket_technical_support_id::varchar
      AND te.process_name = 'Technical Support'
  )
ORDER BY tts.ticket_technical_support_id
LIMIT 100;


SELECT 
  tts.ticket_technical_support_id,
  tts.no_ticket,
  MAX(CASE WHEN UPPER(te.action_name) = 'TAKE OVER' THEN te.created_on END) AS take_over_at,
  MAX(CASE WHEN UPPER(te.action_name) = 'REQUEST PERMIT' THEN te.created_on END) AS request_permit_at,
  MAX(CASE WHEN UPPER(te.action_name) = 'FOLLOW UP' THEN te.created_on END) AS follow_up_at,
  MAX(CASE WHEN UPPER(te.action_name) = 'CHECK IN' THEN te.created_on END) AS check_in_at
FROM wfm_schema.ticket_technical_support tts
INNER JOIN wfm_admin_schema.tx_eventlog te 
  ON tts.ticket_technical_support_id::varchar = te.transaction_id
WHERE te.process_name = 'Technical Support'
  AND tts.created_at > '2024-12-01'
GROUP BY tts.ticket_technical_support_id, tts.no_ticket
ORDER BY tts.ticket_technical_support_id DESC
LIMIT 100;


SELECT 
  te.transaction_id::varchar AS ticket_technical_support_id,
  MAX(CASE WHEN UPPER(te.action_name) = 'TAKE OVER' THEN te.created_on END) AS take_over_at,
  MAX(CASE WHEN UPPER(te.action_name) = 'REQUEST PERMIT' THEN te.created_on END) AS request_permit_at,
  MAX(CASE WHEN UPPER(te.action_name) = 'FOLLOW UP' THEN te.created_on END) AS follow_up_at,
  MAX(CASE WHEN UPPER(te.action_name) = 'CHECK IN' THEN te.created_on END) AS check_in_at
FROM wfm_admin_schema.tx_eventlog te
WHERE te.process_name = 'Technical Support'
  AND te.transaction_id = '292614'
  AND te.created_on >= '2025-01-01'
  AND te.created_on < '2025-02-01'
GROUP BY te.transaction_id;

UPDATE wfm_schema.ticket_technical_support tts
SET
  take_over_at = sub.take_over_at,
  request_permit_at = sub.request_permit_at,
  follow_up_at = sub.follow_up_at,
  checkin_at = sub.check_in_at
FROM (
  SELECT 
    te.transaction_id::varchar AS ticket_technical_support_id,
    MAX(CASE WHEN UPPER(te.action_name) = 'TAKE OVER' THEN te.created_on END) AS take_over_at,
    MAX(CASE WHEN UPPER(te.action_name) = 'REQUEST PERMIT' THEN te.created_on END) AS request_permit_at,
    MAX(CASE WHEN UPPER(te.action_name) = 'FOLLOW UP' THEN te.created_on END) AS follow_up_at,
    MAX(CASE WHEN UPPER(te.action_name) = 'CHECK IN' THEN te.created_on END) AS check_in_at
  FROM wfm_admin_schema.tx_eventlog te
  WHERE te.process_name = 'Technical Support'
  GROUP BY te.transaction_id
) sub
WHERE tts.ticket_technical_support_id::varchar = sub.ticket_technical_support_id
  AND tts.created_at >= '2025-04-01'

select * from wfm_schema.ticket_technical_support tts 
where ticket_technical_support_id = 346651

SELECT te.*, tts.pic_name
FROM wfm_admin_schema.tx_eventlog te
INNER JOIN wfm_schema.ticket_technical_support tts 
  ON te.transaction_id = tts.ticket_technical_support_id::varchar
WHERE te.process_name = 'Technical Support'
  AND te.action_name = 'CHECK IN'
  AND tts.created_at >= '2024-12-01';


UPDATE wfm_admin_schema.tx_eventlog te
SET actioner_name = tts.pic_name
FROM wfm_schema.ticket_technical_support tts
WHERE te.transaction_id = tts.ticket_technical_support_id::varchar
  AND te.process_name = 'Technical Support'
  AND te.action_name = 'CHECK IN'
  AND tts.created_at >= '2024-12-01';