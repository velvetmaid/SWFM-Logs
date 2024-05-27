-- wfm_schema.vw_user_mobile_absent_location source
CREATE
OR REPLACE VIEW wfm_schema.vw_user_mobile_absent_location AS
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
    tx_user_mobile_management.employee_name,
    tx_user_mobile_management.phone_number,
    tm_area.area_id,
    tm_area.area_name,
    tm_regional.regional_id,
    tm_regional.regional_name,
    tm_network_service.network_service_id,
    tm_network_service.network_service_name,
    tm_nop.nop_id,
    tm_nop.nop_name,
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
                    wfm_schema.tx_ticket_terr_opr tx_ticket_terr_opr_1
                WHERE
                    tx_ticket_terr_opr_1.pic_id :: text = tx_user_mobile_management.tx_user_mobile_management_id :: character varying :: text
                    AND tx_ticket_terr_opr_1.status :: text = 'IN PROGRESS' :: text
            )
        ) THEN string_agg(
            DISTINCT tx_ticket_terr_opr.ticket_no :: text,
            ', ' :: text
        )
        ELSE NULL :: text
    END AS tx_ticket_terr_opr_ticket_no,
    CASE
        WHEN (
            EXISTS (
                SELECT
                    1
                FROM
                    wfm_schema.tx_ticket_terr_opr tx_ticket_terr_opr_1
                WHERE
                    tx_ticket_terr_opr_1.pic_id :: text = tx_user_mobile_management.tx_user_mobile_management_id :: character varying :: text
                    AND tx_ticket_terr_opr_1.status :: text = 'IN PROGRESS' :: text
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
            tm_nop_1.nop_id,
            tm_nop_1.nop_name
        FROM
            wfm_schema.tm_nop tm_nop_1
    ) tm_nop ON tx_user_mobile_management.nop_id :: text = tm_nop.nop_id :: text
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
    LEFT JOIN (
        SELECT
            tx_ticket_terr_opr_1.tx_ticket_terr_opr_id,
            tx_ticket_terr_opr_1.ticket_no,
            tx_ticket_terr_opr_1.site_id,
            tx_ticket_terr_opr_1.pic_id
        FROM
            wfm_schema.tx_ticket_terr_opr tx_ticket_terr_opr_1
    ) tx_ticket_terr_opr ON tx_ticket_terr_opr.pic_id :: text = tx_user_mobile_management.tx_user_mobile_management_id :: character varying :: text
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
    tm_nop.nop_id,
    tm_nop.nop_name,
    tm_cluster.cluster_id,
    tm_cluster.cluster_name,
    tm_user_role.is_active,
    tm_user_role.is_delete;

-- 
--     GroupAggregate  (cost=23625315.59..874442655691.68 rows=25138041 width=1356) (actual time=17603.600..98215.891 rows=2672 loops=1)
--   Group Key: tx_user_mobile_management.tx_user_mobile_management_id, ranked_absen.absentype, tx_location_device.currenttime, tx_location_device.longitude, tx_location_device.latitude, tx_location_device.deviceudid, tx_location_device.deviceplatform, ranked_absen.rank_amount, tm_area_1.area_id, tm_regional_1.regional_id, tm_network_service_1.network_service_id, tm_nop_1.nop_id, tm_cluster_1.cluster_id, tm_user_role_1.is_active, tm_user_role_1.is_delete
--   ->  Sort  (cost=23625315.59..23688160.69 rows=25138041 width=1776) (actual time=17466.206..17721.115 rows=447804 loops=1)
--         Sort Key: tx_user_mobile_management.tx_user_mobile_management_id, ranked_absen.absentype, tx_location_device.currenttime, tx_location_device.longitude, tx_location_device.latitude, tx_location_device.deviceudid, tx_location_device.deviceplatform, ranked_absen.rank_amount, tm_area_1.area_id, tm_regional_1.regional_id, tm_network_service_1.network_service_id, tm_nop_1.nop_id, tm_cluster_1.cluster_id, tm_user_role_1.is_active, tm_user_role_1.is_delete
--         Sort Method: external merge  Disk: 101424kB
--         ->  Merge Left Join  (cost=700235.63..1203190.91 rows=25138041 width=1776) (actual time=13411.489..13643.010 rows=447804 loops=1)
--               Merge Cond: ((((tx_user_mobile_management.tx_user_mobile_management_id)::character varying)::text) = (tx_ticket_terr_opr_1.pic_id)::text)
--               ->  Sort  (cost=202995.99..203044.60 rows=19446 width=1776) (actual time=9424.044..9426.598 rows=4038 loops=1)
--                     Sort Key: (((tx_user_mobile_management.tx_user_mobile_management_id)::character varying)::text)
--                     Sort Method: quicksort  Memory: 1257kB
--                     ->  Merge Join  (cost=175428.52..201610.73 rows=19446 width=1776) (actual time=8517.109..9411.385 rows=4038 loops=1)
--                           Merge Cond: (tx_user_mobile_management.tx_user_mobile_management_id = mapping_user_mobile_role_1.tx_user_mobile_management_id)
--                           ->  Merge Join  (cost=175156.51..200709.20 rows=147905 width=1262) (actual time=8506.724..9394.323 rows=2756 loops=1)
--                                 Merge Cond: (tx_user_mobile_management.tx_user_mobile_management_id = ranked_absen.userid)
--                                 ->  Sort  (cost=83464.05..83472.32 rows=3307 width=1249) (actual time=7103.727..7106.150 rows=2687 loops=1)
--                                       Sort Key: tx_user_mobile_management.tx_user_mobile_management_id
--                                       Sort Method: quicksort  Memory: 811kB
--                                       ->  Hash Left Join  (cost=66756.61..83270.74 rows=3307 width=1249) (actual time=5601.787..7098.193 rows=2687 loops=1)
--                                             Hash Cond: (tx_user_mobile_management.cluster_id = tm_cluster_1.cluster_id)
--                                             ->  Hash Left Join  (cost=66749.65..83254.88 rows=3307 width=1236) (actual time=5601.572..7095.334 rows=2687 loops=1)
--                                                   Hash Cond: ((tx_user_mobile_management.nop_id)::text = (tm_nop_1.nop_id)::text)
--                                                   ->  Hash Left Join  (cost=66744.50..83240.80 rows=3307 width=1222) (actual time=5601.409..7092.923 rows=2687 loops=1)
--                                                         Hash Cond: ((tx_user_mobile_management.ns_id)::text = (tm_network_service_1.network_service_id)::text)
--                                                         ->  Hash Left Join  (cost=66742.26..83229.21 rows=3307 width=1207) (actual time=5601.302..7090.714 rows=2687 loops=1)
--                                                               Hash Cond: ((tx_user_mobile_management.regional_id)::text = (tm_regional_1.regional_id)::text)
--                                                               ->  Hash Left Join  (cost=66740.99..83216.44 rows=3307 width=670) (actual time=5601.227..7088.284 rows=2687 loops=1)
--                                                                     Hash Cond: ((tx_user_mobile_management.area_id)::text = (tm_area_1.area_id)::text)
--                                                                     ->  Merge Join  (cost=66739.90..83199.31 rows=3307 width=135) (actual time=5601.040..7085.112 rows=2687 loops=1)
--                                                                           Merge Cond: (tx_location_device.deviceudid = (tx_user_mobile_management.deviceid)::text)
--                                                                           ->  Subquery Scan on tx_location_device  (cost=65752.60..82144.53 rows=2522 width=64) (actual time=5577.348..7018.685 rows=2688 loops=1)
--                                                                                 Filter: (tx_location_device.row_num = 1)
--                                                                                 Rows Removed by Filter: 521445
--                                                                                 ->  WindowAgg  (cost=65752.60..75839.94 rows=504367 width=89) (actual time=5577.340..6922.151 rows=524133 loops=1)
--                                                                                       ->  Sort  (cost=65752.60..67013.52 rows=504367 width=49) (actual time=5577.219..5855.419 rows=524133 loops=1)
--                                                                                             Sort Key: tx_location_device_1.deviceudid, tx_location_device_1.currenttime DESC
--                                                                                             Sort Method: quicksort  Memory: 85909kB
--                                                                                             ->  Seq Scan on tx_location_device tx_location_device_1  (cost=0.00..17978.67 rows=504367 width=49) (actual time=0.024..715.784 rows=524133 loops=1)
--                                                                           ->  Sort  (cost=987.30..1001.36 rows=5621 width=84) (actual time=23.150..26.222 rows=5618 loops=1)
--                                                                                 Sort Key: tx_user_mobile_management.deviceid
--                                                                                 Sort Method: quicksort  Memory: 991kB
--                                                                                 ->  Seq Scan on tx_user_mobile_management  (cost=0.00..637.21 rows=5621 width=84) (actual time=0.103..8.000 rows=5621 loops=1)
--                                                                     ->  Hash  (cost=1.04..1.04 rows=4 width=540) (actual time=0.077..0.081 rows=4 loops=1)
--                                                                           Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                                                           ->  Seq Scan on tm_area tm_area_1  (cost=0.00..1.04 rows=4 width=540) (actual time=0.057..0.061 rows=4 loops=1)
--                                                               ->  Hash  (cost=1.12..1.12 rows=12 width=540) (actual time=0.044..0.045 rows=12 loops=1)
--                                                                     Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                                                     ->  Seq Scan on tm_regional tm_regional_1  (cost=0.00..1.12 rows=12 width=540) (actual time=0.023..0.026 rows=12 loops=1)
--                                                         ->  Hash  (cost=1.55..1.55 rows=55 width=17) (actual time=0.071..0.074 rows=55 loops=1)
--                                                               Buckets: 1024  Batches: 1  Memory Usage: 11kB
--                                                               ->  Seq Scan on tm_network_service tm_network_service_1  (cost=0.00..1.55 rows=55 width=17) (actual time=0.029..0.042 rows=55 loops=1)
--                                                   ->  Hash  (cost=3.40..3.40 rows=140 width=18) (actual time=0.087..0.089 rows=73 loops=1)
--                                                         Buckets: 1024  Batches: 1  Memory Usage: 12kB
--                                                         ->  Seq Scan on tm_nop tm_nop_1  (cost=0.00..3.40 rows=140 width=18) (actual time=0.031..0.055 rows=73 loops=1)
--                                             ->  Hash  (cost=4.76..4.76 rows=176 width=17) (actual time=0.141..0.142 rows=185 loops=1)
--                                                   Buckets: 1024  Batches: 1  Memory Usage: 18kB
--                                                   ->  Seq Scan on tm_cluster tm_cluster_1  (cost=0.00..4.76 rows=176 width=17) (actual time=0.022..0.076 rows=185 loops=1)
--                                 ->  Materialize  (cost=91578.76..116718.63 rows=251399 width=13) (actual time=1398.754..2282.992 rows=4610 loops=1)
--                                       ->  Subquery Scan on ranked_absen  (cost=91578.76..116090.13 rows=251399 width=13) (actual time=1398.748..2280.037 rows=4610 loops=1)
--                                             Filter: (ranked_absen.rank_amount < 2)
--                                             Rows Removed by Filter: 671981
--                                             ->  WindowAgg  (cost=91578.76..106662.68 rows=754196 width=21) (actual time=1398.745..2221.066 rows=676591 loops=1)
--                                                   ->  Sort  (cost=91578.76..93464.25 rows=754196 width=13) (actual time=1398.642..1582.146 rows=676592 loops=1)
--                                                         Sort Key: tx_absen.userid, tx_absen.absentime DESC
--                                                         Sort Method: quicksort  Memory: 80358kB
--                                                         ->  Seq Scan on tx_absen  (cost=0.00..17951.96 rows=754196 width=13) (actual time=0.103..326.089 rows=714001 loops=1)
--                           ->  Sort  (cost=272.01..273.88 rows=750 width=522) (actual time=10.287..11.993 rows=8306 loops=1)
--                                 Sort Key: mapping_user_mobile_role_1.tx_user_mobile_management_id
--                                 Sort Method: quicksort  Memory: 831kB
--                                 ->  Hash Join  (cost=1.38..236.19 rows=750 width=522) (actual time=0.136..5.965 rows=8167 loops=1)
--                                       Hash Cond: (mapping_user_mobile_role_1.role_id = tm_user_role_1.tm_user_role_id)
--                                       ->  Seq Scan on mapping_user_mobile_role mapping_user_mobile_role_1  (cost=0.00..207.01 rows=9001 width=8) (actual time=0.036..1.962 rows=8961 loops=1)
--                                       ->  Hash  (cost=1.36..1.36 rows=2 width=522) (actual time=0.060..0.062 rows=2 loops=1)
--                                             Buckets: 1024  Batches: 1  Memory Usage: 9kB
--                                             ->  Seq Scan on tm_user_role tm_user_role_1  (cost=0.00..1.36 rows=2 width=522) (actual time=0.040..0.044 rows=2 loops=1)
--                                                   Filter: (((code)::text = 'MUSERTS'::text) OR ((code)::text = 'MUSERMBP'::text))
--                                                   Rows Removed by Filter: 22
--               ->  Sort  (cost=497239.65..503558.40 rows=2527501 width=1) (actual time=3644.765..3893.634 rows=2444485 loops=1)
--                     Sort Key: tx_ticket_terr_opr_1.pic_id
--                     Sort Method: external sort  Disk: 35032kB
--                     ->  Seq Scan on tx_ticket_terr_opr tx_ticket_terr_opr_1  (cost=0.00..228449.01 rows=2527501 width=1) (actual time=0.055..2254.725 rows=2292141 loops=1)
--   SubPlan 1
--     ->  Index Scan using idx_tx_ticket_terr_opr_status on tx_ticket_terr_opr tx_ticket_terr_opr_1_1  (cost=0.43..27827.08 rows=8 width=0) (never executed)
--           Index Cond: ((status)::text = 'IN PROGRESS'::text)
--           Filter: ((pic_id)::text = ((tx_user_mobile_management.tx_user_mobile_management_id)::character varying)::text)
--   SubPlan 2
--     ->  Index Scan using idx_tx_ticket_terr_opr_status on tx_ticket_terr_opr tx_ticket_terr_opr_1_2  (cost=0.43..27710.19 rows=15586 width=32) (actual time=0.074..70.910 rows=13660 loops=1)
--           Index Cond: ((status)::text = 'IN PROGRESS'::text)
--   SubPlan 3
--     ->  Aggregate  (cost=27827.10..27827.11 rows=1 width=32) (actual time=68.456..68.456 rows=1 loops=1150)
--           ->  Index Scan using idx_tx_ticket_terr_opr_status on tx_ticket_terr_opr tx2  (cost=0.43..27827.08 rows=8 width=21) (actual time=39.610..68.417 rows=6 loops=1150)
--                 Index Cond: ((status)::text = 'IN PROGRESS'::text)
--                 Filter: ((pic_id)::text = ((tx_user_mobile_management.tx_user_mobile_management_id)::character varying)::text)
--                 Rows Removed by Filter: 13654
--   SubPlan 4
--     ->  Index Scan using idx_tx_ticket_terr_opr_status on tx_ticket_terr_opr tx_ticket_terr_opr_1_3  (cost=0.43..27827.08 rows=8 width=0) (never executed)
--           Index Cond: ((status)::text = 'IN PROGRESS'::text)
--           Filter: ((pic_id)::text = ((tx_user_mobile_management.tx_user_mobile_management_id)::character varying)::text)
--   SubPlan 5
--     ->  Index Scan using idx_tx_ticket_terr_opr_status on tx_ticket_terr_opr tx_ticket_terr_opr_1_4  (cost=0.43..27710.19 rows=15586 width=32) (actual time=0.038..55.298 rows=13660 loops=1)
--           Index Cond: ((status)::text = 'IN PROGRESS'::text)
-- Planning Time: 39.217 ms
-- Execution Time: 98297.580 ms
-- 
-- 
-- 
-- CTE ticket terr opr
WITH availabillity_ticket AS (
    SELECT
        tumm.tx_user_mobile_management_id,
        string_agg(
            DISTINCT ttto.ticket_no :: text,
            ', ' :: text
        ) FILTER (
            WHERE
                ttto.created_at >= CURRENT_DATE - INTERVAL '1 day'
        ) AS ticket_no,
        CASE
            WHEN COUNT(ttto.ticket_no) > 0 THEN 'Not Available' :: text
            ELSE 'Available' :: text
        END AS availability_status
    FROM
        wfm_schema.tx_user_mobile_management tumm
        LEFT JOIN wfm_schema.tx_ticket_terr_opr ttto ON ttto.pic_id :: text = tumm.tx_user_mobile_management_id :: character varying :: text
        AND ttto.status :: text = 'IN PROGRESS' :: text
    GROUP BY
        tumm.tx_user_mobile_management_id
)
SELECT
    tx_user_mobile_management_id,
    ticket_no,
    availability_status
FROM
    availabillity_ticket;

-- 
-- Different but same
-- 
WITH availabillity_ticket AS (
    SELECT
        tumm.tx_user_mobile_management_id,
        string_agg(
            DISTINCT ttto.ticket_no :: text,
            ', ' :: text
        ) AS tx_ticket_terr_opr_ticket_no,
        CASE
            WHEN COUNT(ttto.ticket_no) > 0 THEN 'Not Available' :: text
            ELSE 'Available' :: text
        END AS availability_status
    FROM
        wfm_schema.tx_user_mobile_management tumm
        LEFT JOIN wfm_schema.tx_ticket_terr_opr ttto ON ttto.pic_id :: text = tumm.tx_user_mobile_management_id :: character varying :: text
        AND ttto.status :: text = 'IN PROGRESS' :: text
        AND ttto.created_at >= (CURRENT_DATE - '1 day' :: interval)
    GROUP BY
        tumm.tx_user_mobile_management_id
)
SELECT
    tx_user_mobile_management_id,
    tx_ticket_terr_opr_ticket_no,
    availability_status
FROM
    availabillity_ticket;

-- End
-- CTE location device
WITH ranked_devices AS (
    SELECT
        tld.deviceudid :: text AS deviceudid,
        tld.currenttime,
        tld.longitude,
        tld.latitude,
        tld.deviceplatform,
        row_number() OVER (
            PARTITION BY tld.deviceudid
            ORDER BY
                tld.currenttime DESC
        ) AS row_num
    FROM
        wfm_schema.tx_location_device tld
)
SELECT
    deviceudid,
    currenttime,
    longitude,
    latitude,
    deviceplatform
FROM
    ranked_devices
WHERE
    row_num = 1;

-- End
WITH ranked_absen AS (
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
)
SELECT
    userid,
    absentype,
    rank_amount
FROM
    ranked_absen
WHERE
    rank_amount = 1;

-- End
-- CTE role user
SELECT
    mumr.tx_user_mobile_management_id,
    string_agg(DISTINCT tur.name :: text, ', ' :: text) AS role_name
FROM
    wfm_schema.tm_user_role tur
    JOIN wfm_schema.mapping_user_mobile_role mumr ON tur.tm_user_role_id = mumr.role_id
group by
    mumr.tx_user_mobile_management_id
-- End

