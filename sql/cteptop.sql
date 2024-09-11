WITH availabillity_ticket AS (
    SELECT
        tumm.tx_user_mobile_management_id,
        string_agg(
            DISTINCT ttto.ticket_no,
            ', '
        ) AS ticket_no,
        CASE
            WHEN COUNT(ttto.ticket_no) > 0 THEN 'Not Available'
            ELSE 'Available'
        END AS availability_status
    FROM
        wfm_schema.tx_user_mobile_management tumm
        LEFT JOIN wfm_schema.tx_ticket_terr_opr ttto ON ttto.pic_id = tumm.tx_user_mobile_management_id :: character varying
        AND ttto.status = 'IN PROGRESS'
        AND ttto.created_at >= (CURRENT_DATE - '1 day' :: interval)
    GROUP BY
        tumm.tx_user_mobile_management_id
),
ranked_absen AS (
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
),
row_ranked_absen as (
    select
        userid,
        absentype,
        rank_amount
    FROM
        ranked_absen
    WHERE
        rank_amount = 1
),
ranked_devices AS (
    SELECT
        tld.deviceudid :: text,
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
),
row_ranked_devices AS (
    SELECT
        deviceudid,
        currenttime,
        longitude,
        latitude,
        deviceplatform
    FROM
        ranked_devices
    WHERE
        row_num = 1
),
list_role AS (
    SELECT
        mumr.tx_user_mobile_management_id,
        string_agg(DISTINCT tur.name, ', ') AS role_name
    FROM
        wfm_schema.tm_user_role tur
        JOIN wfm_schema.mapping_user_mobile_role mumr ON tur.tm_user_role_id = mumr.role_id
    group by
        mumr.tx_user_mobile_management_id
)
SELECT
    tumm.tx_user_mobile_management_id,
    tumm.username,
    tumm.employee_name,
    tumm.phone_number,
    ta.area_id,
    ta.area_name,
    tr.regional_id,
    tr.regional_name,
    tn.nop_id,
    tn.nop_name,
    tc.cluster_id,
    tc.cluster_name,
    rra.absentype,
    rrd.currenttime,
    rrd.longitude,
    rrd.latitude,
    rrd.deviceudid,
    rrd.deviceplatform,
    lr.role_name,
    at.ticket_no,
    at.availability_status
FROM
    wfm_schema.tx_user_mobile_management tumm
    LEFT JOIN wfm_schema.tm_area ta ON tumm.area_id = ta.area_id
    LEFT JOIN wfm_schema.tm_regional tr ON tumm.regional_id = tr.regional_id
    LEFT JOIN wfm_schema.tm_nop tn ON tumm.nop_id = tn.nop_id
    LEFT JOIN wfm_schema.tm_cluster tc ON tumm.cluster_id = tc.cluster_id
    INNER JOIN availabillity_ticket at ON tumm.tx_user_mobile_management_id = at.tx_user_mobile_management_id
    INNER JOIN row_ranked_devices rrd ON tumm.deviceid = rrd.deviceudid
    INNER JOIN row_ranked_absen rra ON tumm.tx_user_mobile_management_id = rra.userid
    INNER JOIN list_role lr ON tumm.tx_user_mobile_management_id = lr.tx_user_mobile_management_id