-- 
-- 
-- V1 NEW VW USER LOCATION
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.userid,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
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
          rank() OVER (
            PARTITION BY tx_absen.userid
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
ORDER BY
  tx_location_device.currenttime;

ALTER TABLE
  wfm_schema.vw_user_absen_location OWNER TO postgres;

GRANT ALL ON TABLE wfm_schema.vw_user_absen_location TO postgres;

GRANT
SELECT
  ON TABLE wfm_schema.vw_user_absen_location TO readaccess;

-- 
-- 
-- V2 change ref_user_id with useridmobile
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.useridmobile,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
          tx_absen.absendate,
          tx_absen.absentype,
          tx_absen.useridmobile,
          tx_absen.absentime,
          tx_absen.created_by,
          tx_absen.created_at,
          tx_absen.modified_by,
          tx_absen.modified_at,
          tx_absen.deleted_by,
          tx_absen.deleted_at,
          tx_absen.is_active,
          tx_absen.is_delete,
          rank() OVER (
            PARTITION BY tx_absen.useridmobile
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.useridmobile = tx_user_mobile_management.tx_user_mobile_management_id
ORDER BY
  tx_location_device.currenttime;

ALTER TABLE
  wfm_schema.vw_user_absen_location OWNER TO postgres;

GRANT ALL ON TABLE wfm_schema.vw_user_absen_location TO postgres;

GRANT
SELECT
  ON TABLE wfm_schema.vw_user_absen_location TO readaccess;

-- 
-- 
-- V3 with ticket terr opr
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username,
  tx_ticket_terr_opr.status
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.userid,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
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
          rank() OVER (
            PARTITION BY tx_absen.userid
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
  LEFT JOIN (
    SELECT
      pic_id,
      status
    FROM
      wfm_schema.tx_ticket_terr_opr
  ) tx_ticket_terr_opr ON tx_user_mobile_management.tx_user_mobile_management_id :: varchar = tx_ticket_terr_opr.pic_id :: varchar
ORDER BY
  tx_location_device.currenttime;

-- 
-- 
-- ADD DISTINC
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location AS
SELECT
  DISTINCT tx_user_mobile_management.tx_user_mobile_management_id,
  ranked_absen.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username,
  tx_ticket_terr_opr.status
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.userid,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
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
          rank() OVER (
            PARTITION BY tx_absen.userid
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
  LEFT JOIN (
    SELECT
      pic_id,
      status
    FROM
      wfm_schema.tx_ticket_terr_opr
  ) tx_ticket_terr_opr ON tx_user_mobile_management.tx_user_mobile_management_id :: varchar = tx_ticket_terr_opr.pic_id :: varchar
ORDER BY
  tx_location_device.currenttime;

-- 
-- 
-- 
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username,
  tx_ticket_terr_opr.status
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.userid,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
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
          rank() OVER (
            PARTITION BY tx_absen.userid
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
  LEFT JOIN (
    SELECT
      pic_id,
      status
    FROM
      wfm_schema.tx_ticket_terr_opr
  ) tx_ticket_terr_opr ON tx_user_mobile_management.tx_user_mobile_management_id :: varchar = tx_ticket_terr_opr.pic_id :: varchar
GROUP BY
  tx_user_mobile_management.tx_user_mobile_management_id
  AND
ORDER BY
  tx_location_device.currenttime DESC;

-- 
-- 
-- 
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_new AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username,
  tx_ticket_terr_opr.status
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.userid,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
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
          rank() OVER (
            PARTITION BY tx_absen.userid
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
  LEFT JOIN (
    SELECT
      pic_id,
      status
    FROM
      wfm_schema.tx_ticket_terr_opr
  ) tx_ticket_terr_opr ON tx_user_mobile_management.tx_user_mobile_management_id :: varchar = tx_ticket_terr_opr.pic_id :: varchar
GROUP BY
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username,
  tx_ticket_terr_opr.status
ORDER BY
  tx_location_device.currenttime;

-- 
-- 
-- 
-- new 1
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_new1 AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username
FROM
  wfm_schema.tx_location_device
  JOIN wfm_schema.tx_user_mobile_management ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  JOIN (
    SELECT
      ranked_absen.userid,
      ranked_absen.rank_amount,
      ranked_absen.absentime,
      ranked_absen.absentype
    FROM
      (
        SELECT
          tx_absen.id,
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
          rank() OVER (
            PARTITION BY tx_absen.userid
            ORDER BY
              tx_absen.absentime DESC
          ) AS rank_amount
        FROM
          wfm_schema.tx_absen
      ) ranked_absen
    WHERE
      ranked_absen.rank_amount < 2
  ) ranked ON ranked.userid = tx_user_mobile_management.tx_user_mobile_management_id
GROUP BY
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username
ORDER BY
  tx_location_device.currenttime DESC;

-- NEW
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_new2 AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username
FROM
  wfm_schema.tx_user_mobile_management
  JOIN (
    SELECT
      tx_location_device.deviceudid :: text,
      tx_location_device.currenttime,
      tx_location_device.longitude,
      tx_location_device.latitude,
      tx_location_device.deviceplatform,
      ROW_NUMBER() OVER (
        PARTITION BY tx_location_device.deviceudid :: text
        ORDER BY
          tx_location_device.currenttime DESC
      ) AS row_num
    FROM
      wfm_schema.tx_location_device
  ) ranked ON tx_user_mobile_management.deviceid :: text = ranked.deviceudid :: text
  AND ranked.row_num = 1
  JOIN (
    SELECT
      tx_absen.userid,
      tx_absen.absentype,
      RANK() OVER (
        PARTITION BY tx_absen.userid
        ORDER BY
          tx_absen.absentime DESC
      ) AS rank_amount
    FROM
      wfm_schema.tx_absen
  ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid
WHERE
  ranked_absen.rank_amount < 2;

CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_new2 AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked_absen.absentype,
  ranked_absen.currenttime,
  ranked_absen.longitude,
  ranked_absen.latitude,
  ranked_absen.deviceudid,
  ranked_absen.deviceplatform,
  ranked_absen.rank_amount,
  tx_user_mobile_management.username
FROM
  wfm_schema.tx_user_mobile_management
  JOIN (
    SELECT
      tx_location_device.deviceudid :: text,
      tx_location_device.currenttime,
      tx_location_device.longitude,
      tx_location_device.latitude,
      tx_location_device.deviceplatform,
      ROW_NUMBER() OVER (
        PARTITION BY tx_location_device.deviceudid :: text
        ORDER BY
          tx_location_device.currenttime DESC
      ) AS row_num
    FROM
      wfm_schema.tx_location_device
  ) ranked ON tx_user_mobile_management.deviceid :: text = ranked.deviceudid :: text
  AND ranked.row_num = 1
  JOIN (
    SELECT
      tx_absen.userid,
      tx_absen.absentype,
      RANK() OVER (
        PARTITION BY tx_absen.userid
        ORDER BY
          tx_absen.absentime DESC
      ) AS rank_amount
    FROM
      wfm_schema.tx_absen
  ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid
WHERE
  ranked_absen.rank_amount < 2;

-- 
-- 
-- 
-- 
-- 
-- 
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_new2 AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked_absen.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked.rank_amount,
  tx_user_mobile_management.username
FROM
  wfm_schema.tx_user_mobile_management
  JOIN (
    SELECT
      tx_location_device.deviceudid :: text,
      tx_location_device.currenttime,
      tx_location_device.longitude,
      tx_location_device.latitude,
      tx_location_device.deviceplatform,
      ROW_NUMBER() OVER (
        PARTITION BY tx_location_device.deviceudid :: text
        ORDER BY
          tx_location_device.currenttime DESC
      ) AS row_num
    FROM
      wfm_schema.tx_location_device
  ) AS tx_location_device ON tx_user_mobile_management.deviceid :: text = tx_location_device.deviceudid :: text
  AND tx_location_device.row_num = 1
  JOIN (
    SELECT
      userid,
      absentype,
      RANK() OVER (
        PARTITION BY userid
        ORDER BY
          absentime DESC
      ) AS rank_amount
    FROM
      wfm_schema.tx_absen
  ) AS ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid
WHERE
  ranked_absen.rank_amount < 2;

-- ======================= --
-- NEW MOBILE GPS LOCATION --
-- ======================= --
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absen_location_new2 AS
SELECT
  tx_user_mobile_management.tx_user_mobile_management_id,
  ranked_absen.absentype,
  tx_location_device.currenttime,
  tx_location_device.longitude,
  tx_location_device.latitude,
  tx_location_device.deviceudid,
  tx_location_device.deviceplatform,
  ranked_absen.rank_amount,
  tx_user_mobile_management.username
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
        PARTITION BY (tx_location_device_1.deviceudid :: text)
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
WHERE
  ranked_absen.rank_amount < 2;

-- -------- --
-- NEW 2 GPS LOCATION
-- -------- --
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
  tx_user_mobile_management.area_id,
  tx_user_mobile_management.regional_id,
  tx_user_mobile_management.ns_id,
  tx_user_mobile_management.cluster_id,
  string_agg(tm_user_role.name, ', ') AS role_name
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
  ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid -- ##
  LEFT JOIN (
    SELECT
      tm_area.area_id,
      tm_area.area_name
    FROM
      wfm_schema.tm_area
  ) tm_area ON tx_user_mobile_management.area_id = tm_area.area_id
  LEFT JOIN (
    SELECT
      tm_regional.regional_id,
      tm_regional.regional_name
    FROM
      wfm_schema.tm_regional
  ) tm_regional ON tx_user_mobile_management.regional_id = tm_regional.regional_id
  LEFT JOIN (
    SELECT
      tm_network_service.network_service_id,
      tm_network_service.network_service_name
    FROM
      wfm_schema.tm_network_service
  ) tm_network_service ON tx_user_mobile_management.ns_id = tm_network_service.network_service_id
  LEFT JOIN (
    SELECT
      tm_cluster.cluster_id,
      tm_cluster.cluster_name
    FROM
      wfm_schema.tm_cluster
  ) tm_cluster ON tx_user_mobile_management.cluster_id = tm_cluster.cluster_id
  INNER JOIN (
    SELECT
      mapping_user_mobile_role.tx_user_mobile_management_id,
      mapping_user_mobile_role.role_id
    FROM
      wfm_schema.mapping_user_mobile_role
  ) mapping_user_mobile_role ON tx_user_mobile_management.tx_user_mobile_management_id = mapping_user_mobile_role.tx_user_mobile_management_id
  INNER JOIN (
    SELECT
      tm_user_role.tm_user_role_id,
      tm_user_role.name
    FROM
      wfm_schema.tm_user_role
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
  tx_user_mobile_management.area_id,
  tx_user_mobile_management.regional_id,
  tx_user_mobile_management.ns_id,
  tx_user_mobile_management.cluster_id -- 
  -- 
  -- 
  -- 
  -- 
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
  tx_user_mobile_management.area_id,
  tx_user_mobile_management.regional_id,
  tx_user_mobile_management.ns_id,
  tx_user_mobile_management.cluster_id,
  string_agg(tm_user_role.name, ', ') AS role_name CASE
    tx_ticket_terr_opr
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
      ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid -- ##
      LEFT JOIN (
        SELECT
          tm_area.area_id,
          tm_area.area_name
        FROM
          wfm_schema.tm_area
      ) tm_area ON tx_user_mobile_management.area_id = tm_area.area_id
      LEFT JOIN (
        SELECT
          tm_regional.regional_id,
          tm_regional.regional_name
        FROM
          wfm_schema.tm_regional
      ) tm_regional ON tx_user_mobile_management.regional_id = tm_regional.regional_id
      LEFT JOIN (
        SELECT
          tm_network_service.network_service_id,
          tm_network_service.network_service_name
        FROM
          wfm_schema.tm_network_service
      ) tm_network_service ON tx_user_mobile_management.ns_id = tm_network_service.network_service_id
      LEFT JOIN (
        SELECT
          tm_cluster.cluster_id,
          tm_cluster.cluster_name
        FROM
          wfm_schema.tm_cluster
      ) tm_cluster ON tx_user_mobile_management.cluster_id = tm_cluster.cluster_id
      INNER JOIN (
        SELECT
          mapping_user_mobile_role.tx_user_mobile_management_id,
          mapping_user_mobile_role.role_id
        FROM
          wfm_schema.mapping_user_mobile_role
      ) mapping_user_mobile_role ON tx_user_mobile_management.tx_user_mobile_management_id = mapping_user_mobile_role.tx_user_mobile_management_id
      INNER JOIN (
        SELECT
          tm_user_role.tm_user_role_id,
          tm_user_role.name
        FROM
          wfm_schema.tm_user_role
      ) tm_user_role ON mapping_user_mobile_role.role_id = tm_user_role.tm_user_role_id
      INNER JOIN (
        SELECT
          tx_ticket_terr_opr.pic_id,
          tx_ticket_terr_opr.status
        WHERE
          tx_ticket_terr_opr.status = 'IN PROGRESS'
        FROM
          wfm_schema.tx_ticket_terr_opr
      ) tx_ticket_terr_opr ON tx_user_mobile_management.tx_user_mobile_management_id = tx_ticket_terr_opr.pic_id
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
      tx_user_mobile_management.area_id,
      tx_user_mobile_management.regional_id,
      tx_user_mobile_management.ns_id,
      tx_user_mobile_management.cluster_id CREATE
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
      -- 
      tx_user_mobile_management.area_id,
      tx_user_mobile_management.regional_id,
      tx_user_mobile_management.ns_id,
      tx_user_mobile_management.cluster_id,
      string_agg(DISTINCT tm_user_role.name, ', ') AS role_name,
      CASE
        WHEN EXISTS (
          SELECT
            1
          FROM
            wfm_schema.tx_ticket_terr_opr
          WHERE
            tx_ticket_terr_opr.pic_id = tx_user_mobile_management.tx_user_mobile_management_id :: varchar
            AND tx_ticket_terr_opr.status = 'IN PROGRESS'
        ) THEN 'Available'
        ELSE 'Not Available'
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
      ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid -- ##
      LEFT JOIN (
        SELECT
          tm_area.area_id,
          tm_area.area_name
        FROM
          wfm_schema.tm_area
      ) tm_area ON tx_user_mobile_management.area_id = tm_area.area_id
      LEFT JOIN (
        SELECT
          tm_regional.regional_id,
          tm_regional.regional_name
        FROM
          wfm_schema.tm_regional
      ) tm_regional ON tx_user_mobile_management.regional_id = tm_regional.regional_id
      LEFT JOIN (
        SELECT
          tm_network_service.network_service_id,
          tm_network_service.network_service_name
        FROM
          wfm_schema.tm_network_service
      ) tm_network_service ON tx_user_mobile_management.ns_id = tm_network_service.network_service_id
      LEFT JOIN (
        SELECT
          tm_cluster.cluster_id,
          tm_cluster.cluster_name
        FROM
          wfm_schema.tm_cluster
      ) tm_cluster ON tx_user_mobile_management.cluster_id = tm_cluster.cluster_id
      INNER JOIN (
        SELECT
          mapping_user_mobile_role.tx_user_mobile_management_id,
          mapping_user_mobile_role.role_id
        FROM
          wfm_schema.mapping_user_mobile_role
      ) mapping_user_mobile_role ON tx_user_mobile_management.tx_user_mobile_management_id = mapping_user_mobile_role.tx_user_mobile_management_id
      INNER JOIN (
        SELECT
          tm_user_role.tm_user_role_id,
          tm_user_role.name
        FROM
          wfm_schema.tm_user_role
      ) tm_user_role ON mapping_user_mobile_role.role_id = tm_user_role.tm_user_role_id -- ##
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
      -- 
      tx_user_mobile_management.area_id,
      tx_user_mobile_management.regional_id,
      tx_user_mobile_management.ns_id,
      tx_user_mobile_management.cluster_id -- 
      -- 
      -- 
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
      -- 
      tm_area.area_id,
      tm_area.area_name,
      tm_regional.regional_id,
      tm_regional.regional_name,
      tm_network_service.network_service_id,
      tm_network_service.network_service_name,
      tm_cluster.cluster_id,
      tm_cluster.cluster_name,
      string_agg(DISTINCT tm_user_role.name, ', ') AS role_name,
      tm_user_role.is_active,
      tm_user_role.is_delete,
      CASE
        WHEN EXISTS (
          SELECT
            1
          FROM
            wfm_schema.tx_ticket_terr_opr
          WHERE
            tx_ticket_terr_opr.pic_id = tx_user_mobile_management.tx_user_mobile_management_id :: varchar
            AND tx_ticket_terr_opr.status = 'IN PROGRESS'
        ) THEN 'Not Available'
        ELSE 'Available'
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
      ) ranked_absen ON tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid -- ##
      LEFT JOIN (
        SELECT
          tm_area.area_id,
          tm_area.area_name
        FROM
          wfm_schema.tm_area
      ) tm_area ON tx_user_mobile_management.area_id = tm_area.area_id
      LEFT JOIN (
        SELECT
          tm_regional.regional_id,
          tm_regional.regional_name
        FROM
          wfm_schema.tm_regional
      ) tm_regional ON tx_user_mobile_management.regional_id = tm_regional.regional_id
      LEFT JOIN (
        SELECT
          tm_network_service.network_service_id,
          tm_network_service.network_service_name
        FROM
          wfm_schema.tm_network_service
      ) tm_network_service ON tx_user_mobile_management.ns_id = tm_network_service.network_service_id
      LEFT JOIN (
        SELECT
          tm_cluster.cluster_id,
          tm_cluster.cluster_name
        FROM
          wfm_schema.tm_cluster
      ) tm_cluster ON tx_user_mobile_management.cluster_id = tm_cluster.cluster_id
      INNER JOIN (
        SELECT
          mapping_user_mobile_role.tx_user_mobile_management_id,
          mapping_user_mobile_role.role_id
        FROM
          wfm_schema.mapping_user_mobile_role
      ) mapping_user_mobile_role ON tx_user_mobile_management.tx_user_mobile_management_id = mapping_user_mobile_role.tx_user_mobile_management_id
      INNER JOIN (
        SELECT
          tm_user_role.tm_user_role_id,
          tm_user_role.name,
          tm_user_role.code,
          tm_user_role.is_active,
          tm_user_role.is_delete
        FROM
          wfm_schema.tm_user_role
        WHERE
          tm_user_role.code = 'MUSERTS'
          OR tm_user_role.code = 'MUSERMBP'
      ) tm_user_role ON mapping_user_mobile_role.role_id = tm_user_role.tm_user_role_id -- ##
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
      -- 
      tm_area.area_id,
      tm_area.area_name,
      tm_regional.regional_id,
      tm_regional.regional_name,
      tm_network_service.network_service_id,
      tm_network_service.network_service_name,
      tm_cluster.cluster_id,
      tm_cluster.cluster_name,
      tm_user_role.is_active,
      tm_user_role.is_delete