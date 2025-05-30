SELECT
    (
        SELECT
            count(*)
        FROM
            wfm_schema.tx_pengisian_token_listrik_header tptlh
            INNER JOIN wfm_schema.tx_pengisian_token_listrik tptl ON tptlh.ticket_no = tptl.ref_ticket_no
        WHERE
            tptlh.bulan = 4
            AND tptlh.tahun = 2025
    ) AS total_token,
    (
        SELECT
            count(*)
        FROM
            wfm_schema.tx_pengisian_token_listrik_header tptlh
        WHERE
            tptlh.bulan = 4
            AND tptlh.tahun = 2025
    ) AS total_ticket;
    
SELECT
    count(*)
FROM
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    INNER JOIN wfm_schema.tx_pengisian_token_listrik tptl ON tptlh.ticket_no = tptl.ref_ticket_no
    inner join wfm_schema.tx_site ts on tptlh.site_id = ts.site_id
WHERE
    tptlh.bulan = 4
    AND tptlh.tahun = 2025
    and not ts.is_site_sam
SELECT
    count(*)
FROM
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_site ts on tptlh.site_id = ts.site_id
WHERE
    tptlh.bulan = 4
    AND tptlh.tahun = 2025
    and not ts.is_site_sam
select
    count(*)
from
    wfm_schema.tx_site ts
    inner join wfm_schema.tm_power_pln_pelanggan_ipas tpppi on ts.site_id = tpppi.siteid
where
    billtype = 'Prepaid'
    -- Count PTL Header and Detail
SELECT
    count(*)
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
where
    tptlh.bulan = 4
    and tptlh.tahun = 2025;

SELECT
    count(*)
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
where
    tptlh.bulan = 4
    and tptlh.tahun = 2025;

-- Check PTL Detail does not have PTL Header
SELECT
    COUNT(*)
FROM
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    LEFT JOIN wfm_schema.tx_pengisian_token_listrik tptl ON tptlh.ticket_no = tptl.ref_ticket_no
WHERE
    tptlh.bulan = 1
    AND tptlh.tahun = 2025
    AND tptl.ref_ticket_no IS NULL;

-- Check PTL by Area
SELECT
    *
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
    inner join wfm_schema.tx_site ts on tptlh.site_id = ts.site_id
where
    tptlh.bulan = 2
    and tptlh.tahun = 2025
    and ts.area_id = 'Area1'
    and ts.regional_id = 'R01';

SELECT
    tx_pengisian_token_listrik_header_uso.ticket_ipas_id
FROM
    wfm_uso_schema.tx_pengisian_token_listrik_header
UNION
SELECT
    tx_pengisian_token_listrik_header.ticket_ipas_id
FROM
<<<<<<< HEAD
    wfm_schema.tx_pengisian_token_listrik_header;


-- 
SELECT site_id, id_pelanggan FROM wfm_schema.tx_pengisian_token_listrik_header
where tahun = 2025 and bulan = 5 



-- Count PTL Header and Detail
select
    tptlh.site_id, tptlh.id_pelanggan::text, tptlh.id_pelanggan_name,tptlh.ticket_ipas_id,
    tptl.billing_id, tptl.denom_prepaid, tptl.no_token 
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
where
    tptlh.bulan = 5
    and tptlh.tahun = 2025
order by tptlh.site_id;

-- Check PTL Detail does not have PTL Header
SELECT
    COUNT(*)
FROM
    wfm_schema.tx_pengisian_token_listrik_header tptlh
WHERE
    tptlh.bulan = 5
    AND tptlh.tahun = 2025;

select count(*)
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
where
    tptlh.bulan = 5
    and tptlh.tahun = 2025;
  
    
    SELECT site_id, id_pelanggan FROM wfm_schema.tx_pengisian_token_listrik_header
where tahun = 2025 and bulan = 5;



SELECT
    h.bulan,
    h.tahun,
    h.count_header AS count_ticket,
    COALESCE(d.count_detail, 0) AS count_token
FROM (
    SELECT
        bulan,
        tahun,
        COUNT(*) AS count_header
    FROM
        wfm_schema.tx_pengisian_token_listrik_header
    GROUP BY
        bulan,
        tahun
) h
LEFT JOIN (
    SELECT
        tptlh.bulan,
        tptlh.tahun,
        COUNT(*) AS count_detail
    FROM
        wfm_schema.tx_pengisian_token_listrik_header tptlh
    INNER JOIN
        wfm_schema.tx_pengisian_token_listrik tptl
        ON tptlh.ticket_no = tptl.ref_ticket_no
    GROUP BY
        tptlh.bulan,
        tptlh.tahun
) d ON h.bulan = d.bulan AND h.tahun = d.tahun
where h.bulan <> 0 or h.tahun <> 0
ORDER BY
    h.tahun,
    h.bulan;

