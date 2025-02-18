SELECT 
    rec.ref_ticket_no,
    rec.site_id,
    site.site_name,
    rec.id_pelanggan_pln_master,
    area.area_name,
    reg.regional_name,
    nop.nop_name,
    CAST(rec.created_at AS DATE) AS created_at,
    rec.start_period_at,
    rec.end_period_at,
    rec.year_period,
    rec.flag_period
FROM {tx_recap_pln} rec
INNER JOIN {tx_site} site ON rec.site_id = site.site_id
LEFT JOIN {tm_area} area ON site.area_id = area.area_id
LEFT JOIN {tm_regional} reg ON site.regional_id = reg.regional_id
LEFT JOIN {tm_nop} nop ON site.nop_id = nop.nop_id
LEFT JOIN {tm_kabupaten} kab ON site.kabupaten_id = kab.kabupaten_id
LEFT JOIN {tm_kecamatan} kec ON site.kecamatan_id = kec.kecamatan_id
WHERE 
    (@Area = '' OR site.area_id = @Area)
    AND (@Regional = '' OR site.regional_id = @Regional)
    AND (@NOP = '' OR site.nop_id = @NOP)
    AND rec.is_has_schedule = FALSE
    AND rec.year_period = @YearPeriod
    AND rec.flag_period = @FlagPeriod
    AND (
        rec.id_pelanggan_pln_master LIKE '%' || @VarSearch || '%'
        OR site.site_id LIKE '%' || UPPER(@VarSearch) || '%'
        OR rec.ref_ticket_no LIKE '%' || UPPER(@VarSearch) || '%'
        OR site.site_name LIKE '%' || UPPER(@VarSearch) || '%'
    )
GROUP BY 
    rec.ref_ticket_no,
    rec.site_id,
    site.site_name,
    rec.id_pelanggan_pln_master,
    area.area_name,
    reg.regional_name,
    nop.nop_name,
    CAST(rec.created_at AS DATE),
    rec.start_period_at,
    rec.end_period_at,
    rec.year_period,
    rec.flag_period;
