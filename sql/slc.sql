INSERT INTO wfm_schema.tx_user_mobile_management (tx_user_management_id, username, email, user_password, is_organic, ref_user_id_before, partner_id, description, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete, employee_name, area_id, regional_id, ns_id, cluster_id, deviceid, rtp)
SELECT tx_user_management_id, username, email, 'hashpassword', BOOLEAN, ref_user_id, partner_id, description, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete, employee_name, area_id, regional_id, ns_id, cluster_id, deviceid, rtp
FROM wfm_schema.tx_user_management 
INNER JOIN wfm_schema.tx_user_role ON tx_user_role.role_id = tx_user_management.role_id WHERE tx_user_role.role_id = 17 AND tx_user_role.role_id = 13;

INSERT INTO wfm_schema.mapping_user_mobile_role (tx_user_mobile_management_id, role_id, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete)
SELECT 000, role_id, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete
FROM wfm_schema.tx_user_role 
INNER JOIN wfm_schema.tx_user_management ON tx_user_management.ref_user_id = tx_user_role.ref_user_id WHERE role_id = 17 AND tx_user_role.role_id = 13;


-- New 

INSERT INTO wfm_schema.tx_user_mobile_management (
tx_user_management_id, 
username, 
email, 
user_password, 
is_organic,
ref_user_id,  
partner_id, 
description, 
created_by, 
created_at, 
modified_by, 
modified_at, 
deleted_by, 
deleted_at, 
is_active, 
is_delete, 
employee_name, 
area_id, 
regional_id, 
ns_id,
cluster_id, 
deviceid, 
rtp,
ref_user_id_before)
SELECT 'id user baru regional', a.username, a.email, crypt('ini password', gen_salt('sha512')), a.is_organic, 'ISI ref user id yang baru sesuai user regional', a.partner_id, a.description, a.created_by, a.created_at, a.modified_by, a.modified_at, a.deleted_by, a.deleted_at, a.is_active, a.is_delete, a.employee_name, a.area_id, a.regional_id, a.ns_id, a.cluster_id, a.deviceid, a.rtp,a.ref_user_id
FROM wfm_schema.tx_user_management a INNER JOIN wfm_schema.tx_user_role b ON a.ref_user_id = b.ref_user_id
WHERE a.is_active=true and a.is_delete=false and a.regional_id='R01' and 
(b.role_id = 17 or b.role_id = 13) group by a.tx_user_management_id;

INSERT INTO wfm_schema.mapping_user_mobile_role (
tx_user_mobile_management_id, 
role_id, 
created_by, 
created_at, 
modified_by, 
modified_at, 
deleted_by, 
deleted_at, 
is_active, 
is_delete)
SELECT b.tx_user_mobile_management_id, a.role_id, a.created_by, a.created_at, a.modified_by, a.modified_at, a.deleted_by, a.deleted_at, a.is_active, a.is_delete
FROM wfm_schema.tx_user_role a INNER JOIN wfm_schema.tx_user_mobile_management b 
ON a.ref_user_id = b.ref_user_id_before WHERE a.is_active=true and a.is_delete=false and (a.role_id = 17 or a.role_id = 13);

--############## Prog
-- Step 1
INSERT INTO wfm_schema.tx_user_mobile_management (
tx_user_management_id, 
username, 
email, 
user_password, 
is_organic,
ref_user_id,  
partner_id, 
description, 
created_by, 
created_at, 
modified_by, 
modified_at, 
deleted_by, 
deleted_at, 
is_active, 
is_delete, 
employee_name, 
area_id, 
regional_id, 
ns_id,
cluster_id, 
deviceid, 
rtp,
ref_user_id_before)
SELECT 108, a.username, a.email, '$1$I49iYh9JZkch+P4rGlqAgJVuVtcWYh1o70TNWjaWxI8=6359784201C40CA60D474BE0A1C8ACD416159A981D40B6A2E4D8185C304FA88C8735C6F0009AE44181696AE2AAC247A3BA8CE0A14876C71756320728D3091909', a.is_organic, 7054, a.partner_id, a.description, a.created_by, a.created_at, a.modified_by, a.modified_at, a.deleted_by, a.deleted_at, a.is_active, a.is_delete, a.employee_name, a.area_id, a.regional_id, a.ns_id, a.cluster_id, a.deviceid, a.rtp,a.ref_user_id
FROM wfm_schema.tx_user_management a INNER JOIN wfm_schema.tx_user_role b ON a.ref_user_id = b.ref_user_id
WHERE a.is_active=true and a.is_delete=false and a.regional_id='R01' and 
(b.role_id = 17 or b.role_id = 13) group by a.tx_user_management_id;

-- Step 2
INSERT INTO wfm_schema.mapping_user_mobile_role (
tx_user_mobile_management_id, 
role_id, 
created_by, 
created_at, 
modified_by, 
modified_at, 
deleted_by, 
deleted_at, 
is_active, 
is_delete)
SELECT b.tx_user_mobile_management_id, a.role_id, a.created_by, a.created_at, a.modified_by, a.modified_at, a.deleted_by, a.deleted_at, a.is_active, a.is_delete
FROM wfm_schema.tx_user_role a INNER JOIN wfm_schema.tx_user_mobile_management b 
ON a.ref_user_id = b.ref_user_id_before WHERE b.is_active=true and b.is_delete=false and b.regional_id='R01' and (a.role_id = 17 or a.role_id =13);
--############## End Prog


DELETE FROM wfm_admin_schema.tx_eventlog WHERE process_name = 'PMG' AND date_trunc('day', created_on)::date = '2023-12-31'