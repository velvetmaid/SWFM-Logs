INSERT INTO wfm_schema.tx_user_mobile_management (tx_user_management_id, username, email, user_password, is_organic, ref_user_id_before, partner_id, description, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete, employee_name, area_id, regional_id, ns_id, cluster_id, deviceid, rtp)
SELECT tx_user_management_id, username, email, 'hashpassword', BOOLEAN, ref_user_id, partner_id, description, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete, employee_name, area_id, regional_id, ns_id, cluster_id, deviceid, rtp
FROM wfm_schema.tx_user_management INNER JOIN wfm_schema.tx_user_role ON tx_user_role.role_id = tx_user_management.role_id WHERE tx_user_role.role_id = 17 AND tx_user_role.role_id = 13;


INSERT INTO wfm_schema.mapping_user_mobile_role (tx_user_mobile_management_id, role_id, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete)
SELECT 000, role_id, created_by, created_at, modified_by, modified_at, deleted_by, deleted_at, is_active, is_delete
FROM wfm_schema.tx_user_role INNER JOIN wfm_schema.tx_user_management ON tx_user_management.ref_user_id = tx_user_role.ref_user_id WHERE role_id = 17 AND tx_user_role.role_id = 13;