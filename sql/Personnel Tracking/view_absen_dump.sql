CREATE
OR REPLACE VIEW wfm_schema.vw_absen_user2 AS
SELECT
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    c.timeout - b.timein AS workinghour,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp -- e.status_ticket LEFT JOIN dari table baru tx_ticket_terr_opr column.pic_id = 
FROM
    wfm_schema.tx_absen a
    LEFT JOIN (
        SELECT
            tx_absen.absendate,
            tx_absen.userid,
            min(tx_absen.absentime) AS timein
        FROM
            wfm_schema.tx_absen
        WHERE
            tx_absen.absentype = true
        GROUP BY
            tx_absen.userid,
            tx_absen.absendate
    ) b ON a.userid = b.userid
    AND a.absendate = b.absendate
    LEFT JOIN (
        SELECT
            tx_absen.absendate,
            tx_absen.userid,
            max(tx_absen.absentime) AS timeout
        FROM
            wfm_schema.tx_absen
        WHERE
            tx_absen.absentype = false
        GROUP BY
            tx_absen.userid,
            tx_absen.absendate
    ) c ON a.userid = c.userid
    AND a.absendate = c.absendate
    LEFT JOIN (
        SELECT
            a_1.ref_user_id,
            a_1.username,
            a_1.area_id,
            a_1.regional_id,
            a_1.ns_id,
            b_1.network_service_name,
            a_1.cluster_id,
            c_1.cluster_name,
            a_1.rtp
        FROM
            wfm_schema.tx_user_management a_1
            LEFT JOIN wfm_schema.tm_network_service b_1 ON a_1.ns_id :: text = b_1.network_service_id :: text
            LEFT JOIN wfm_schema.tm_cluster c_1 ON a_1.cluster_id = c_1.cluster_id
        WHERE
            a_1.is_active = true
    ) d ON a.userid = d.ref_user_id
GROUP BY
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
ORDER BY
    a.absendate DESC;

ALTER TABLE
    wfm_schema.vw_absen_user2 OWNER TO postgres;

-- 
-- 
-- 
CREATE
OR REPLACE VIEW wfm_schema.vw_absen_user AS
SELECT
    a.absendate,
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
    e.status_ticket -- e.status_ticket LEFT JOIN dari table baru tx_ticket_terr_opr.pic_id = tx_user_mobile_management.tx_user_mobile_management_id
FROM
    wfm_schema.tx_absen a
    LEFT JOIN (
        SELECT
            tx_absen.absendate,
            tx_absen.userid,
            min(tx_absen.absentime) AS timein
        FROM
            wfm_schema.tx_absen
        WHERE
            tx_absen.absentype = true
        GROUP BY
            tx_absen.userid,
            tx_absen.absendate
    ) b ON a.userid = b.userid
    AND a.absendate = b.absendate
    LEFT JOIN (
        SELECT
            tx_absen.absendate,
            tx_absen.userid,
            max(tx_absen.absentime) AS timeout
        FROM
            wfm_schema.tx_absen
        WHERE
            tx_absen.absentype = false
        GROUP BY
            tx_absen.userid,
            tx_absen.absendate
    ) c ON a.userid = c.userid
    AND a.absendate = c.absendate
    LEFT JOIN (
        SELECT
            a_1.ref_user_id,
            a_1.tx_user_mobile_management_id,
            a_1.username,
            a_1.area_id,
            a_1.regional_id,
            a_1.ns_id,
            b_1.network_service_name,
            a_1.cluster_id,
            c_1.cluster_name,
            a_1.rtp
        FROM
            wfm_schema.tx_user_mobile_management a_1
            LEFT JOIN wfm_schema.tm_network_service b_1 ON a_1.ns_id :: text = b_1.network_service_id :: text
            LEFT JOIN wfm_schema.tm_cluster c_1 ON a_1.cluster_id = c_1.cluster_id
        WHERE
            a_1.is_active = true
    ) d ON a.userid = d.tx_user_mobile_management_id
GROUP BY
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp,
    e.status_ticket
ORDER BY
    a.absendate DESC;

ALTER TABLE
    wfm_schema.vw_absen_user OWNER TO postgres;

