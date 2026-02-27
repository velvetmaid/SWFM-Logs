select 
tx_pm_ticket_genset.tx_site_id,
tx_pm_ticket_genset.regional_id,
tx_pm_ticket_genset.tx_pm_ticket_genset_id,
tx_pm_ticket_genset.status,
tx_ticket_am.tx_ticket_am_no,
tx_ticket_am.ticket_status,
tx_assetheader_staging.asset_barcodenumber,
tx_assetheader_staging.part_name,
tx_assetheader_staging.assetphysicalgroup_name,
tx_pm_ticket_genset.created_at,
tx_eventlog.closed_at,
tx_eventlog.action_name
from  wfm_schema.tx_ticket_am
inner join wfm_schema.tx_pm_ticket_genset
on tx_ticket_am.ref_pm_site_ticket_no=tx_pm_ticket_genset.tx_pm_ticket_genset_id
inner join 
(select DISTINCT
ref_ticket_no,asset_barcodenumber,assetstatus_name,site_id,part_name,assetphysicalgroup_name
from 
ams_schema.tx_assetheader_staging) tx_assetheader_staging
on tx_pm_ticket_genset.tx_pm_ticket_genset_id=tx_assetheader_staging.ref_ticket_no
left join 
(select DISTINCT transaction_id, action_name, closed_at from 
(select transaction_id,
action_name, 
max(created_on) over (partition by transaction_id) as closed_at,
created_on
from wfm_admin_schema.tx_eventlog 
where (action_name='Closed' or action_name='Auto Closed')
) event_log
where closed_at = created_on) tx_eventlog
ON
tx_pm_ticket_genset.tx_pm_ticket_genset_id=tx_eventlog.transaction_id
where tx_assetheader_staging.assetstatus_name<>'' and 
tx_ticket_am.tx_ticket_am_no<>''
and 
tx_assetheader_staging.ref_ticket_no ilike '%PMG-2026%'