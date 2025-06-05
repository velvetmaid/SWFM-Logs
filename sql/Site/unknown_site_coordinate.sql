-- Find sites with unknown or invalid coordinates
SELECT
    site_id,
    site_latitude,
    site_longitude
FROM
    wfm_schema.tx_site
where
    site_latitude IS NULL
    OR LOWER(site_latitude) IN ('', ' ', '-', 'n/a', 'nan', 'null')
    OR site_longitude IS NULL
    OR LOWER(site_longitude) IN ('', ' ', '-', 'n/a', 'nan', 'null')
    OR site_latitude !~ '^[0-9\-\.,]+$'
    OR site_longitude !~ '^[0-9\-\.,]+$'
    OR site_latitude ~ '\.[0-9]+\.'
    OR site_latitude ~ '[a-zA-Z]'
    OR site_longitude ~ '\.[0-9]+\.'
    OR site_longitude ~ '[a-zA-Z]'