tx_absen.userid = tx_user_mobile_management_id tx_user_mobile_management.id = tx_ticket_terr_opr.pic_id -- Add NEW COLUMN STATUS FROM tx.ticket_terr_opr
CREATE
OR REPLACE VIEW wfm_schema.vw_absen_user AS
SELECT
    a.absendate,
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
FROM
    wfm_schema.tx_absen a
    LEFT JOIN (
        SELECT
            tx_absen.absendate,
            tx_absen.userid,
            min(tx_absen.absentime) AS timein
        FROM
            wfm_schema.tx_absen
        WHERE
            tx_absen.absentype = true
        GROUP BY
            tx_absen.userid,
            tx_absen.absendate
    ) b ON a.userid = b.userid
    AND a.absendate = b.absendate
    LEFT JOIN (
        SELECT
            tx_absen.absendate,
            tx_absen.userid,
            max(tx_absen.absentime) AS timeout
        FROM
            wfm_schema.tx_absen
        WHERE
            tx_absen.absentype = false
        GROUP BY
            tx_absen.userid,
            tx_absen.absendate
    ) c ON a.userid = c.userid
    AND a.absendate = c.absendate
    LEFT JOIN (
        SELECT
            a_1.ref_user_id,
            a_1.tx_user_mobile_management_id,
            a_1.username,
            a_1.area_id,
            a_1.regional_id,
            a_1.ns_id,
            b_1.network_service_name,
            a_1.cluster_id,
            c_1.cluster_name,
            a_1.rtp
        FROM
            wfm_schema.tx_user_mobile_management a_1
            LEFT JOIN wfm_schema.tm_network_service b_1 ON a_1.ns_id :: text = b_1.network_service_id :: text
            LEFT JOIN wfm_schema.tm_cluster c_1 ON a_1.cluster_id = c_1.cluster_id
        WHERE
            a_1.is_active = true
    ) d ON a.userid = d.tx_user_mobile_management_id
    LEFT JOIN (
        SELECT
            pic_id,
            status
        FROM
            wfm_schema.tx_ticket_terr_opr
    ) e ON d.tx_user_mobile_management_id :: varchar = e.pic_id
GROUP BY
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp,
    e.status
ORDER BY
    a.absendate DESC;

-- 
-- 
-- View: wfm_schema.vw_user_absen_location
-- DROP VIEW wfm_schema.vw_user_absen_location;
CREATE
OR REPLACE VIEW wfm_schema.vw_user_absen_locationXX AS
SELECT
    tx_user_mobile_management.ref_user_id,
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
    ) ranked ON ranked.userid = tx_user_mobile_management.ref_user_id
ORDER BY
    tx_location_device.currenttime;

-- 
--
CREATE
OR REPLACE VIEW wfm_schema.vw_user_absen_location AS
SELECT
    tx_user_management.ref_user_id,
    ranked.absentype,
    tx_location_device.currenttime,
    tx_location_device.longitude,
    tx_location_device.latitude,
    tx_location_device.deviceudid,
    tx_location_device.deviceplatform,
    ranked.rank_amount,
    tx_user_management.username
FROM
    wfm_schema.tx_location_device
    JOIN wfm_schema.tx_user_management ON tx_user_management.deviceid :: text = tx_location_device.deviceudid :: text
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
    ) ranked ON ranked.userid = tx_user_management.ref_user_id
ORDER BY
    tx_location_device.currenttime;

ALTER TABLE
    wfm_schema.vw_user_absen_location OWNER TO postgres;

GRANT ALL ON TABLE wfm_schema.vw_user_absen_location TO postgres;

GRANT
SELECT
    ON TABLE wfm_schema.vw_user_absen_location TO readaccess;

-- 
-- Absent list mobile
SELECT
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp,
    d.ref_user_id_before
from
    wfm_schema.tx_absen a
    left join (
        select
            absendate,
            userid,
            min(absentime) timein
        from
            wfm_schema.tx_absen
        where
            absentype = true
        group by
            userid,
            absendate
    ) b on a.userid = b.userid
    and a.absendate = b.absendate
    left join (
        select
            absendate,
            userid,
            max(absentime) timeout
        from
            wfm_schema.tx_absen
        where
            absentype = false
        group by
            userid,
            absendate
    ) c on a.userid = c.userid
    and a.absendate = c.absendate
    left join (
        select
            a.tx_user_mobile_management_id,
            a.username,
            a.area_id,
            a.regional_id,
            a.ns_id,
            b.network_service_name,
            a.cluster_id,
            c.cluster_name,
            a.rtp a.ref_user_id
        from
            wfm_schema.tx_user_mobile_management a
            left join wfm_schema.tm_network_service b on a.ns_id = b.network_service_id
            left join wfm_schema.tm_cluster c on a.cluster_id = c.cluster_id
        where
            a.is_active = true
    ) d on a.userid = d.tx_user_mobile_management_id
    or a.userid = d.ref_user_id_before
group by
    a.absendate,
    a.userid,
    b.timein,
    c.timeout,
    d.username,
    d.area_id,
    d.regional_id,
    d.network_service_name,
    d.cluster_name,
    d.rtp
order by
    a.absendate desc;

-- End absent list mobile
-- CHECK IN PROGRESS STATUS TICKET
SELECT
    *
