-- Master site SWFM (Sept, 09 2024)  
select * from wfm_schema.tx_site ts 
where is_active = true and is_delete = false
order by site_id asc;

-- Master IDPEL SWFM(source: API IPAS) (Sept, 09 2024)
select * from wfm_schema.tm_power_pln_pelanggan_ipas tpppi 
order by tm_powerid asc;

-- Transaksi PM PLN (Sept, 09 2024)
select
	a.pm_ticket_site_id,
    a.tx_site_id as site_id_pm,
    b.id_pelanggan_pln as idpel_pm
FROM
    wfm_schema.tx_pm_ticket_site a
    INNER JOIN wfm_schema.tx_pm_site_power_pln b 
    ON a.pm_ticket_site_id = b.tx_pm_ticket_site_id
GROUP BY
    a.pm_ticket_site_id,
    b.tx_pm_site_power_pln_id
order by a.tx_site_id asc;

-- Compare transaksi PM PLN dengan IDPEL SWFM(source: API IPAS)
SELECT
    a.tx_site_id as site_id_pm,
    b.id_pelanggan_pln as idpel_pm,
    c.siteid as site_id_ipas,
    c.idpel as idpel_ipas
FROM
    wfm_schema.tx_pm_ticket_site a
    INNER JOIN wfm_schema.tx_pm_site_power_pln b ON a.pm_ticket_site_id = b.tx_pm_ticket_site_id
    left join wfm_schema.tm_power_pln_pelanggan_ipas c on a.tx_site_id = c.siteid
--WHERE
--    b.id_pelanggan_pln ~ '^\d+$' -- Memastikan hanya angka
--    AND b.id_pelanggan_pln !~ '^(.)\1*$' -- Tidak semua angka sama
--    AND length(b.id_pelanggan_pln) = 12 -- Panjangnya harus 12 digit
--    AND b.id_pelanggan_pln NOT LIKE '0%' -- Tidak boleh diawali dengan angka 0
GROUP BY
    a.tx_site_id,
    b.id_pelanggan_pln,
    c.siteid,
    c.idpel
order by a.tx_site_id asc;