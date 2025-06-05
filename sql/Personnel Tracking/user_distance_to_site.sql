-- Find user's latest location and calculate closest distance to site
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
        CAST(REPLACE(site_latitude, ',', '.') AS numeric) AS clean_lat,
        CAST(REPLACE(site_longitude, ',', '.') AS numeric) AS clean_lon
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
    s.site_id,
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
    JOIN clean_sites s ON s.clean_lat BETWEEN l.latitude - 0.001
    AND l.latitude + 0.001
    AND s.clean_lon BETWEEN l.longitude - 0.001
    AND l.longitude + 0.001
GROUP BY
    l.deviceudid,
    l.latitude,
    l.longitude,
    s.site_id,
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
    ) <= 100
ORDER BY
    distance
limit
    100