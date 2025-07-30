select tptg.area_name, tptg.regional_name, tptg.nop_name, tsi.scope_item_name as pmg_type,
to_char(schedule_date, 'FMMonth - yyyy'), tptg.tx_pm_ticket_genset_id as nomor_ticket, tptg.status as status_ticket,
CASE
  WHEN 
    lower(tpgs.is_pergantian_oli) = 'ya' AND
    lower(tpgs.is_pergantian_filter_oli) = 'ya' AND
    lower(tpgs.is_pergantian_filter_solar) = 'ya' AND
    lower(tpgs.is_pergantian_filter_udara) = 'ya' AND
    lower(tpgs.is_renew_coolant_radiator) = 'ya' AND
    lower(tpgs.is_renew_all_gasket) = 'ya' AND
    lower(tpgs.is_renew_nozzle) = 'ya' AND
    lower(tpgs.is_renew_fan_belt) = 'ya' AND
    lower(tpgs.is_renew_radiator_hose) = 'ya' AND
    lower(tpgs.is_renew_inlet_valve) = 'ya' AND
    lower(tpgs.is_renew_exhaust_valve) = 'ya'
  THEN 'Semua spare part diganti & ada fotonya'
  ELSE
    'Tidak semua spare part diganti: ' ||
    CASE WHEN lower(tpgs.is_pergantian_oli) != 'ya' THEN 'oli, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_pergantian_filter_oli) != 'ya' THEN 'filter oli, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_pergantian_filter_solar) != 'ya' THEN 'filter solar, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_pergantian_filter_udara) != 'ya' THEN 'filter udara, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_coolant_radiator) != 'ya' THEN 'coolant radiator, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_all_gasket) != 'ya' THEN 'gasket, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_nozzle) != 'ya' THEN 'nozzle, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_fan_belt) != 'ya' THEN 'fan belt, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_radiator_hose) != 'ya' THEN 'radiator hose, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_inlet_valve) != 'ya' THEN 'inlet valve, ' ELSE '' END ||
    CASE WHEN lower(tpgs.is_renew_exhaust_valve) != 'ya' THEN 'exhaust valve ' ELSE '' END
END AS keterangan
from wfm_schema.tx_pm_ticket_genset tptg 
left join wfm_schema.tx_pm_genset_sparepart tpgs 
on tptg.tx_pm_ticket_genset_id = tpgs.tx_pm_ticket_genset_id
left join wfm_schema.tm_scope_item tsi 
on tptg.scope_item_id = tsi.scope_item_id 
where (tptg.status = 'CLOSED' OR tptg.status = 'SUBMITTED') and 
(EXTRACT(MONTH FROM tptg.schedule_date) = 7 and EXTRACT(year FROM tptg.schedule_date) = 2025)
limit 200;

select tptg.area_name, tptg.regional_name, tptg.nop_name, tsi.scope_item_name as pmg_type,
to_char(schedule_date, 'FMMonth - yyyy'), tptg.tx_pm_ticket_genset_id as nomor_ticket, tptg.status as status_ticket,
case
	when lower(tpgs.is_pergantian_oli) = 'ya' and lower(tpgs.is_pergantian_filter_oli) = 'ya'
	and lower(tpgs.is_pergantian_filter_solar) = 'ya' and lower(tpgs.is_pergantian_filter_udara) = 'ya'
	and lower(tpgs.is_renew_coolant_radiator) = 'ya' and lower(tpgs.is_renew_all_gasket) = 'ya'
	and lower(tpgs.is_renew_nozzle) = 'ya' and lower(tpgs.is_renew_fan_belt) = 'ya'
	and lower(tpgs.is_renew_radiator_hose) = 'ya' and lower(tpgs.is_renew_inlet_valve) = 'ya'
	and lower(tpgs.is_renew_exhaust_valve) = 'ya'
	then 'Ada foto penggantian spare part'
	else 'Tidak ada foto penggantian spare part'
end as keterangan
from wfm_schema.tx_pm_ticket_genset tptg 
left join wfm_schema.tx_pm_genset_sparepart tpgs 
on tptg.tx_pm_ticket_genset_id = tpgs.tx_pm_ticket_genset_id
left join wfm_schema.tm_scope_item tsi 
on tptg.scope_item_id = tsi.scope_item_id 
where (tptg.status = 'CLOSED' OR tptg.status = 'SUBMITTED') and 
(EXTRACT(MONTH FROM tptg.schedule_date) = 7 and EXTRACT(year FROM tptg.schedule_date) = 2025)
limit 20;


select tptg.area_name, tptg.regional_name, tptg.nop_name, tsi.scope_item_name as pmg_type,
to_char(schedule_date, 'FMMonth - yyyy'), tptg.tx_pm_ticket_genset_id as nomor_ticket, tptg.status as status_ticket,
case
	when trim(tpgs.foto_pergantian_oli_sebelum_sftp_id) = '' and trim(tpgs.foto_pergantian_oli_sesudah_sftp_id) = ''
	and trim(tpgs.foto_pergantian_filter_oli_sebelum_sftp_id) = '' and trim(tpgs.foto_pergantian_filter_oli_sesudah_sftp_id) = ''
	and trim(tpgs.foto_pergantian_filter_solar_sebelum_sftp_id) = '' and trim(tpgs.foto_pergantian_filter_solar_sesudah_sftp_id) = ''
	and trim(tpgs.foto_pergantian_filter_udara_sebelum_sftp_id) = '' and trim(tpgs.foto_pergantian_filter_udara_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_coolant_radiator_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_coolant_radiator_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_all_gasket_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_all_gasket_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_nozzle_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_nozzle_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_fan_belt_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_fan_belt_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_radiator_hose_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_radiator_hose_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_inlet_valve_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_inlet_valve_sesudah_sftp_id) = ''
	and trim(tpgs.foto_renew_exhaust_valve_sebelum_sftp_id) = '' and trim(tpgs.foto_renew_exhaust_valve_sesudah_sftp_id) = ''
	then 'Tidak ada foto penggantian spare part'
	else 'Ada foto penggantian spare part'
