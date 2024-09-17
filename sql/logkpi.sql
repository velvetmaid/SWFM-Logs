select * from wfm_schema.tm_kpi_sow_v2 tksv 

select * from wfm_schema.tx_kpi_group_v2 tkgv 
where tm_kpi_group = 4

select * from wfm_schema.tx_recap_pln trp 
where flag_period = 'FM' or flag_period = 'SM'

alter table wfm_schema.tx_recap_pln 
add column month_period int

update wfm_schema.tx_recap_pln 
set month_period = 8
where flag_period = 'SM'

select * from wfm_schema.tm_catalog tc 

alter table wfm_schema.tm_catalog 
alter column is_management_fee set default false

select * from wfm_schema.tx_kpi_detail_v2 tkdv 
where kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tx_kpi_group_v2 tkgv 
where kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tm_kpi_sow_v2 tksv 

select * from wfm_schema.tx_kpi_header_v2 tkhv 
where id = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select from wfm_schema.tx_kpi_header_v2 tkhv 
left join wfm_schema.tx_kpi_type_v2 tktv 
on tktv.kpi_header = tkhv.id 
left join wfm_schema.tx_kpi_detail_v2 tkdv
on tkdv.tx_kpi_type = tktv.id
where tkdv.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tx_kpi_detail_v2 tkdv 
where kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tx_kpi_detail_v2 tkdv 

select * from wfm_schema.tx_kpi_header_v2 tkhv 
where id = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tx_kpi_detail_listdata_v2 tkdlv 

select * from wfm_schema.tx_recap_pln trp 
inner join wfm_schema.tx_site ts
on trp.site_id = ts.site_id 
where ts.nop_id = 'NOP1'

select * from wfm_schema.tx_kpi_detail_v2 tkdv 
where kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tx_kpi_detail_listdata_v2 tkdlv 

select * from wfm_schema.tx_kpi_detail_v2 tkdv 
left join wfm_schema.tx_kpi_detail_listdata_v2 tkdlv 
on tkdv.id = tkdlv.tx_kpi_detail 
where tkdv.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'

select * from wfm_schema.tx_recap_pln trp 