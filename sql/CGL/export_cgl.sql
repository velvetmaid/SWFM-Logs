select
    row_number() over(
        order by
            (
                select
                    null
            )
    ),
    txc.created_at,
    txc.ticket_no,
    txc.site_id,
    ts.site_name,
    to_char(txc.incident_date, 'YYYY-MM-DD') as incident_date,
    to_char(txc.incident_date, 'Month') as incident_month,
    to_char(txc.incident_date, 'YYYY') as incident_year,
    age(txc.incident_date, current_date) as incident_age,
    tr.regional_name,
    ta.area_name,
    tn.nop_name,
    tc.cluster_name,
    -- vendor_enom,
    txc.status,
    txc.daisy_number,
    (
        SELECT
            COUNT(*)
        FROM
            {tx_cgl_residents_data_warga} txcrdw
        WHERE
            txcrdw.ticket_no = txc.ticket_no
    ) AS jumlah_warga,
    (
        SELECT
            COUNT(*)
        FROM
            {tx_cgl_residents_barang} txcrb
        WHERE
            txcrb.ticket_no = txc.ticket_no
    ) AS jumlah_barang,
    (
        SELECT
            SUM(txcrb.estimation_price)
        FROM
            {tx_cgl_residents_barang} txcrb
        WHERE
            txcrb.ticket_no = txc.ticket_no
    ) AS total_estimation_boq,
    (
        SELECT
            SUM(txcrb.estimation_price)
        FROM
            {tx_cgl_residents_barang} txcrb
        WHERE
            txcrb.ticket_no = txc.ticket_no
    ) AS total_approved_boq
from
    {tx_cgl} txc
    left join {tx_site} ts on ts.site_id = txc.site_id
    left join {tm_area} ta on ta.area_id = ts.area_id
    left join {tm_regional} tr on tr.regional_id = ts.regional_id
    left join {tm_nop} tn on tn.nop_id = ts.nop_id
    left join {tm_cluster} tm on tm.cluster_id = ts.cluster_id;

-- 
-- 
-- OS VERSION
select
    row_number() over(
        order by
            (
                select
                    null
            )
    ),
    txc.created_at,
    txc.ticket_no,
    txc.site_id,
    ts.site_name,
    to_char(txc.incident_date, 'YYYY-MM-DD') as incident_date,
    to_char(txc.incident_date, 'Month') as incident_month,
    to_char(txc.incident_date, 'YYYY') as incident_year,
    age(txc.incident_date, current_date) as incident_age,
    tr.regional_name,
    ta.area_name,
    tn.nop_name,
    tc.cluster_name,
    tc.vendor_enom,
    txc.status,
    txc.daisy_number,
    (
        SELECT
            COUNT(*)
        FROM
            {tx_cgl_residents_data_warga} txcrdw
        WHERE
            txcrdw.ticket_no = txc.ticket_no
    ) AS jumlah_warga,
    (
        SELECT
            COUNT(*)
        FROM
            {tx_cgl_residents_barang} txcrb
        WHERE
            txcrb.ticket_no = txc.ticket_no
    ) AS jumlah_barang,
    (
        SELECT
            SUM(txcrb.estimation_price)
        FROM
            {tx_cgl_residents_barang} txcrb
        WHERE
            txcrb.ticket_no = txc.ticket_no
    ) AS total_estimation_boq,
    (
        SELECT
            SUM(txcrb.estimation_price)
        FROM
            {tx_cgl_residents_barang} txcrb
        WHERE
            txcrb.ticket_no = txc.ticket_no
    ) AS total_approved_boq
from
    {tx_cgl} txc
    left join {tx_site} ts on ts.site_id = txc.site_id
    left join {tm_area} ta on ta.area_id = ts.area_id
    left join {tm_regional} tr on tr.regional_id = ts.regional_id
    left join {tm_nop} tn on tn.nop_id = ts.nop_id
    left join {tm_cluster} tm on tm.cluster_id = ts.cluster_id