-- 
-- Start step to update the structure of tx_cdc_site_list and tx_cdc_site_log tables
-- 

-- 1. drop unused columns from tx_cdc_site_list
ALTER TABLE wfm_schema.tx_cdc_site_list
DROP COLUMN class_site,
DROP COLUMN latitude,
DROP COLUMN longitude,
DROP COLUMN site_name;

-- 2. drop foreign key constraint tx_cdc_site_log
ALTER TABLE wfm_schema.tx_cdc_site_log
DROP CONSTRAINT tx_cdc_site_log_transaksi_id_fkey;

-- 3. drop primary key constraint tx_cdc_site_list
ALTER TABLE wfm_schema.tx_cdc_site_list DROP CONSTRAINT tx_cdc_site_list_pkey;

-- 4. alter column site_id to varchar(30)
ALTER TABLE wfm_schema.tx_cdc_site_list 
ALTER COLUMN site_id TYPE varchar(30) USING site_id;

-- 5. update site_id with tx_site_id from wfm_admin_schema.icam_ran_master_site
UPDATE wfm_schema.tx_cdc_site_list
SET site_id = tx_site_id;

-- 6. set not null constraint on site_id
ALTER TABLE wfm_schema.tx_cdc_site_list
ALTER COLUMN site_id SET NOT NULL;

-- 7. set primary key constraint on site_id
ALTER TABLE wfm_schema.tx_cdc_site_list
ADD CONSTRAINT tx_cdc_site_list_pkey PRIMARY KEY (site_id);

-- 8. drop tx_site_id column from tx_cdc_site_list
ALTER TABLE wfm_schema.tx_cdc_site_list
DROP COLUMN tx_site_id;

-- 9. add foreign key constraint tx_cdc_site_log
ALTER TABLE wfm_schema.tx_cdc_site_log
ADD CONSTRAINT tx_cdc_site_log_site_id_fkey
FOREIGN KEY (site_id) REFERENCES wfm_schema.tx_cdc_site_list(site_id);

-- 10. drop transaksi_id column from tx_cdc_site_log
ALTER TABLE wfm_schema.tx_cdc_site_log
DROP COLUMN transaksi_id;;

-- 
-- End step to update the structure of tx_cdc_site_list and tx_cdc_site_log tables
-- 

-- CDC site will join to tx_site as master site