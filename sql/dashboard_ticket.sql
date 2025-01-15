-- Query 1: Count tickets per employee from tx_cmsite_header
select tumm.employee_name, count(*) 
from wfm_schema.tx_user_mobile_management tumm 
inner join wfm_schema.tx_cmsite_header tch 
on tumm.tx_user_mobile_management_id :: varchar = tch.pic_id
group by tumm.tx_user_mobile_management_id

-- Query 2: Count tickets per employee from tx_ticket_terr_opr
select tumm.employee_name, count(*) 
from wfm_schema.tx_user_mobile_management tumm
inner join wfm_schema.tx_ticket_terr_opr tto
on tumm.tx_user_mobile_management_id :: varchar = tto.pic_id
group by tumm.tx_user_mobile_management_id

-- Query 3: Count tickets per employee from tx_pm_ticket_site
select tumm.employee_name, count(*) 
from wfm_schema.tx_user_mobile_management tumm
inner join wfm_schema.tx_pm_ticket_site tpts 
on tumm.tx_user_mobile_management_id :: varchar = tpts.pic_id
group by tumm.tx_user_mobile_management_id

-- Query 4: Union of ticket counts from different sources
SELECT 
    tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    'INAP' AS source,
    COUNT(*) AS ticket_count 
FROM wfm_schema.tx_user_mobile_management tumm
INNER JOIN wfm_schema.tx_ticket_terr_opr tto
ON tumm.tx_user_mobile_management_id :: varchar = tto.pic_id
GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name
UNION ALL
SELECT 
    tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    'SVA' AS source,
    COUNT(*) AS ticket_count 
FROM wfm_schema.tx_user_mobile_management tumm 
INNER JOIN wfm_schema.tx_cmsite_header tch 
ON tumm.tx_user_mobile_management_id :: varchar = tch.pic_id
GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name
UNION ALL
SELECT 
    tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    'PM' AS source,
    COUNT(*) AS ticket_count 
FROM wfm_schema.tx_user_mobile_management tumm
INNER JOIN wfm_schema.tx_pm_ticket_site tpts 
ON tumm.tx_user_mobile_management_id :: varchar = tpts.pic_id
GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name

-- Query 5: Combined ticket counts from different sources
SELECT
    combined_ticket.tx_user_mobile_management_id, 
    combined_ticket.employee_name,
    SUM(CASE WHEN source = 'INAP' THEN inap_ticket_count ELSE 0 END) AS inap_ticket_count,
    SUM(CASE WHEN source = 'SVA' THEN sva_ticket_count ELSE 0 END) AS sva_ticket_count,
    SUM(CASE WHEN source = 'PM' THEN pm_ticket_count ELSE 0 END) AS pm_ticket_count,
    SUM(CASE WHEN source = 'FNA' THEN fna_ticket_count ELSE 0 END) AS fna_ticket_count,
    SUM(ticket_count) AS total_ticket_count
FROM (
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name, 
        'INAP' AS source,
        COUNT(*) AS inap_ticket_count,
        0 AS sva_ticket_count,
        0 AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.tx_ticket_terr_opr inap
    ON tumm.tx_user_mobile_management_id::varchar = inap.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name, 
        'SVA' AS source,
        0 AS inap_ticket_count,
        COUNT(*) AS sva_ticket_count,
        0 AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm 
    INNER JOIN wfm_schema.tx_cmsite_header sva
    ON tumm.tx_user_mobile_management_id::varchar = sva.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name, 
        'PM' AS source,
        0 AS inap_ticket_count,
        0 AS sva_ticket_count,
        COUNT(*) AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.tx_pm_ticket_site pm
    ON tumm.tx_user_mobile_management_id::varchar = pm.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name, 
        'FNA' AS source,
        0 AS inap_ticket_count,
        0 AS sva_ticket_count,
        0 AS pm_ticket_count,
        COUNT(*) AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.ticket_technical_support fna 
    ON tumm.tx_user_mobile_management_id::varchar = fna.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name
) AS combined_ticket
GROUP BY combined_ticket.tx_user_mobile_management_id, combined_ticket.employee_name;

