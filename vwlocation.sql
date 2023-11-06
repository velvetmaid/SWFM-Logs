CREATE OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location
 AS
 SELECT tx_user_mobile_management.tx_user_mobile_management_id,
    ranked.absentype,
    tx_location_device.currenttime,
    tx_location_device.longitude,
    tx_location_device.latitude,
    tx_location_device.deviceudid,
    tx_location_device.deviceplatform,
    ranked.rank_amount,
    tx_user_mobile_management.username
   FROM wfm_schema.tx_location_device
     JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid::text = tx_location_device.deviceudid::text
     JOIN ( SELECT ranked_absen.userid,
            ranked_absen.rank_amount,
            ranked_absen.absentime,
            ranked_absen.absentype
           FROM ( SELECT tx_absen.id,
                    tx_absen.absendate,
                    tx_absen.absentype,
                    tx_absen.userid,
                    tx_absen.absentime,
                    tx_absen.created_by,
                    tx_absen.created_at,
                    tx_absen.modified_by,
                    tx_absen.modified_at,
                    tx_absen.deleted_by,
                    tx_absen.deleted_at,
                    tx_absen.is_active,
                    tx_absen.is_delete,
                    rank() OVER (PARTITION BY tx_absen.userid ORDER BY tx_absen.absentime DESC) AS rank_amount
                   FROM wfm_schema.tx_absen) ranked_absen
          WHERE ranked_absen.rank_amount < 2) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
  ORDER BY tx_location_device.currenttime;

ALTER TABLE wfm_schema.vw_user_absen_location
    OWNER TO postgres;

GRANT ALL ON TABLE wfm_schema.vw_user_absen_location TO postgres;
GRANT SELECT ON TABLE wfm_schema.vw_user_absen_location TO readaccess;