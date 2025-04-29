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
    ) AS total_ticket
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
    wfm_schema.tx_pengisian_token_listrik_header