-- Query 6: Combined ticket counts with status
SELECT
    combined_ticket.tx_user_mobile_management_id, 
    combined_ticket.employee_name,
    combined_ticket.status,
    ticket_no,
    SUM(CASE WHEN source = 'INAP' THEN inap_ticket_count ELSE 0 END) AS inap_ticket_count,
    SUM(CASE WHEN source = 'SVA' THEN sva_ticket_count ELSE 0 END) AS sva_ticket_count,
    SUM(CASE WHEN source = 'PM' THEN pm_ticket_count ELSE 0 END) AS pm_ticket_count,
    SUM(CASE WHEN source = 'FNA' THEN fna_ticket_count ELSE 0 END) AS fna_ticket_count,
    SUM(ticket_count) AS total_ticket_count
FROM (
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name,
        inap.status, 
        'INAP' AS source,
        string_agg(inap.ticket_no, ', ') as inap_ticket_no,
        COUNT(*) AS inap_ticket_count,
        0 AS sva_ticket_count,
        0 AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.tx_ticket_terr_opr inap
    ON tumm.tx_user_mobile_management_id::varchar = inap.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name, inap.status
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name, 
        sva.status,
        'SVA' AS source,
        string_agg(sva.ticket_no, ', ') as sva_ticket_no,
        0 AS inap_ticket_count,
        COUNT(*) AS sva_ticket_count,
        0 AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm 
    INNER JOIN wfm_schema.tx_cmsite_header sva
    ON tumm.tx_user_mobile_management_id::varchar = sva.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name, sva.status
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name,
        pm.status,
        'PM' AS source,
        string_agg(pm.ticket_no, ', ') as pm_ticket_no,
        0 AS inap_ticket_count,
        0 AS sva_ticket_count,
        COUNT(*) AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.tx_pm_ticket_site pm
    ON tumm.tx_user_mobile_management_id::varchar = pm.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name, pm.status
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name,
        fna.status,
        'FNA' AS source,
        string_agg(fna.ticket_no, ', ') as fna_ticket_no,
        0 AS inap_ticket_count,
        0 AS sva_ticket_count,
        0 AS pm_ticket_count,
        COUNT(*) AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.ticket_technical_support fna 
    ON tumm.tx_user_mobile_management_id::varchar = fna.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, tumm.employee_name, fna.status
) AS combined_ticket
GROUP BY combined_ticket.tx_user_mobile_management_id, combined_ticket.employee_name, combined_ticket.status;

-- Query 7: Combined ticket counts with additional timestamps
SELECT
    combined_ticket.tx_user_mobile_management_id, 
    combined_ticket.employee_name,
    combined_ticket.created_at,
    combined_ticket.take_over_at,
    combined_ticket.checkin_at,
    combined_ticket.status,
    MAX(CASE WHEN source = 'INAP' THEN ticket_no ELSE NULL END) AS inap_ticket_no,
    MAX(CASE WHEN source = 'SVA' THEN ticket_no ELSE NULL END) AS sva_ticket_no,
    MAX(CASE WHEN source = 'PM' THEN ticket_no ELSE NULL END) AS pm_ticket_no,
    MAX(CASE WHEN source = 'FNA' THEN ticket_no ELSE NULL END) AS fna_ticket_no,
    SUM(CASE WHEN source = 'INAP' THEN inap_ticket_count ELSE 0 END) AS inap_ticket_count,
    SUM(CASE WHEN source = 'SVA' THEN sva_ticket_count ELSE 0 END) AS sva_ticket_count,
    SUM(CASE WHEN source = 'PM' THEN pm_ticket_count ELSE 0 END) AS pm_ticket_count,
    SUM(CASE WHEN source = 'FNA' THEN fna_ticket_count ELSE 0 END) AS fna_ticket_count,
    SUM(ticket_count) AS total_ticket_count