end as keterangan
from wfm_schema.tx_pm_ticket_genset tptg 
left join wfm_schema.tx_pm_genset_sparepart tpgs 
on tptg.tx_pm_ticket_genset_id = tpgs.tx_pm_ticket_genset_id
left join wfm_schema.tm_scope_item tsi 
on tptg.scope_item_id = tsi.scope_item_id 
where (tptg.status = 'CLOSED' OR tptg.status = 'SUBMITTED') and 
(EXTRACT(MONTH FROM tptg.schedule_date) = 7 and EXTRACT(year FROM tptg.schedule_date) = 2025)
limit 20;

select tptg.area_name, tptg.regional_name, tptg.nop_name, tsi.scope_item_name as pmg_type,
to_char(schedule_date, 'FMMonth - yyyy') as bulan, tptg.tx_pm_ticket_genset_id as nomor_ticket, tptg.status as status_ticket,
CASE 
  WHEN
    trim(coalesce(tpgs.foto_pergantian_oli_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_pergantian_oli_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_pergantian_filter_oli_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_pergantian_filter_oli_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_pergantian_filter_solar_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_pergantian_filter_solar_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_pergantian_filter_udara_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_pergantian_filter_udara_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_coolant_radiator_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_coolant_radiator_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_all_gasket_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_all_gasket_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_nozzle_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_nozzle_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_fan_belt_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_fan_belt_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_radiator_hose_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_radiator_hose_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_inlet_valve_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_inlet_valve_sesudah_sftp_id, '')) = '' AND
    trim(coalesce(tpgs.foto_renew_exhaust_valve_sebelum_sftp_id, '')) = '' AND trim(coalesce(tpgs.foto_renew_exhaust_valve_sesudah_sftp_id, '')) = ''
  THEN 'Tidak ada foto penggantian spare part'
  WHEN
    trim(coalesce(tpgs.foto_pergantian_oli_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_pergantian_oli_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_pergantian_filter_oli_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_pergantian_filter_oli_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_pergantian_filter_solar_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_pergantian_filter_solar_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_pergantian_filter_udara_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_pergantian_filter_udara_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_coolant_radiator_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_coolant_radiator_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_all_gasket_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_all_gasket_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_nozzle_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_nozzle_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_fan_belt_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_fan_belt_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_radiator_hose_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_radiator_hose_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_inlet_valve_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_inlet_valve_sesudah_sftp_id, '')) != '' OR
    trim(coalesce(tpgs.foto_renew_exhaust_valve_sebelum_sftp_id, '')) != '' OR trim(coalesce(tpgs.foto_renew_exhaust_valve_sesudah_sftp_id, '')) != ''
  THEN 'Ada beberapa foto penggantian spare part'
END AS keterangan,
TRIM(BOTH ', ' FROM
  CASE WHEN trim(tpgs.foto_pergantian_oli_sebelum_sftp_id) != '' OR trim(tpgs.foto_pergantian_oli_sesudah_sftp_id) != '' THEN 'oli, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_pergantian_filter_oli_sebelum_sftp_id) != '' OR trim(tpgs.foto_pergantian_filter_oli_sesudah_sftp_id) != '' THEN 'filter oli, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_pergantian_filter_solar_sebelum_sftp_id) != '' OR trim(tpgs.foto_pergantian_filter_solar_sesudah_sftp_id) != '' THEN 'filter solar, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_pergantian_filter_udara_sebelum_sftp_id) != '' OR trim(tpgs.foto_pergantian_filter_udara_sesudah_sftp_id) != '' THEN 'filter udara, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_coolant_radiator_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_coolant_radiator_sesudah_sftp_id) != '' THEN 'coolant radiator, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_all_gasket_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_all_gasket_sesudah_sftp_id) != '' THEN 'gasket, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_nozzle_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_nozzle_sesudah_sftp_id) != '' THEN 'nozzle, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_fan_belt_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_fan_belt_sesudah_sftp_id) != '' THEN 'fan belt, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_radiator_hose_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_radiator_hose_sesudah_sftp_id) != '' THEN 'radiator hose, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_inlet_valve_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_inlet_valve_sesudah_sftp_id) != '' THEN 'inlet valve, ' ELSE '' END ||
  CASE WHEN trim(tpgs.foto_renew_exhaust_valve_sebelum_sftp_id) != '' OR trim(tpgs.foto_renew_exhaust_valve_sesudah_sftp_id) != '' THEN 'exhaust valve, ' ELSE '' END
) AS spare_part_ada_foto
from wfm_schema.tx_pm_ticket_genset tptg 
left join wfm_schema.tx_pm_genset_sparepart tpgs 
on tptg.tx_pm_ticket_genset_id = tpgs.tx_pm_ticket_genset_id
left join wfm_schema.tm_scope_item tsi 
on tptg.scope_item_id = tsi.scope_item_id 
where (tptg.status = 'CLOSED' OR tptg.status = 'SUBMITTED') and 
(EXTRACT(MONTH FROM tptg.schedule_date) = 7 and EXTRACT(year FROM tptg.schedule_date) = 2025;