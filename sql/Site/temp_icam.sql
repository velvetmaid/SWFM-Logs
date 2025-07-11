WITH ranked_sites AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY site_id ORDER BY insert_time_clickhouse DESC) AS rn
  FROM wfm_admin_schema.icam_ran_master_site
)
SELECT *
FROM ranked_sites
WHERE rn = 1 AND (
        site_id IS NULL OR site_id = '' OR
        site_name IS NULL OR site_name = '' OR
        longitude IS NULL OR longitude = '' OR
        latitude IS NULL OR latitude = '' OR
        last_exist IS NULL OR
        last_update IS NULL OR
        id_desa IS NULL OR id_desa = '' OR
        desa IS NULL OR desa = '' OR
        id_kec IS NULL OR id_kec = '' OR
        kecamatan IS NULL OR kecamatan = '' OR
        id_kab IS NULL OR id_kab = '' OR
        kabupaten IS NULL OR kabupaten = '' OR
        id_region_sales IS NULL OR id_region_sales = '' OR
        region_sales IS NULL OR region_sales = '' OR
        id_region_network IS NULL OR id_region_network = '' OR
        region_network IS NULL OR region_network = '' OR
        id_area IS NULL OR id_area = '' OR
        area IS NULL OR area = '' OR
        id_branch IS NULL OR id_branch = '' OR
        branch IS NULL OR branch = '' OR
        id_subbranch IS NULL OR id_subbranch = '' OR
        subbranch IS NULL OR subbranch = '' OR
        id_cluster IS NULL OR id_cluster = '' OR
        cluster IS NULL OR cluster = '' OR
        kabupaten_lacima IS NULL OR kabupaten_lacima = '' OR
        kecamatan_lacima IS NULL OR kecamatan_lacima = '' OR
        desa_lacima IS NULL OR desa_lacima = '' OR
        id_provinsi IS NULL OR id_provinsi = '' OR
        provinsi IS NULL OR provinsi = '' OR
        address IS NULL OR address = '' OR
        nop_name IS NULL OR nop_name = '' OR
        sitearea_to IS NULL OR sitearea_to = '' OR
        class IS NULL OR class = '' OR
        flag_site IS NULL OR flag_site = ''
) and DATE(insert_time_clickhouse) = current_date - 1

SELECT
    'SELECT * FROM wfm_admin_schema.icam_ran_master_site WHERE ' || string_agg (
        format (
            '%I IS NULL OR %I = ''''',
            column_name,
            column_name
        ),
        ' OR '
    )
FROM
    information_schema.columns
WHERE
    table_name = 'icam_ran_master_site'
    AND table_schema = 'wfm_admin_schema';