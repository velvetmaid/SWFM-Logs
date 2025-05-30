-- NOTE: tm_mapping has pk and fk to join to tm_your_master_data, tm_your_master_data only have pk
-- theres tm_mapping source is from wfm_schema.tx_site i guess and tm_your_master_data source from ndm_schema.reference.master_site_territory

-- Start
-- WFM SCHEMA
-- source from ndm 
select distinct id_kec , id_kab from reference.master_site_territory;

CREATE TABLE wfm_schema.tm_mapping_kecamatan_kabupaten (
    kecamatan_id int,
    kabupaten_id int,
    modified_by VARCHAR(100) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)
-- End

-- Start
-- coz in ndm does not have nop id, first save it nop_name from ndm as nop_id
select distinct id_kab, nop_name from reference.master_site_territory mst
-- then update nop_name to be actual nop_id from wfm tm_nop
UPDATE wfm_schema.tm_mapping_kabupaten_nop
SET nop_id = b.nop_id
FROM wfm_schema.tm_nop b
WHERE tm_mapping_kabupaten_nop.nop_id = b.nop_name;
-- thats it
CREATE TABLE wfm_schema.tm_mapping_kabupaten_nop (
	kabupaten_id int4,
	nop_id varchar(30),
	modified_by varchar(100) DEFAULT NULL,
	modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
	is_active boolean DEFAULT TRUE,
	is_delete boolean DEFAULT FALSE
);
-- End

CREATE TABLE wfm_schema.tm_kabupaten (
    kabupaten_id int primary key,
    nop_id VARCHAR(30),
    kabupaten_name VARCHAR(100),
    modified_by VARCHAR(100) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)

CREATE TABLE wfm_schema.tm_kecamatan (
    kecamatan_id int,
    kecamatan_name VARCHAR(100),
    modified_by VARCHAR(100) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)

CREATE TABLE wfm_schema.tm_desa (
    desa_id varchar primary key,
    kecamatan_id int,
    desa_name VARCHAR(100),
    modified_by VARCHAR(100) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)


select * from wfm_schema.tm_nop tn 

begin

commit

UPDATE wfm_schema.tm_mapping_kabupaten_nop
SET nop_id = b.nop_id
FROM wfm_schema.tm_nop b
WHERE tm_mapping_kabupaten_nop.nop_id = b.nop_name;

UPDATE wfm_schema.tx_site
SET 
kabupaten_id = b.kabupaten_id,
kecamatan_id = b.kecamatan_id,
desa_id = b.desa_id
FROM wfm_schema.dummy_tx_site_kkd b
WHERE tx_site.site_id = b.site_id;

select * from wfm_schema.tm_mapping_kabupaten_nop

select * from wfm_schema.tm_kabupaten

-- ADD TABLE MASTER DATA (TM_KABUPATEN, MAPPING_KABUPATEN_NOP, TM_KECAMATAN, MAPPING_KECAMATAN_KABUPATEN, TM_DESA AND DUMMY_TX_SITE_KKD)
-- UPDATE TX_SITE TABLE ADD COLUMN (KABUPATEN_ID, KECAMATAN_ID AND DESA_ID)

-- NDM PRODUCTION
select count(*) from reference.master_site_territory mst

select site_id, id_area, id_region_sales, region_sales, id_kab, kabupaten_lacima, kabupaten, id_kec, kecamatan_lacima, kecamatan, 
id_desa, desa_lacima, desa 
from reference.master_site_territory mst
where kabupaten <> kabupaten_lacima 

select distinct id_area, area, id_branch, branch from reference.master_site_territory mst 

select count(*) from (
select distinct id_kab, nop_name from reference.master_site_territory mst
) as test

-- tm_desa
select distinct id_desa, id_kec, desa from reference.master_site_territory mst

-- tm_kecamatan
select distinct id_kec, kecamatan from reference.master_site_territory

-- tm_kabupaten
select distinct id_kab, kabupaten from reference.master_site_territory mst

-- im feel like dumb shit, idk but its like mapping table coz ndm doesnt save nop id so join that with ndm.mst.nop_name = wfm_schema.tm_nop.nop name to get nop_id
select distinct id_kab, nop_name, kabupaten from reference.master_site_territory mst


SELECT city, COUNT(*)
from reference.master_site_territory
GROUP BY city
HAVING COUNT(*) > 1;

ALTER TABLE wfm_schema. 
DROP COLUMN created_by, 
DROP COLUMN created_at, 
DROP COLUMN deleted_by, 
DROP COLUMN deleted_at, 
ALTER COLUMN modified_by TYPE VARCHAR(100);
ADD CONSTRAINT tm_mapping_kabupaten_nop_pkey 
PRIMARY KEY (kabupaten_id, nop_id);