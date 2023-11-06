CREATE OR REPLACE VIEW wfm_schema.vw_absen_user2
 AS
 SELECT a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    c.timeout - b.timein AS workinghour,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
    -- e.status_ticket LEFT JOIN dari table baru tx_ticket_terr_opr column.pic_id = 
   FROM wfm_schema.tx_absen a
     LEFT JOIN ( SELECT tx_absen.absendate,
            tx_absen.userid,
            min(tx_absen.absentime) AS timein
           FROM wfm_schema.tx_absen
          WHERE tx_absen.absentype = true
          GROUP BY tx_absen.userid, tx_absen.absendate) b ON a.userid = b.userid AND a.absendate = b.absendate
     LEFT JOIN ( SELECT tx_absen.absendate,
            tx_absen.userid,
            max(tx_absen.absentime) AS timeout
           FROM wfm_schema.tx_absen
          WHERE tx_absen.absentype = false
          GROUP BY tx_absen.userid, tx_absen.absendate) c ON a.userid = c.userid AND a.absendate = c.absendate
     LEFT JOIN ( SELECT a_1.ref_user_id,
            a_1.username,
            a_1.area_id,
            a_1.regional_id,
            a_1.ns_id,
            b_1.network_service_name,
            a_1.cluster_id,
            c_1.cluster_name,
            a_1.rtp
           FROM wfm_schema.tx_user_management a_1
             LEFT JOIN wfm_schema.tm_network_service b_1 ON a_1.ns_id::text = b_1.network_service_id::text
             LEFT JOIN wfm_schema.tm_cluster c_1 ON a_1.cluster_id = c_1.cluster_id
          WHERE a_1.is_active = true) d ON a.userid = d.ref_user_id
  GROUP BY a.absendate, a.userid, b.timein, c.timeout, d.username, d.area_id, d.regional_id, d.network_service_name, d.cluster_name, d.rtp
  ORDER BY a.absendate DESC;

ALTER TABLE wfm_schema.vw_absen_user2
    OWNER TO postgres;

-- 
-- 
-- 

    CREATE OR REPLACE VIEW wfm_schema.vw_absen_user
    AS
    SELECT a.absendate,
        a.userid,
        b.timein,
        c.timeout,
        c.timeout - b.timein AS workinghour,
        d.username,
        d.area_id,
        d.regional_id,
        d.network_service_name,
        d.cluster_name,
        d.rtp,
        e.status_ticket
        -- e.status_ticket LEFT JOIN dari table baru tx_ticket_terr_opr.pic_id = tx_user_mobile_management.tx_user_mobile_management_id
    FROM wfm_schema.tx_absen a
        LEFT JOIN ( SELECT tx_absen.absendate,
                tx_absen.userid,
                min(tx_absen.absentime) AS timein
            FROM wfm_schema.tx_absen
            WHERE tx_absen.absentype = true
            GROUP BY tx_absen.userid, tx_absen.absendate) b ON a.userid = b.userid AND a.absendate = b.absendate
        LEFT JOIN ( SELECT tx_absen.absendate,
                tx_absen.userid,
                max(tx_absen.absentime) AS timeout
            FROM wfm_schema.tx_absen
            WHERE tx_absen.absentype = false
            GROUP BY tx_absen.userid, tx_absen.absendate) c ON a.userid = c.userid AND a.absendate = c.absendate
        LEFT JOIN ( SELECT a_1.ref_user_id,
                a_1.tx_user_mobile_management_id,
                a_1.username,
                a_1.area_id,
                a_1.regional_id,
                a_1.ns_id,
                b_1.network_service_name,
                a_1.cluster_id,
                c_1.cluster_name,
                a_1.rtp
            FROM wfm_schema.tx_user_mobile_management a_1
                LEFT JOIN wfm_schema.tm_network_service b_1 ON a_1.ns_id::text = b_1.network_service_id::text
                LEFT JOIN wfm_schema.tm_cluster c_1 ON a_1.cluster_id = c_1.cluster_id
            WHERE a_1.is_active = true) d ON a.userid = d.tx_user_mobile_management_id
    GROUP BY a.absendate, a.userid, b.timein, c.timeout, d.username, d.area_id, d.regional_id, d.network_service_name, d.cluster_name, d.rtp, e.status_ticket
    ORDER BY a.absendate DESC;

ALTER TABLE wfm_schema.vw_absen_user
    OWNER TO postgres;


tx_absen.userid = tx_user_mobile_management_id
tx_user_mobile_management.id = tx_ticket_terr_opr.pic_id

-- Add NEW COLUMN STATUS FROM tx.ticket_terr_opr
CREATE OR REPLACE VIEW wfm_schema.vw_absen_user AS
SELECT a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    c.timeout - b.timein AS workinghour,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp,
    e.status
FROM wfm_schema.tx_absen a
LEFT JOIN (
    SELECT tx_absen.absendate,
           tx_absen.userid,
           min(tx_absen.absentime) AS timein
    FROM wfm_schema.tx_absen
    WHERE tx_absen.absentype = true
    GROUP BY tx_absen.userid, tx_absen.absendate
) b ON a.userid = b.userid AND a.absendate = b.absendate
LEFT JOIN (
    SELECT tx_absen.absendate,
           tx_absen.userid,
           max(tx_absen.absentime) AS timeout
    FROM wfm_schema.tx_absen
    WHERE tx_absen.absentype = false
    GROUP BY tx_absen.userid, tx_absen.absendate
) c ON a.userid = c.userid AND a.absendate = c.absendate
LEFT JOIN (
    SELECT a_1.ref_user_id,
           a_1.tx_user_mobile_management_id,
           a_1.username,
           a_1.area_id,
           a_1.regional_id,
           a_1.ns_id,
           b_1.network_service_name,
           a_1.cluster_id,
           c_1.cluster_name,
           a_1.rtp
    FROM wfm_schema.tx_user_mobile_management a_1
    LEFT JOIN wfm_schema.tm_network_service b_1 ON a_1.ns_id::text = b_1.network_service_id::text
    LEFT JOIN wfm_schema.tm_cluster c_1 ON a_1.cluster_id = c_1.cluster_id
    WHERE a_1.is_active = true
) d ON a.userid = d.tx_user_mobile_management_id
LEFT JOIN (
    SELECT pic_id, status
    FROM wfm_schema.tx_ticket_terr_opr
) e ON d.tx_user_mobile_management_id::varchar = e.pic_id
GROUP BY a.absendate, a.userid, b.timein, c.timeout, d.username, d.area_id, d.regional_id, d.network_service_name, d.cluster_name, d.rtp, e.status
ORDER BY a.absendate DESC;