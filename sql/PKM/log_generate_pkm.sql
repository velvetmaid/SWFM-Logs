select * from wfm_schema.tx_recap_pln trp 
where trp.year_period = 1900 or trp.year_period = 2025

select count(*) from wfm_schema.tx_recap_pln trp
inner join wfm_schema.tx_site ts 
on trp.site_id = ts.site_id 
where trp.year_period = 2025 and ts.nop_id = 'NOP5' and trp.flag_period = 'S1'

select count(*) from wfm_schema.tx_recap_pln trp
where trp.year_period = 2025

select * from wfm_schema.tx_recap_pln trp 
where trp.year_period = 1900 or trp.year_period = 2025 and is_has_schedule 

select * from wfm_schema.tm_power_pln_pelanggan_ipas tpppi 

select * from wfm_schema.tx_recap_pln trp 
where trp.is_has_schedule 

select * from wfm_schema.tx_recap_pln trp 
where trp.date_schedule <> '1900-01-01 00:00:00.000'

select * from wfm_schema.tm_nop tn 
where is_active

SELECT * 
FROM wfm_schema.tm_nop
WHERE is_active
ORDER BY CAST(REGEXP_REPLACE(nop_id, '\D', '', 'g') AS INTEGER);

select * from wfm_schema.tm_power_pln_pelanggan_ipas tpppi 
inner join wfm_schema.tx_site ts 
on tpppi.siteid = ts.site_id 
where tpppi.idpel <> '' or tpppi.idpel is not null or tpppi.idpel <> 'NULL'
and upper(tpppi.billtype) = 'POSTPAID' and tpppi.statusidpel = 'ACTIVE'
and ts.nop_id = 'NOP1'

select count(*) from wfm_schema.tx_recap_pln trp
inner join wfm_schema.tx_site ts 
on trp.site_id = ts.site_id 
where trp.year_period = 2025 and ts.nop_id = 'NOP10' and trp.flag_period = 'S1'

select count(*) from wfm_schema.tm_power_pln_pelanggan_ipas tpppi 
inner join wfm_schema.tx_site ts 
on tpppi.siteid = ts.site_id 
where (tpppi.idpel <> '' or tpppi.idpel is not null or tpppi.idpel <> 'NULL')
and (upper(tpppi.billtype) = 'POSTPAID' and tpppi.statusidpel = 'ACTIVE')
and (ts.nop_id = 'NOP19')