FROM (
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name,
        inap.status, 
        'INAP' AS source,
        string_agg(inap.ticket_no, ', ') AS ticket_no,
        inap.created_at :: date,
        inap.take_over_at :: date,
        inap.checkin_at :: date,
        COUNT(*) AS inap_ticket_count,
        0 AS sva_ticket_count,
        0 AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.tx_ticket_terr_opr inap
    ON tumm.tx_user_mobile_management_id::varchar = inap.pic_id
    GROUP BY tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    inap.status, 
    inap.created_at,
	inap.take_over_at,
	inap.checkin_at
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name, 
        sva.status,
        'SVA' AS source,
        string_agg(sva.ticket_no, ', ') AS ticket_no,
        sva.created_at :: date,
        sva.take_over_at :: date,
        sva.checkin_at :: date,
        0 AS inap_ticket_count,
        COUNT(*) AS sva_ticket_count,
        0 AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm 
    INNER JOIN wfm_schema.tx_cmsite_header sva
    ON tumm.tx_user_mobile_management_id::varchar = sva.pic_id
    GROUP BY 
    tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    sva.status, 
    sva.created_at,
    sva.take_over_at,
    sva.checkin_at
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name,
        pm.status,
        'PM' AS source,
        string_agg(pm.pm_ticket_site_id, ', ') AS ticket_no,
        pm.created_at :: date,
        pm.take_over_at :: date,
        pm.checkin_at :: date,
        0 AS inap_ticket_count,
        0 AS sva_ticket_count,
        COUNT(*) AS pm_ticket_count,
        0 AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.tx_pm_ticket_site pm
    ON tumm.tx_user_mobile_management_id::varchar = pm.pic_id
    GROUP BY 
    tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    pm.status, 
    pm.created_at,
    pm.take_over_at,
    pm.checkin_at
    UNION ALL
    SELECT 
        tumm.tx_user_mobile_management_id, 
        tumm.employee_name,
        fna.status,
        'FNA' AS source,
        string_agg(fna.no_ticket, ', ') AS ticket_no,
        fna.created_at :: date,
        fna.take_over_at :: date,
        fna.checkin_at :: date,
        0 AS inap_ticket_count,
        0 AS sva_ticket_count,
        0 AS pm_ticket_count,
        COUNT(*) AS fna_ticket_count,
        COUNT(*) AS ticket_count
    FROM wfm_schema.tx_user_mobile_management tumm
    INNER JOIN wfm_schema.ticket_technical_support fna 
    ON tumm.tx_user_mobile_management_id::varchar = fna.pic_id
    GROUP BY 
    tumm.tx_user_mobile_management_id, 
    tumm.employee_name, 
    fna.status,
    fna.created_at,
    fna.take_over_at,
    fna.checkin_at
) AS combined_ticket
GROUP BY 
combined_ticket.tx_user_mobile_management_id, 
combined_ticket.employee_name, 
combined_ticket.status, 
combined_ticket.created_at,
combined_ticket.take_over_at,
combined_ticket.checkin_at

-- Query 8: ticket status from multiple ticket
SELECT
    UPPER(status_ticket.status)
    -- status_ticket.source
FROM (
    SELECT 
        DISTINCT inap.status, 
        'INAP' AS source
    FROM {tx_ticket_terr_opr} inap
    UNION ALL
    SELECT 
        DISTINCT sva.status,
        'SVA' AS source
    FROM {tx_cmsite_header} sva
    UNION ALL
    SELECT 
        DISTINCT pm.status,
        'PM' AS source
    FROM {tx_pm_ticket_site} pm
    UNION ALL
    SELECT 
        fna.status,
        'FNA' AS source
    FROM {ticket_technical_support} fna 
) AS status_ticket
WHERE status_ticket.status <> '' AND (status_ticket.source = @Category OR @Category = '')
GROUP BY status_ticket.status
ORDER BY status_ticket.status