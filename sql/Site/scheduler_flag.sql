UPDATE wfm_schema.tx_site
SET 
    is_site_sam = FALSE,
    exclude = TRUE
WHERE site_id IN (
    SELECT site_id
    FROM (
        SELECT DISTINCT ON (site_id)
            site_id, last_exist, flag_site, nop_name
        FROM wfm_admin_schema.icam_ran_master_site
        WHERE insert_time_clickhouse::date = '2025-07-28'
        ORDER BY site_id, last_exist DESC
    ) AS t
    WHERE flag_site = 'Site Reguler' AND nop_name IS NOT NULL
)
AND is_site_sam = TRUE;

UPDATE wfm_schema.tx_site
SET 
is_site_sam = TRUE,
exclude = FALSE
WHERE site_id IN (
    SELECT site_id
    FROM (
        SELECT DISTINCT ON (site_id)
            site_id, last_exist, flag_site, nop_name
        FROM wfm_admin_schema.icam_ran_master_site
        WHERE insert_time_clickhouse::date = '2025-07-28'
        ORDER BY site_id, last_exist DESC
    ) t
    WHERE flag_site IN ('USO/MP','3T') AND nop_name IS NOT NULL
) AND is_site_sam = FALSE