-- Count PTL Header and Detail
select
    tptlh.site_id, tptlh.id_pelanggan::text, tptlh.id_pelanggan_name,tptlh.ticket_ipas_id,
    tptl.billing_id, tptl.denom_prepaid, tptl.no_token 
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
where
    tptlh.bulan = 5
    and tptlh.tahun = 2025
order by tptlh.site_id;

-- Check PTL Detail does not have PTL Header
SELECT
    COUNT(*)
FROM
    wfm_schema.tx_pengisian_token_listrik_header tptlh
WHERE
    tptlh.bulan = 5
    AND tptlh.tahun = 2025;

select count(*)
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
where
    tptlh.bulan = 5
    and tptlh.tahun = 2025;
  
    
    SELECT site_id, id_pelanggan FROM wfm_schema.tx_pengisian_token_listrik_header
where tahun = 2025 and bulan = 5;



SELECT
    h.bulan,
    h.tahun,
    h.count_header AS count_ticket,
    COALESCE(d.count_detail, 0) AS count_token
FROM (
    SELECT
        bulan,
        tahun,
        COUNT(*) AS count_header
    FROM
        wfm_schema.tx_pengisian_token_listrik_header
    GROUP BY
        bulan,
        tahun
) h
LEFT JOIN (
    SELECT
        tptlh.bulan,
        tptlh.tahun,
        COUNT(*) AS count_detail
    FROM
        wfm_schema.tx_pengisian_token_listrik_header tptlh
    INNER JOIN
        wfm_schema.tx_pengisian_token_listrik tptl
        ON tptlh.ticket_no = tptl.ref_ticket_no
    GROUP BY
        tptlh.bulan,
        tptlh.tahun
) d ON h.bulan = d.bulan AND h.tahun = d.tahun
where h.bulan <> 0 or h.tahun <> 0
ORDER BY
    h.tahun,
    h.bulan;
    
   
   
   select
    CASE h.bulan
        WHEN 1 THEN 'Januari'
        WHEN 2 THEN 'Februari'
        WHEN 3 THEN 'Maret'
        WHEN 4 THEN 'April'
        WHEN 5 THEN 'Mei'
        WHEN 6 THEN 'Juni'
        WHEN 7 THEN 'Juli'
        WHEN 8 THEN 'Agustus'
        WHEN 9 THEN 'September'
        WHEN 10 THEN 'Oktober'
        WHEN 11 THEN 'November'
        WHEN 12 THEN 'Desember'
    end || '(' || h.bulan || ')' as bulan,
    h.tahun,
    h.count_header AS count_ticket,
    COALESCE(d.count_detail, 0) AS count_token
FROM (
    SELECT
        bulan,
        tahun,
        COUNT(*) AS count_header
    FROM
        wfm_schema.tx_pengisian_token_listrik_header
    GROUP BY
        bulan,
        tahun
) h
LEFT JOIN (
    SELECT
        tptlh.bulan,
        tptlh.tahun,
        COUNT(*) AS count_detail
    FROM
        wfm_schema.tx_pengisian_token_listrik_header tptlh
    INNER JOIN
        wfm_schema.tx_pengisian_token_listrik tptl
        ON tptlh.ticket_no = tptl.ref_ticket_no
    GROUP BY
        tptlh.bulan,
        tptlh.tahun
) d ON h.bulan = d.bulan AND h.tahun = d.tahun
WHERE h.bulan <> 0 OR h.tahun <> 0
ORDER BY h.tahun, h.bulan;


select * from wfm_schema.tx_pengisian_token_listrik_header tptlh 
where tahun = 0
=======
    wfm_schema.tx_pengisian_token_listrik_header




select tptlh.ticket_no, tptlh.ticket_ipas_id, tptlh.id_pelanggan, tptlh.id_pelanggan_name,
tptlh.site_id, ts.site_name, upper(ts.area_id) as area_name, tr.regional_name, tn.nop_name, tc.cluster_name,
tptlh.status, tptlh.bulan, tptlh.tahun, tptl.billing_id, tptl.no_token, 
tptl.denom_prepaid from wfm_schema.tx_pengisian_token_listrik_header tptlh 
inner join wfm_schema.tx_pengisian_token_listrik tptl 
on tptlh.ticket_no = tptl.ref_ticket_no
left join wfm_schema.tx_site ts 
on tptlh.site_id = ts.site_id 
left join wfm_schema.tm_regional tr 
on ts.regional_id = tr.regional_id 
left join wfm_schema.tm_nop tn 
on ts.nop_id = tn.nop_id 
left join wfm_schema.tm_cluster tc 
on ts.cluster_id = tc.cluster_id 
where tptlh.bulan = 4 and tptlh.tahun = 2025
order by tptlh.ticket_no 
>>>>>>> 94a6c3d9b95b8a5d1d460d154bc031c3b81dfc7f
