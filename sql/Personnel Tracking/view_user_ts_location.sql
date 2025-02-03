-- 
-- VIEW LOCATION TSM USER
CREATE
OR REPLACE VIEW wfm_schema.vw_technical_support_user_location AS
SELECT
    *
FROM
    (
        SELECT
            a.*,
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
            INNER JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id = b.tx_user_mobile_management_id :: VARCHAR
            INNER JOIN wfm_schema.tx_location_device c ON b.deviceid = c.deviceudid
        WHERE
            a.status = 'IN PROGRESS'
            AND b.is_active = TRUE
            AND b.is_delete = FALSE
    ) AS subquery
WHERE
    subquery.sort_currenttime = 1;

-- 
-- NEW FIX TSM USER LOCATION
CREATE
OR REPLACE VIEW wfm_schema.vw_technical_support_user_location AS
SELECT
    sub.*,
    agg.list_technical_support_ticket_no
FROM
    (
        SELECT
            a.*,
            b.employee_name,
            b.phone_number,
            b.is_active,
            b.is_delete,
            c.deviceudid,
            c.latitude,
            c.longitude,
            c.currenttime,
            ROW_NUMBER() OVER (
                PARTITION BY c.deviceudid
                ORDER BY
                    c.currenttime DESC
            ) AS sort_currenttime
        FROM
            wfm_schema.ticket_technical_support a
            INNER JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id = b.tx_user_mobile_management_id :: VARCHAR
            INNER JOIN wfm_schema.tx_location_device c ON b.deviceid = c.deviceudid
        WHERE
            a.status = 'IN PROGRESS'
            AND b.is_active = TRUE
            AND b.is_delete = FALSE
    ) AS sub
    LEFT JOIN (
        SELECT
            b.deviceid,
            string_agg(DISTINCT a.no_ticket, ', ') AS list_technical_support_ticket_no
        FROM
            wfm_schema.ticket_technical_support a
            INNER JOIN wfm_schema.tx_user_mobile_management b ON a.pic_id = b.tx_user_mobile_management_id :: VARCHAR
        WHERE
            a.status = 'IN PROGRESS'
        GROUP BY
            b.deviceid
    ) AS agg ON sub.deviceudid = agg.deviceid
WHERE
    sub.sort_currenttime = 1;