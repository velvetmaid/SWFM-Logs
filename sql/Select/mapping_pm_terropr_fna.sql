select a.rk_name as label, concat(a.start_date, ' - ', a.end_date) as period, b.area_name, b.regional_name,
b.nop_name, b.cluster_name, b.pm_ticket_site_id as ticket_no, b.tx_site_id as site_id, b.site_name, 
b.class_site_name, b.type_site_name, b.status,
b.pic_name, b.notes,
string_agg(regexp_replace(concat(d.ticket_no, ' - ', d.notes, ' (', to_char(d.created_at, 'YYYY-MM-DD'), ')'), '[;"]', '', 'g'), ', ') AS terr_opr_detail_ticket,
string_agg(replace(replace(concat(d.ticket_no, ' - ', d.notes, ' (', to_char(d.created_at, 'YYYY-MM-DD'), ')'), ';', ':'), '"', ''), ', ') AS terr_opr_detail_ticket,
string_agg(replace(replace(concat(c.no_ticket, ' - ', c.note, ' (', to_char(c.created_at, 'YYYY-MM-DD'), ')'), ';', ':'), '"', ''), ', ') AS fna_detail_ticket
from wfm_schema.tx_pm_schedule_plan a
inner join wfm_schema.tx_pm_ticket_site b
on a.pm_schedule_plan_id = b.pm_schedule_plan_id
left join wfm_schema.ticket_technical_support c
on b.tx_site_id = c.site_id
left join wfm_schema.tx_ticket_terr_opr d
on b.tx_site_id = d.site_id
where extract(year from a.start_date) = 2024 and b.notes <> ''
group by a.pm_schedule_plan_id, b.tx_site_id, b.pm_ticket_site_id
order by b.tx_site_id, a.start_date desc
limit 5;

-- 
-- 

select a.rk_name as label, concat(a.start_date, ' - ', a.end_date) as period, b.area_name, b.regional_name,
b.nop_name, b.cluster_name, b.pm_ticket_site_id as ticket_no, b.tx_site_id as site_id, b.site_name, b.class_site_name, b.type_site_name, b.status,
b.pic_name, b.notes  from wfm_schema.tx_pm_schedule_plan a
inner join wfm_schema.tx_pm_ticket_site b
on a.pm_schedule_plan_id = b.pm_schedule_plan_id
where extract(year from a.start_date) = 2024 and b.notes <> ''
order by b.tx_site_id, a.start_date desc;