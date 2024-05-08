-- wfm_schema.vw_technical_support_user_location source
CREATE
OR REPLACE VIEW wfm_schema.vw_technical_support_user_location AS
SELECT
    sub.ticket_technical_support_id,
    sub.site_id,
    sub.cluster_area,
    sub.category,
    sub.ticket_subject,
    sub.job_details,
    sub.job_targets,
    sub.sla_start,
    sub.sla_end,
    sub.sla_range,
    sub.created_by,
    sub.created_at,
    sub.modified_by,
    sub.modified_at,
    sub.no_ticket,
    sub.activity_name,
    sub.role_name,
    sub.respone_time,
    sub.submit_time,
    sub.user_submitter,
    sub.approve_time,
    sub.user_approve,
    sub.note,
    sub.review,
    sub.status,
    sub.rootcause1,
    sub.rootcause2,
    sub.rootcause3,
    sub.rootcause_remark,
    sub.resolution_action,
    sub.pic_id,
    sub.pic_name,
    sub.description,
    sub.name,
    sub.issue_category,
    sub.is_asset_change,
    sub.take_over_at,
    sub.checkin_at,
    sub.employee_name,
    sub.phone_number,
    sub.is_active,
    sub.is_delete,
    sub.deviceudid,
    sub.latitude,
    sub.longitude,
    sub.currenttime,
    sub.sort_currenttime,
    agg.list_technical_support_ticket_no
FROM
    (
        SELECT
            a.ticket_technical_support_id,
            a.site_id,
            a.cluster_area,
            a.category,
            a.ticket_subject,
            a.job_details,
            a.job_targets,
            a.sla_start,
            a.sla_end,
            a.sla_range,
            a.created_by,
            a.created_at,
            a.modified_by,
            a.modified_at,
            a.no_ticket,
            a.activity_name,
            a.role_name,
            a.respone_time,
            a.submit_time,
            a.user_submitter,
            a.approve_time,
            a.user_approve,
            a.note,
            a.review,
            a.status,
            a.rootcause1,
            a.rootcause2,
            a.rootcause3,
            a.rootcause_remark,
            a.resolution_action,
            a.pic_id,
            a.pic_name,
            a.description,
            a.name,
            a.issue_category,
            a.is_asset_change,
            a.take_over_at,
            a.checkin_at,
            b.employee_name,
            b.phone_number,
            b.is_active,
            b.is_delete,
            c.deviceudid,
            c.latitude,
            c.longitude,
            c.currenttime,
            row_number() OVER (
                PARTITION BY c.deviceudid
                ORDER BY
                    c.currenttime DESC
            ) AS sort_currenttime
        FROM
            wfm_schema.ticket_technical_support a
            JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id :: text = b.tx_user_mobile_management_id :: character varying :: text
            JOIN wfm_schema.tx_location_device c ON b.deviceid :: text = c.deviceudid :: text
        WHERE
            a.status :: text = 'IN PROGRESS' :: text
            AND b.is_active = true
            AND b.is_delete = false
    ) sub
    LEFT JOIN (
        SELECT
            b.deviceid,
            string_agg(DISTINCT a.no_ticket :: text, ', ' :: text) AS list_technical_support_ticket_no
        FROM
            wfm_schema.ticket_technical_support a
            JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id :: text = b.tx_user_mobile_management_id :: character varying :: text
        WHERE
            a.status :: text = 'IN PROGRESS' :: text
        GROUP BY
            b.deviceid
    ) agg ON sub.deviceudid :: text = agg.deviceid :: text
WHERE
    sub.sort_currenttime = 1;

-- 
-- 
-- 
-- wfm_schema.vw_ticket_technical_support source
-- wfm_schema.vw_ticket_technical_support source
CREATE
OR REPLACE VIEW wfm_schema.vw_ticket_technical_support AS
SELECT
    ticket_technical_support.ticket_technical_support_id,
    ticket_technical_support.site_id,
    ticket_technical_support.cluster_area,
    ticket_technical_support.category,
    ticket_technical_support.ticket_subject,
    ticket_technical_support.job_details,
    ticket_technical_support.job_targets,
    ticket_technical_support.sla_start,
    ticket_technical_support.sla_end,
    ticket_technical_support.sla_range,
    ticket_technical_support.created_by,
    ticket_technical_support.created_at,
    ticket_technical_support.modified_by,
    ticket_technical_support.modified_at,
    ticket_technical_support.no_ticket,
    ticket_technical_support.activity_name,
    ticket_technical_support.role_name,
    ticket_technical_support.respone_time,
    ticket_technical_support.submit_time,
    ticket_technical_support.user_submitter,
    ticket_technical_support.approve_time,
    ticket_technical_support.user_approve,
    ticket_technical_support.note,
    ticket_technical_support.review,
    ticket_technical_support.status,
    ticket_technical_support.rootcause1,
    ticket_technical_support.rootcause2,
    ticket_technical_support.rootcause3,
    ticket_technical_support.rootcause_remark,
    ticket_technical_support.resolution_action,
    ticket_technical_support.pic_id,
    ticket_technical_support.pic_name,
    ticket_technical_support.description,
    ticket_technical_support.name,
    ticket_technical_support.issue_category,
    ticket_technical_support.is_asset_change,
    ticket_technical_support.take_over_at,
    ticket_technical_support.checkin_at,
    string_agg(DISTINCT tm_user_role.name :: text, ', ' :: text) AS tm_user_role_name
FROM
    wfm_schema.ticket_technical_support
    JOIN wfm_schema.tx_user_role tx_user_role ON ticket_technical_support.created_by = tx_user_role.ref_user_id
    JOIN wfm_schema.tm_user_role tm_user_role ON tx_user_role.role_id = tm_user_role.tm_user_role_id
GROUP BY
    ticket_technical_support.ticket_technical_support_id;