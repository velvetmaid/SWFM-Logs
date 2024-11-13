SELECT
    trp.ticket_no,
    trp.ref_ticket_no,
    trp.site_id,
    ts.site_name,
    tr.regional_name,
    tn.nop_name,
    tc.cluster_name,
    trp.asset_terdapat_di_site,
    trp.asset_terpasang,
    trp.asset_rusak,
    trp.note_asset_rusak,
    trp.asset_aktif,
    trp.asset_dicuri,
    trp.tsel_barcode,
    trp.nama_asset,
    trp.merk_asset,
    trp.category_asset,
    trp.serial_number,
    trp.asset_owner,
    trp.status,
    trp.keterangan,
    trp.daya_listrik_master,
    trp.daya_listrik,
    trp.daya_sesuai,
    trp.id_pelanggan_pln_master,
    trp.id_pelanggan_pln,
    trp.id_pelanggan_sesuai,
    trp.id_pelanggan_terbaca,
    trp.sumber_catuan,
    trp.pengukuran_kwh,
    trp.durasi_pengukuran_lalu_sekarang,
    trp.sistem_tegangan,
    trp.teg_phase_rn,
    trp.teg_phase_sn,
    trp.teg_phase_tn,
    trp.teg_phase_rt,
    trp.teg_phase_st,
    trp.teg_phase_rs,
    trp.teg_phase_gn,
    trp.total_arus_phase_r,
    trp.total_arus_phase_s,
    trp.total_arus_phase_t,
    trp.teg_phase_netral,
    trp.total_arus_phase,
    trp.total_arus_frek,
    trp.month_schedule,
    trp.year_schedule,
    trp.date_schedule,
    trp.flag_period,
    trp.start_period_at,
    trp.end_period_at,
    trp.year_period,
    trp.created_at,
    trp.pic_name,
    trp.plan_laporan_at,
    trp.laporan_via,
    trp.no_laporan,
    trp.submmit_at,
    trp.submit_name,
    trp.approve_at,
    trp.approve_name,
    trp.note
FROM
    {tx_recap_pln} trp
    left join {tx_site} ts on ts.site_id = trp.site_id
    left join {tm_area} ta on ttrp.area_id = ts.area_id
    left join {tm_regional} tr on tr.regional_id = ts.regional_id
    left join {tm_nop} tn on tn.nop_id = ts.nop_id
    left join {tm_cluster} tc on tc.cluster_id = ts.cluster_id
where
    (
        @AreaId = ''
        or ts.area_id = @AreaId
    )
    and (
        @RegionalId = ''
        or ts.regional_id = @RegionalId
    )
    and (
        @NopId = ''
        or ts.nop_id = @NopId
    )
    and (
        @ClusterId = 0
        or ts.cluster_id = @ClusterId
    )
    and (
        @Status = ''
        or trp.status = @Status
    )
    and (
        trp.ticket_no LIKE '%' || Upper(@InputSearch) || '%'
        OR ts.site_id LIKE '%' || Upper(@InputSearch) || '%'
        OR ts.site_name LIKE '%' || Upper(@InputSearch) || '%'
    )