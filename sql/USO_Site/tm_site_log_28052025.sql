select * from wfm_schema.tx_site ts 

select * from wfm_uso_schema.tm_site ts 

-- Find sites in wfm_schema.tx_site that are not in wfm_uso_schema.tm_site
SELECT *
FROM wfm_schema.tx_site ts
LEFT JOIN wfm_uso_schema.tm_site tsu
  ON ts.site_id = tsu.site_id
WHERE tsu.site_id IS null and ts.is_site_sam;
-- end

-- columns for wfm_schema.tx_site and wfm_uso_schema.tm_site
-- tm_site = select * from wfm_schema.tx_site ts 
site_id, site_name, type_site_id, type_site_name, class_site_id, class_site_name, area_id, regional_id, nop_id, cluster_id,
rtp, site_latitude, site_longitude, land_status, country, province, city, subdistrict, village, site_address, site_owner, type_pengamanan_site,
jumlah_pengaman_site, pengamanan_site_nominal, daratan_kepulauan, enom_fmc, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at,
is_active, is_delete, is_exclude, is_site_sam, is_backup_by_tp
-- end

-- tx_site
site_id, site_name, type_site_id, type_site_name, class_site_id, class_site_name, area_id, regional_id, nop_id, cluster_id,
rtp, site_latitude, site_longitude, land_status, country, province, city, subdistrict, village, site_address, site_owner, type_pengamanan_site,
jumlah_pengaman_site, pengamanan_site_nominal, daratan_kepulauan, enom_fmc, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at,
is_active, is_delete, exclude, is_site_sam, is_backup_by_tp
-- this is the same as tm_site, with 'exclude' instead of 'is_exclude'
select site_id, site_name, type_site_id, type_site_name, class_site_id, class_site_name, area_id, regional_id, nop_id, cluster_id,
rtp, site_latitude, site_longitude, land_status, country, province, city, subdistrict, village, site_address, site_owner, type_pengamanan_site,
jumlah_pengaman_site, pengamanan_site_nominal, daratan_kepulauan, enom_fmc, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at,
is_active, is_delete, exclude, is_site_sam, is_backup_by_tp from wfm_schema.tx_site
-- end

-- Insert new sites from wfm_schema.tx_site into wfm_uso_schema.tm_site
-- This will insert only those sites that are not already present in wfm_uso_schema.tm_site
INSERT INTO wfm_uso_schema.tm_site
SELECT ts.site_id, ts.site_name, ts.type_site_id, ts.type_site_name, ts.class_site_id, ts.class_site_name, ts.area_id, ts.regional_id, ts.nop_id, ts.cluster_id,
ts.rtp, ts.site_latitude, ts.site_longitude, ts.land_status, ts.country, ts.province, ts.city, ts.subdistrict, ts.village, ts.site_address, ts.site_owner, ts.type_pengamanan_site,
ts.jumlah_pengaman_site, ts.pengamanan_site_nominal, ts.daratan_kepulauan, ts.enom_fmc, ts.created_by, ts.created_at, ts.modified_by, ts.modified_at, ts.deleted_by, ts.deleted_at,
ts.is_active, ts.is_delete, ts.exclude, ts.is_site_sam, ts.is_backup_by_tp FROM wfm_schema.tx_site ts
LEFT JOIN wfm_uso_schema.tm_site tsu
  ON ts.site_id = tsu.site_id
WHERE tsu.site_id IS null and ts.is_site_sam;
-- end

-- Get all clusters that have USO sites marked as 'is_site_sam'
select tc.* from wfm_schema.tm_cluster tc
inner join wfm_schema.tx_site ts 
on tc.cluster_id = ts.cluster_id
where ts.is_site_sam
group by tc.cluster_id 
-- end

-- Get all NOPs that have USO sites marked as 'is_site_sam'
select tn.* from wfm_schema.tm_nop tn
inner join wfm_schema.tx_site ts 
on tn.nop_id = ts.nop_id
where ts.is_site_sam
group by tn.nop_id 
-- end

-- Get all regions that have USO sites marked as 'is_site_sam'
select tr.* from wfm_schema.tm_regional tr
inner join wfm_schema.tx_site ts 
on tr.regional_id = ts.regional_id
where ts.is_site_sam
group by tr.regional_id 
-- end

-- Get all areas that have USO sites marked as 'is_site_sam'
select ta.* from wfm_schema.tm_area ta
inner join wfm_schema.tx_site ts 
on ta.area_id = ts.area_id
where ts.is_site_sam
group by ta.area_id 
-- end

-- Raw data for USO sites with territory information
select 
msut.site_id, msut.site_name, msut.longitude as long , msut.latitude as lat , msut.sitearea_to  as cluster_name, msut.nop_name,
msut.id_region_network as region_name , rmsts."class", msut.desa, msut.kecamatan, msut.kabupaten, msut.provinsi, msut.
address from reference.master_site_uso_territory msut
inner join reference.ran_master_site_territory_swfm rmsts
on msut.site_id = rmsts.site_id

-- alter
SELECT 
  {master_site_uso_territory}.[site_id],
  {master_site_uso_territory}.[site_name],
  {master_site_uso_territory}.[longitude] AS long,
  {master_site_uso_territory}.[latitude] AS lat,
  {master_site_uso_territory}.[sitearea_to] AS cluster_name,
  {master_site_uso_territory}.[nop_name],
  {master_site_uso_territory}.[id_region_network] AS region_name,
  {ran_master_site_territory_swfm}.[class],
  {master_site_uso_territory}.[desa],
  {master_site_uso_territory}.[kecamatan],
  {master_site_uso_territory}.[kabupaten],
  {master_site_uso_territory}.[provinsi],
  {master_site_uso_territory}.[address]
FROM 
  {master_site_uso_territory}
INNER JOIN 
  {ran_master_site_territory_swfm}
  ON {master_site_uso_territory}.[site_id] = {ran_master_site_territory_swfm}.[site_id]
-- end




