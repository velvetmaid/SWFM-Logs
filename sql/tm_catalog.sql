select a.regional_id, a.catalog_name, a.catalog_price, a.measurement_unit, a.catalog_price_other, a.lumpsum_qty, a.remark from wfm_schema.tm_catalog a
inner join wfm_schema.tm_regional b
on a.regional_id = b.regional_id
where b.area_id = 'Area2' and a.is_deleted = false
order by a.regional_id, a.catalog_name