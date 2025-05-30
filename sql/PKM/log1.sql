SELECT *
FROM wfm_schema.tx_recap_pln tx_recap_pln
INNER JOIN wfm_schema.tx_site tx_site ON tx_recap_pln.site_id = tx_site.site_id
LEFT JOIN wfm_schema.tx_pm_ticket_site tx_pm_ticket_site ON tx_recap_pln.ref_ticket_no = tx_pm_ticket_site.pm_ticket_site_id
LEFT JOIN wfm_schema.tx_pm_site_power_pln tx_pm_site_power_pln ON tx_recap_pln.ref_ticket_no = tx_pm_site_power_pln.tx_pm_ticket_site_id
LEFT JOIN wfm_schema.tm_area tm_area ON tx_site.area_id = tm_area.area_id
LEFT JOIN wfm_schema.tm_regional tm_regional ON tx_site.regional_id = tm_regional.regional_id
LEFT JOIN wfm_schema.tm_nop tm_nop ON tx_site.nop_id = tm_nop.nop_id
LEFT JOIN wfm_schema.tm_cluster tm_cluster ON tx_site.cluster_id = tm_cluster.cluster_id
WHERE 
tx_recap_pln.ticket_no like 'PKM202502%3949'
LIMIT 6;

select * from wfm_schema.tx_recap_pln trp 
where trp.ticket_no like 'PKM202502%3949'

PMS-202406-000000001514


PKM202502-306000000009616	PMS-202401-000000004179
PKM202502-306000000005989	PMS-202402-000000002314
PKM202502-306000000008547	PMS-202406-000000001497
PKM202502-306000000008844	PMS-202404-000000002955
PKM202502-306000000008814	PMS-202404-000000002901
PKM202502-306000000009599	PMS-202411-000000003711
PKM202502-306000000009834	PMS-202407-000000006404
PKM202502-306000000009993	PMS-202410-000000005034