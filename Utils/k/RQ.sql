SELECT a.id,
    a.tx_kpi_type,
    a.kpi_header,
    a.modified_at,
    a.modified_by,
    a.reward_no,
    a.created_by,
    a.createtd_at,
    a.reward_title,
    a.reward_type_code,
    a.scoring_kpi,
    b.score_category,
    a.month_period,
    a.year_period,
    a.area_id,
    a.area_name,
    a.regional_id,
    a.regional_name,
    a.fullreward_amt,
    a.reward_percentage,
    a.reward_amt,
    a.nop_id,
    a.nop_name,
    d.po_id, 
    d.*
FROM wfm_schema.tx_kpi_reward_v2 a
INNER JOIN wfm_schema.tx_kpi_type_v2 b ON b.id = a.tx_kpi_type
INNER JOIN wfm_schema.tx_kpi_header_v2 c ON c.id = b.kpi_header AND c.id = a.kpi_header
INNER JOIN wfm_schema.tx_po_header_v2 d ON d.contract_id = c.contract_id
WHERE
a.reward_no <> ''
AND b.collaboration_id <>''
AND a.reward_amt > 0