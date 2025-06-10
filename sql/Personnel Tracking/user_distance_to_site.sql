CREATE
OR REPLACE VIEW wfm_schema.vw_device_nearby_sites AS WITH latest_location AS (
    SELECT
        deviceudid,
        currenttime,
        CAST(latitude AS DECIMAL(12,6)) AS latitude,
        CAST(longitude AS DECIMAL(12,6)) AS longitude
    FROM
        (
            SELECT
                u.*,
                ROW_NUMBER() OVER (
                    PARTITION BY deviceudid
                    ORDER BY
                        currenttime DESC
                ) AS rn
            FROM
                wfm_schema.tx_location_device u
            WHERE
                latitude IS NOT NULL
                AND longitude IS NOT NULL
        ) latest
    WHERE
        rn = 1
),
clean_sites AS (
    SELECT
        site_id,
        CAST(REPLACE(site_latitude, ',', '.') AS DECIMAL(12,6)) AS clean_lat,
        CAST(REPLACE(site_longitude, ',', '.') AS DECIMAL(12,6)) AS clean_lon
    FROM
        wfm_schema.tx_site
    WHERE
        site_latitude IS NOT NULL
        AND site_longitude IS NOT NULL
        AND site_latitude NOT IN ('', '-', 'N/A', 'NaN', 'null')
        AND site_longitude NOT IN ('', '-', 'N/A', 'NaN', 'null')
        AND site_latitude ~ '^[0-9]+([.,][0-9]+)?$'
        AND site_longitude ~ '^[0-9]+([.,][0-9]+)?$'
)
SELECT
    l.deviceudid,
    l.currenttime as device_currenttime,
    s.site_id,
    l.latitude as origin_lat,
    l.longitude as origin_lon,
    s.clean_lat as destination_lat,
    s.clean_lon as destination_lon,
    6371000 * acos(
        LEAST(
            1,
            GREATEST(
                -1,
                cos(radians(s.clean_lat)) * cos(radians(l.latitude)) * cos(radians(l.longitude) - radians(s.clean_lon)) + sin(radians(s.clean_lat)) * sin(radians(l.latitude))
            )
        )
    ) AS distance
FROM
    latest_location l
    JOIN clean_sites s ON s.clean_lat BETWEEN l.latitude - 0.45
    AND l.latitude + 0.45
    AND s.clean_lon BETWEEN l.longitude - 0.45
    AND l.longitude + 0.45
GROUP BY
    l.deviceudid,
    l.currenttime,
    s.site_id,
    l.latitude,
    l.longitude,
    s.clean_lat,
    s.clean_lon
HAVING
    6371000 * acos(
        LEAST(
            1,
            GREATEST(
                -1,
                cos(radians(s.clean_lat)) * cos(radians(l.latitude)) * cos(radians(l.longitude) - radians(s.clean_lon)) + sin(radians(s.clean_lat)) * sin(radians(l.latitude))
            )
        )
    ) <= 25000
ORDER BY
    distance desc;

-- 
-- Alter OS
-- 
WITH latest_location AS (
    SELECT
        *
    FROM
        (
            SELECT
                u.*,
                ROW_NUMBER() OVER (
                    PARTITION BY deviceudid
                    ORDER BY
                        currenttime DESC
                ) AS rn
            FROM
                { tx_location_device } u
            WHERE
                latitude IS NOT NULL
                AND longitude IS NOT NULL
        ) latest
    WHERE
        rn = 1
),
clean_sites AS (
    SELECT
        site_id,
        CAST(REPLACE(site_latitude, ',', '.') AS numeric) AS clean_lat,
        CAST(REPLACE(site_longitude, ',', '.') AS numeric) AS clean_lon
    FROM
        { tx_site }
    WHERE
        site_latitude IS NOT NULL
        AND site_longitude IS NOT NULL
        AND site_latitude NOT IN ('', '-', 'N/A', 'NaN', 'null')
        AND site_longitude NOT IN ('', '-', 'N/A', 'NaN', 'null')
        AND site_latitude ~ '^[0-9]+([.,][0-9]+)?$'
        AND site_longitude ~ '^[0-9]+([.,][0-9]+)?$'
)
SELECT
    l.deviceudid,
    l.currenttime,
    s.site_id,
    l.latitude,
    l.longitude,
    6371000 * acos(
        LEAST(
            1,
            GREATEST(
                -1,
                cos(radians(s.clean_lat)) * cos(radians(l.latitude)) * cos(radians(l.longitude) - radians(s.clean_lon)) + sin(radians(s.clean_lat)) * sin(radians(l.latitude))
            )
        )
    ) AS distance
FROM
    latest_location l
    JOIN clean_sites s ON s.clean_lat BETWEEN l.latitude - 0.45
    AND l.latitude + 0.45
    AND s.clean_lon BETWEEN l.longitude - 0.45
    AND l.longitude + 0.45
GROUP BY
    l.deviceudid,
    l.currenttime,
    s.site_id,
    l.latitude,
    l.longitude,
    s.clean_lat,
    s.clean_lon
HAVING
    6371000 * acos(
        LEAST(
            1,
            GREATEST(
                -1,
                cos(radians(s.clean_lat)) * cos(radians(l.latitude)) * cos(radians(l.longitude) - radians(s.clean_lon)) + sin(radians(s.clean_lat)) * sin(radians(l.latitude))
            )
        )
    ) <= 25000
ORDER BY
    distance desc;