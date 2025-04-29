SELECT asg.nop_id, tn.nop_name, 
concat(asg.month_period, ', ', asg.year_period) as period, 
SUM(asg.total_fee) AS total_fee_sum
FROM wfm_schema.asset_safe_guard asg
INNER JOIN wfm_schema.tm_nop tn ON asg.nop_id = tn.nop_id
where asg.month_period = 1 and asg.year_period = 2025
and asg.is_active and approve_status <> 'REJECTED'
GROUP BY asg.nop_id, asg.month_period, asg.year_period, tn.nop_name
order by tn.nop_name asc;