FROM
    (
        SELECT
            tx_ticket_terr_opr.ticket_no,
            tx_ticket_terr_opr.inap_ticket_no,
            tx_ticket_terr_opr.site_name,
            tx_ticket_terr_opr.networkservice,
            tx_ticket_terr_opr.site_id,
            tx_ticket_terr_opr.status,
            tx_ticket_terr_opr.pic_name
        FROM
            (
                (
                    (
                        (
                            (
                                wfm_schema.tx_ticket_terr_opr tx_ticket_terr_opr
                                INNER JOIN wfm_schema.tx_site tx_site ON (
                                    tx_ticket_terr_opr.site_id = tx_site.site_id
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
        WHERE
            (tx_site.is_active = (cast(1 as boolean)))
            AND (tx_site.is_delete = (cast(0 as boolean)))
            AND (
                tx_ticket_terr_opr.ticket_no = 'BPS-2023-000000100182'
            ) -- AND (tm_cluster.ns_id IS NULL)
            -- AND (tm_regional.area_id IS NULL)
            -- AND (tx_site.cluster_id IS NULL)
    ) as result;

SELECT
    a.status,
    a.id_pel_pln,
    b.total_tagihan,
    b.payment_status,
    c.name,
    c.site_owner,
    c.wilayah_pln_id,
    c.area_pln_id,
    c.prefix_id,
    c.status AS status_power,
    c.idpel AS id_pelanggan,
    d.siteid AS ioms_site_id,
    d.name AS ioms_site_name,
    e.site_id AS wfm_site_id,
    e.site_name AS wfm_site_name
FROM
    ipas_schema.tx_site_recurring_invoice a
    INNER JOIN ipas_schema.tx_power_invoice b ON a.site_recurring_inovice_id = b.site_recurring_invoice_id
    INNER JOIN ipas_schema.tm_power c ON c.power_id = a.power_id
    INNER JOIN ioms_dev_schema.tm_site d ON c.site_id :: BIGINT = d.site_id
    INNER JOIN wfm_schema.tx_site e ON d.siteid = e.site_id
LIMIT
    1000: CREATE
    OR REPLACE VIEW wfm_schema.vw_power_pln_pelanggan AS
SELECT
    a.status,
    a.id_pel_pln,
    b.total_tagihan,
    b.payment_status,
    c.name,
    c.site_owner,
    c.wilayah_pln_id,
    c.area_pln_id,
    c.prefix_id,
    c.status AS status_power,
    c.idpel AS id_pelanggan,
    c.site_id AS ipas_site_id,
    d.site_id AS ioms_site_id,
    d.siteid AS site_id,
    d.name AS site_name
FROM
    ipas_schema.tx_site_recurring_invoice a
    INNER JOIN ipas_schema.tx_power_invoice b ON a.site_recurring_inovice_id = b.site_recurring_invoice_id
    INNER JOIN ipas_schema.tm_power c ON c.power_id = a.power_id
    INNER JOIN ioms_dev_schema.tm_site d ON c.site_id :: BIGINT = d.site_id;

SELECT
    *
FROM
    ipas_schema.tm_power a
    INNER JOIN ioms_dev_schema.tm_site b ON a.site_id :: BIGINT = b.site_id;

SELECT
    b.idpelnomor as id_pelanggan_nomor,
    b.idpelnomor as id_pelanggan_nomor,
    a.site_id,
    a.area_id,
    a.regional_id,
    a.nop_id,
    a.cluster_id,
    b.jenisbill as jenis_inquiry,
    b.tarif as tarif_terpasang,
    b.daya as daya_terpasang,
    b.prefix,
    b.status as status_id_pelanggan
FROM
    wfm_schema.tx_site a
    LEFT JOIN wfm_schema.dummy_pln_pelanggan b ON a.site_id = b.siteid;

-- User mobile
SELECT
    a.username,
    a.email,
    a.phone_number,
    a.tx_user_management_id,
    a.ref_user_id,
    a.employee_name,
    a.area_id,
    b.area_name,
    a.regional_id,
    c.regional_name,
    a.ns_id,
    d.network_service_name,
    a.nop_id,
    e.nop_name,
    a.cluster_id,
    f.cluster_name,
    a.is_active
FROM
    wfm_schema.tx_user_mobile_management a
    LEFT JOIN wfm_schema.tm_area b ON a.area_id = b.area_id
    LEFT JOIN wfm_schema.tm_regional c ON a.regional_id = c.regional_id
    LEFT JOIN wfm_schema.tm_network_service d ON a.ns_id = d.network_service_id
    LEFT JOIN wfm_schema.tm_nop e ON a.nop_id = e.nop_id
    LEFT JOIN wfm_schema.tm_cluster f ON a.cluster_id = f.cluster_id;

-- VW SITE REGULER WITH WAREHOUSE
CREATE
OR REPLACE VIEW wfm_schema.vw_site_reguler_warehouse AS
SELECT
    a.site_id,
    a.site_name,
    a.site_address,
	a.area_id,
	a.regional_id,
	a.nop_id,
	a.cluster_id,
    TRUE AS is_site_reguler
FROM
    wfm_schema.tx_site a
UNION
SELECT
    b.site_id,
    b.site_name,
    b.site_address,
	b.area_id,
	b.regional_id,
	b.nop_id,
	b.cluster_id,
    FALSE AS is_site_reguler
FROM
    wfm_schema.tx_site_warehouse b