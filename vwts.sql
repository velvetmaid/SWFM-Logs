CREATE
OR REPLACE VIEW wfm_schema.vw_ticket_technical_support AS
SELECT
    ticket_technical_support.ticket_technical_support_id,
    ticket_technical_support.category,
    ticket_technical_support.ticket_subject,
    ticket_technical_support.sla_start,
    ticket_technical_support.sla_end,
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
    ticket_technical_support.pic_id,
    ticket_technical_support.pic_name,
    ticket_technical_support.description,
    ticket_technical_support.name,
    tm_area.area_id AS tm_area_id,
    tm_area.area_name AS tm_area_name,
    tm_class_site.class_site_id AS tm_class_site_id,
    tm_class_site.class_site_name AS tm_class_site_name,
    tm_cluster.cluster_id AS tm_cluster_id,
    tm_cluster.ns_id AS tm_cluster_ns_id,
    tm_cluster.cluster_name AS tm_cluster_name,
    tm_cluster.alias AS tm_cluster_alias,
    tm_network_service.network_service_id AS tm_network_service_id,
    tm_network_service.network_service_name AS tm_network_service_name,
    tm_network_service.regional_id AS tm_network_service_regional_id,
    tm_regional.regional_id AS tm_regional_id,
    tm_regional.regional_name AS tm_regional_name,
    tm_regional.area_id AS tm_regional_area_id,
    tx_site.site_id AS tx_site_site_id,
    tx_site.cluster_id AS tx_site_cluster_id,
    tx_site.type_site_id AS tx_site_type_site_id,
    tx_site.type_site_name AS tx_site_type_site_name,
    tx_site.class_site_id AS tx_site_class_site_id,
    tx_site.class_site_name AS tx_site_class_site_name,
    tx_site.site_name AS tx_site_site_name,
    tx_user_management.tx_user_management_id,
    tx_user_management.username AS tx_user_management_username,
    tx_user_management.email AS tx_user_management_email,
    tx_user_management.role_id AS tx_user_management_role_id,
    tx_user_management.ref_user_id AS tx_user_management_ref_user_id,
    tx_user_management.employee_name AS tx_user_management_employee_name,
    string_agg(DISTINCT tm_user_role.name, ', ') AS tm_user_role_name
FROM
    (
        (
            (
                (
                    (
                        (
                            (
                                (
                                    (
                                        wfm_schema.ticket_technical_support ticket_technical_support
                                        LEFT JOIN wfm_schema.tx_site tx_site ON (
                                            ticket_technical_support.site_id = tx_site.site_id
                                        )
                                    )
                                    LEFT JOIN wfm_schema.tx_user_management tx_user_management ON (
                                        ticket_technical_support.created_by = cast(tx_user_management.ref_user_id as bigint)
                                    )
                                )
                                INNER JOIN wfm_schema.tm_class_site tm_class_site ON (
                                    tx_site.class_site_id = tm_class_site.class_site_id
                                )
                            )
                            INNER JOIN wfm_schema.tm_cluster tm_cluster ON (
                                tx_site.cluster_id = tm_cluster.cluster_id
                            )
                        )
                        INNER JOIN wfm_schema.tm_network_service tm_network_service ON (
                            tm_cluster.ns_id = tm_network_service.network_service_id
                        )
                    )
                    INNER JOIN wfm_schema.tm_regional tm_regional ON (
                        tm_network_service.regional_id = tm_regional.regional_id
                    )
                )
                INNER JOIN wfm_schema.tm_area tm_area ON (
                    tm_regional.area_id = tm_area.area_id
                )
            )
            INNER JOIN wfm_schema.tx_user_role tx_user_role ON (
                ticket_technical_support.created_by = tx_user_role.ref_user_id
            )
        )
        INNER JOIN wfm_schema.tm_user_role tm_user_role ON (
            tx_user_role.role_id = tm_user_role.tm_user_role_id
        )
    )
GROUP BY
    ticket_technical_support.ticket_technical_support_id,
    ticket_technical_support.category,
    ticket_technical_support.ticket_subject,
    ticket_technical_support.sla_start,
    ticket_technical_support.sla_end,
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
    ticket_technical_support.pic_id,
    ticket_technical_support.pic_name,
    ticket_technical_support.description,
    ticket_technical_support.name,
    tm_area.area_id,
    tm_area.area_name,
    tm_class_site.class_site_id,
    tm_class_site.class_site_name,
    tm_cluster.cluster_id,
    tm_cluster.ns_id,
    tm_cluster.cluster_name,
    tm_cluster.alias,
    tm_network_service.network_service_id,
    tm_network_service.network_service_name,
    tm_network_service.regional_id,
    tm_regional.regional_id,
    tm_regional.regional_name,
    tm_regional.area_id,
    tx_site.site_id,
    tx_site.cluster_id,
    tx_site.type_site_id,
    tx_site.type_site_name,
    tx_site.class_site_id,
    tx_site.class_site_name,
    tx_site.site_name,
    tx_user_management.tx_user_management_id,
    tx_user_management.username,
    tx_user_management.email,
    tx_user_management.role_id,
    tx_user_management.ref_user_id,
    tx_user_management.employee_name
ORDER BY
    ticket_technical_support.ticket_technical_support_id DESC;

-- NEW
CREATE
OR REPLACE VIEW wfm_schema.vw_ticket_technical_support AS
SELECT
    ticket_technical_support.*,
    string_agg(DISTINCT tm_user_role.name, ', ') AS tm_user_role_name
FROM
    wfm_schema.ticket_technical_support
    INNER JOIN wfm_schema.tx_user_role tx_user_role ON ticket_technical_support.created_by = tx_user_role.ref_user_id
    INNER JOIN wfm_schema.tm_user_role tm_user_role ON tx_user_role.role_id = tm_user_role.tm_user_role_id
GROUP BY
    ticket_technical_support.ticket_technical_support_id;

-- ?
SELECT
    tts.ticket_technical_support_id,
    tts.category,
    tts.ticket_subject,
    tts.sla_start,
    tts.sla_end,
    tts.created_by,
    tts.created_at,
    tts.modified_by,
    tts.modified_at,
    tts.no_ticket,
    tts.activity_name,
    tts.role_name,
    tts.respone_time,
    tts.submit_time,
    tts.user_submitter,
    tts.approve_time,
    tts.user_approve,
    tts.note,
    tts.review,
    tts.status,
    tts.pic_id,
    tts.pic_name,
    tts.description,
    tts.name,
    string_agg(DISTINCT tm_user_role.name, ', ') AS tm_user_role_name
FROM
    wfm_schema.ticket_technical_support tts
    LEFT JOIN wfm_schema.tx_user_role tx_user_role ON tts.created_by = tx_user_role.ref_user_id
    LEFT JOIN wfm_schema.tm_user_role tm_user_role ON tx_user_role.role_id = tm_user_role.tm_user_role_id
GROUP BY
    tts.ticket_technical_support_id,
    tts.category,
    tts.ticket_subject,
    tts.sla_start,
    tts.sla_end,
    tts.created_by,
    tts.created_at,
    tts.modified_by,
    tts.modified_at,
    tts.no_ticket,
    tts.activity_name,
    tts.role_name,
    tts.respone_time,
    tts.submit_time,
    tts.user_submitter,
    tts.approve_time,
    tts.user_approve,
    tts.note,
    tts.review,
    tts.status,
    tts.pic_id,
    tts.pic_name,
    tts.description,
    tts.name