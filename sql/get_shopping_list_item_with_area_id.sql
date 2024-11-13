select * from wfm_schema.tm_catalog a 
inner join wfm_schema.tm_regional b 
on a.regional_id = b.regional_id
where b.area_id in ('Area1', 'Area2', 'Area4') and a.is_deleted = false
order by b.area_id asc, a.catalog_name asc