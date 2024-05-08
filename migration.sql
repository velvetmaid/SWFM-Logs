-- WFM SCHEMA
CREATE TABLE wfm_schema.tm_mapping_kecamatan_kabupaten (
    kecamatan_id int,
    kabupaten_id int,
    created_by VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    modified_by VARCHAR(255) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    deleted_by VARCHAR(255) DEFAULT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)

CREATE TABLE wfm_schema.tm_kabupaten (
    kabupaten_id int primary key,
    nop_id VARCHAR(30),
    kabupaten_name VARCHAR(100),
    created_by VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    modified_by VARCHAR(255) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    deleted_by VARCHAR(255) DEFAULT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)

CREATE TABLE wfm_schema.tm_kecamatan (
    kecamatan_id int,
    kecamatan_name VARCHAR(100),
    created_by VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    modified_by VARCHAR(255) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    deleted_by VARCHAR(255) DEFAULT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    is_active boolean DEFAULT TRUE,
    is_delete boolean DEFAULT FALSE
)

CREATE TABLE wfm_schema.tm_desa (
    desa_id varchar primary key,
    kecamatan_id int,
    desa_name VARCHAR(100),
    created_by VARCHAR(255) DEFAULT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    modified_by VARCHAR(255) DEFAULT NULL,
    modified_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
    deleted_by VARCHAR(255) DEFAULT NULL,
    deleted_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NULL,
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

select distinct id_desa, id_kec, desa from reference.master_site_territory mst

select distinct id_kec, kecamatan from reference.master_site_territory

select distinct id_kab, nop_name, kabupaten from reference.master_site_territory mst

select distinct id_kab, kabupaten from reference.master_site_territory mst

SELECT city, COUNT(*)
from reference.master_site_territory
GROUP BY city
HAVING COUNT(*) > 1;