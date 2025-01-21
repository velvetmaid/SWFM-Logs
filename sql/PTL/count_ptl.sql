-- Count PTL Header and Detail
select
    count(*)
from
    wfm_schema.tx_pengisian_token_listrik_header tptlh
    inner join wfm_schema.tx_pengisian_token_listrik tptl on tptlh.ticket_no = tptl.ref_ticket_no
where
    tptlh.bulan = 1
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