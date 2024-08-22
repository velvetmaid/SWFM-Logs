-- wfm_schema.vw_user_mobile_absen_location_a source
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_a AS
SELECT
    tx_user_mobile_management.tx_user_mobile_management_id,
    ranked_absen.absentype,
    tx_location_device.currenttime,
    tx_location_device.longitude,
    tx_location_device.latitude,
    tx_location_device.deviceudid,
    tx_location_device.deviceplatform,
    ranked_absen.rank_amount,
    tx_user_mobile_management.username,
    tm_area.area_id,
    tm_area.area_name,
    tm_regional.regional_id,
    tm_regional.regional_name,
    tm_network_service.network_service_id,
    tm_network_service.network_service_name,
    tm_cluster.cluster_id,
    tm_cluster.cluster_name,
    string_agg(DISTINCT tm_user_role.name :: text, ', ' :: text) AS role_name,
    tm_user_role.is_active,
    tm_user_role.is_delete,
    CASE
        WHEN (
            EXISTS (
                SELECT
                    1
                FROM
                    wfm_schema.tx_ticket_terr_opr
                WHERE
                    tx_ticket_terr_opr.pic_id :: text = tx_user_mobile_management.tx_user_mobile_management_id :: character varying :: text
                    AND tx_ticket_terr_opr.status :: text = 'IN PROGRESS' :: text
            )
        ) THEN 'Not Available' :: text
        ELSE 'Available' :: text
    END AS availability_status
FROM
    wfm_schema.tx_user_mobile_management
    JOIN (
        SELECT
            tx_location_device_1.deviceudid :: text AS deviceudid,
            tx_location_device_1.currenttime,
            tx_location_device_1.longitude,
            tx_location_device_1.latitude,
            tx_location_device_1.deviceplatform,
            row_number() OVER (
                PARTITION BY tx_location_device_1.deviceudid
                ORDER BY
                    tx_location_device_1.currenttime DESC
            ) AS row_num
        FROM
            wfm_schema.tx_location_device tx_location_device_1
    ) tx_location_device ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid
    AND tx_location_device.row_num = 1
    JOIN (
        SELECT
            tx_absen.userid,
            tx_absen.absentype,
            rank() OVER (
                PARTITION BY tx_absen.userid
                ORDER BY
                    tx_absen.absentime DESC
            ) AS rank_amount
        FROM
            wfm_schema.tx_absen
    ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid
    LEFT JOIN (
        SELECT
            tm_area_1.area_id,
            tm_area_1.area_name
        FROM
            wfm_schema.tm_area tm_area_1
    ) tm_area ON tx_user_mobile_management.area_id :: text = tm_area.area_id :: text
    LEFT JOIN (
        SELECT
            tm_regional_1.regional_id,
            tm_regional_1.regional_name
        FROM
            wfm_schema.tm_regional tm_regional_1
    ) tm_regional ON tx_user_mobile_management.regional_id :: text = tm_regional.regional_id :: text
    LEFT JOIN (
        SELECT
            tm_network_service_1.network_service_id,
            tm_network_service_1.network_service_name
        FROM
            wfm_schema.tm_network_service tm_network_service_1
    ) tm_network_service ON tx_user_mobile_management.ns_id :: text = tm_network_service.network_service_id :: text
    LEFT JOIN (
        SELECT
            tm_cluster_1.cluster_id,
            tm_cluster_1.cluster_name
        FROM
            wfm_schema.tm_cluster tm_cluster_1
    ) tm_cluster ON tx_user_mobile_management.cluster_id = tm_cluster.cluster_id
    JOIN (
        SELECT
            mapping_user_mobile_role_1.tx_user_mobile_management_id,
            mapping_user_mobile_role_1.role_id
        FROM
            wfm_schema.mapping_user_mobile_role mapping_user_mobile_role_1
    ) mapping_user_mobile_role ON tx_user_mobile_management.tx_user_mobile_management_id = mapping_user_mobile_role.tx_user_mobile_management_id
    JOIN (
        SELECT
            tm_user_role_1.tm_user_role_id,
            tm_user_role_1.name,
            tm_user_role_1.code,
            tm_user_role_1.is_active,
            tm_user_role_1.is_delete
        FROM
            wfm_schema.tm_user_role tm_user_role_1
        WHERE
            tm_user_role_1.code :: text = 'MUSERTS' :: text
            OR tm_user_role_1.code :: text = 'MUSERMBP' :: text
    ) tm_user_role ON mapping_user_mobile_role.role_id = tm_user_role.tm_user_role_id
WHERE
    ranked_absen.rank_amount < 2
GROUP BY
    tx_user_mobile_management.tx_user_mobile_management_id,
    ranked_absen.absentype,
    tx_location_device.currenttime,
    tx_location_device.longitude,
    tx_location_device.latitude,
    tx_location_device.deviceudid,
    tx_location_device.deviceplatform,
    ranked_absen.rank_amount,
    tx_user_mobile_management.username,
    tm_area.area_id,
    tm_area.area_name,
    tm_regional.regional_id,
    tm_regional.regional_name,
    tm_network_service.network_service_id,
    tm_network_service.network_service_name,
    tm_cluster.cluster_id,
    tm_cluster.cluster_name,
    tm_user_role.is_active,
    tm_user_role.is_delete;



    085163636595


    > filter ID PEL MASTER
    - status jenis inquiry, status id pel
    - hide kab, kel, des
    - hide list category site
    - hide action
    - field detail disabled
    - tp name = tower(api)

    > PKM
    - generate status inqiury = POSTPAID dan id pel <> null status_id_pel = active