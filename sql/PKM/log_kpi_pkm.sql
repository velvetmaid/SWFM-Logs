select
    *
from
    wfm_schema.tm_kpi_group_v2 tkgv;

select
    *
from
    wfm_schema.tm_kpi_sow_v2 tksv;

-- Get KPI list (looping in sync: KPI_SyncDataById)
SELECT
    *
FROM
    wfm_schema.tx_kpi_header_v2 kpi_header
    LEFT JOIN wfm_schema.tx_kpi_type_v2 kpi_type ON kpi_type.kpi_header = kpi_header.id
    LEFT JOIN wfm_schema.tx_kpi_detail_v2 kpi_detail ON kpi_detail.tx_kpi_type = kpi_type.id
WHERE
    kpi_header.status = 'DRAFT'
    OR kpi_header.status = 'REJECT'
    AND kpi_type.code = 'PLN'
ORDER BY
    kpi_detail.tx_kpi_group ASC,
    kpi_detail.seq ASC;

-- Get tx KPI Type
select
    *
from
    wfm_schema.tx_kpi_type_v2 xtype
    left join wfm_schema.tm_kpi_type_v2 mtype on xtype.tm_kpi_type = mtype.id
where
    mtype.type_kpi_code = 'PLN';

-- Get list of type KPI code
select distinct
    (mtype.type_kpi_code)
from
    wfm_schema.tx_kpi_type_v2 xtype
    left join wfm_schema.tm_kpi_type_v2 mtype on xtype.tm_kpi_type = mtype.id;

select distinct
    (status)
from
    wfm_schema.tx_kpi_type_v2;

-- Count LOCKED xtype status
select
    count(*)
from
    wfm_schema.tx_kpi_type_v2 xtype
    left join wfm_schema.tm_kpi_type_v2 mtype on xtype.tm_kpi_type = mtype.id
    inner join wfm_schema.tx_kpi_header_v2 kpiheader on xtype.kpi_header = kpiheader.id
where
    mtype.type_kpi_code = 'PLN'
    and xtype.status = 'LOCKED'
    and kpiheader.year_period = 2024
    and kpiheader.month_period between 7 and 10;

-- Get KPI that has been LOCKED
-- Status: DONE
select
    *
from
    wfm_schema.tx_kpi_type_v2 xtype
    left join wfm_schema.tm_kpi_type_v2 mtype on xtype.tm_kpi_type = mtype.id
    inner join wfm_schema.tx_kpi_header_v2 kpiheader on xtype.kpi_header = kpiheader.id
where
    mtype.type_kpi_code = 'PLN'
    and xtype.status = 'LOCKED'
    and kpiheader.year_period = 2024
    and kpiheader.month_period between 7 and 10
order by
    xtype.id asc,
    kpiheader.month_period asc;

-- Update LOCKED PLN KPI to DRAFT
-- Status: DONE
UPDATE wfm_schema.tx_kpi_type_v2
SET
    status = 'DRAFT'
WHERE
    tm_kpi_type IN (
        SELECT
            mtype.id
        FROM
            wfm_schema.tm_kpi_type_v2 mtype
            INNER JOIN wfm_schema.tx_kpi_header_v2 kpiheader ON wfm_schema.tx_kpi_type_v2.kpi_header = kpiheader.id
        WHERE
            mtype.type_kpi_code = 'PLN'
            AND wfm_schema.tx_kpi_type_v2.status = 'LOCKED'
            AND kpiheader.year_period = 2024
            AND kpiheader.month_period BETWEEN 7 AND 10
    );

-- Get KPI detail list data
select
    *
from
    wfm_schema.tx_kpi_detail_v2 detail
    left join wfm_schema.tx_kpi_detail_listdata_v2 detail_list on detail.id = detail_list.tx_kpi_detail
where
    detail.tm_kpi_sow = 34;

-- Get KPI detail list data with header id
select
    *
from
    wfm_schema.tx_kpi_detail_v2 detail
    left join wfm_schema.tx_kpi_detail_listdata_v2 detail_list on detail.id = detail_list.tx_kpi_detail
    inner join wfm_schema.tx_kpi_header_v2 header on detail.kpi_header = header.id
where
    detail.tm_kpi_sow = 34;

select
    *
from
    wfm_schema.tx_kpi_type_v2 xtype
    left join wfm_schema.tm_kpi_type_v2 mtype on xtype.tm_kpi_type = mtype.id
where
    mtype.type_kpi_code = 'PLN';

select
    *
from
    wfm_schema.tm_kpi_group_v2 tkgv;

select
    *
from
    wfm_schema.tx_kpi_type_v2 tktv;

-- Get KPI tx group by type code 
-- (Combined: GetKPIGroup & GetKPIType)
select
    *
from
    wfm_schema.tx_kpi_group_v2 xgroup
    inner join wfm_schema.tx_kpi_header_v2 xheader on xgroup.kpi_header = xheader.id
    inner join wfm_schema.tx_kpi_type_v2 xtype on xgroup.tx_kpi_type = xtype.id
    left join wfm_schema.tm_kpi_type_v2 mtype on xtype.tm_kpi_type = mtype.id
where
    mtype.type_kpi_code = 'PLN'
    and (xheader.month_period between 7 and 10)
    and xheader.year_period = 2024;

-- Update optional config for KPI group based on type code
-- (Combined: GetKPIGroup & GetKPIType)
-- Status: Done
UPDATE wfm_schema.tx_kpi_group_v2 xgroup
SET
    optional_config = '{"code":"PLN", "isEnableTotal":"False", "isEnableTarget":"True"}'
FROM
    (
        SELECT
            xgroup.id as xgroup_id,
            xgroup.kpi_header,
            xgroup.tx_kpi_type
        FROM
            wfm_schema.tx_kpi_group_v2 xgroup
            INNER JOIN wfm_schema.tx_kpi_header_v2 xheader ON xgroup.kpi_header = xheader.id
            INNER JOIN wfm_schema.tx_kpi_type_v2 xtype ON xgroup.tx_kpi_type = xtype.id
            LEFT JOIN wfm_schema.tm_kpi_type_v2 mtype ON xtype.tm_kpi_type = mtype.id
        WHERE
            mtype.type_kpi_code = 'PLN'
            AND xheader.year_period = 2024
            AND xheader.month_period BETWEEN 7 AND 10
    ) subquery
WHERE
    xgroup.id = subquery.xgroup_id;

-- Get KPI SOW & group PLN 
-- Status: Done
select
    *
from
    wfm_schema.tm_kpi_sow_v2 tksv
    left join wfm_schema.tm_kpi_group_v2 tkgv on tksv.kpi_group = tkgv.id
where
    tkgv.id = 4;

select
    *
from
    wfm_schema.tx_kpi_header_v2 tkhv
where
    month_period = 7
    and year_period = 2024;

select
    *
from
    wfm_schema.tx_kpi_group_v2 tkgv;

select
    tkgv.*,
    tkhv.*,
    tktv.*
from
    wfm_schema.tx_kpi_group_v2 tkgv
    inner join wfm_schema.tx_kpi_header_v2 tkhv on tkgv.kpi_header = tkhv.id
    inner join wfm_schema.tx_kpi_type_v2 tktv on tkgv.tx_kpi_type = tktv.id;

select
    *
from
    wfm_schema.tx_kpi_type_v2 tktv
    inner join wfm_schema.tx_kpi_header_v2 tkhv on tktv.kpi_header = tkhv.id
    inner join wfm_schema.tx_kpi_group_v2 tkgv on tkgv.kpi_header = tkhv.id
where
    tktv.code = 'PLN'
    and tkhv.month_period = 7
    and tkhv.year_period = 2024
    --
select
    *
from
    wfm_schema.tm_kpi_sow_v2 tksv;

select
    *
from
    wfm_schema.tx_kpi_detail_v2 tkdv;

select
    *
from
    wfm_schema.tx_kpi_detail_listdata_v2 tkdlv;

SELECT
    *
FROM
    wfm_schema.tm_kpi_sow_v2
where
    kpi_group = 4;

SELECT
    *
FROM
    wfm_schema.tm_kpi_group_v2;

select
    *
from
    wfm_schema.tx_kpi_type_v2;

select
    *
from
    wfm_schema.tx_kpi_group_v2 tkgv
where
    tm_kpi_group = 4;

select
    *
from
    wfm_schema.tx_recap_pln trp
    inner join wfm_schema.tx_site ts on trp.site_id = ts.site_id
where
    ts.nop_id = 'NOP1';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
;

select
    *
from
    wfm_schema.tx_kpi_detail_v2 tkdv
where
    kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    *
from
    wfm_schema.tx_kpi_group_v2 tkgv
where
    kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    *
from
    wfm_schema.tx_kpi_header_v2 tkhv
where
    id = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
from
    wfm_schema.tx_kpi_header_v2 tkhv
    left join wfm_schema.tx_kpi_type_v2 tktv on tktv.kpi_header = tkhv.id
    left join wfm_schema.tx_kpi_detail_v2 tkdv on tkdv.tx_kpi_type = tktv.id
where
    tkdv.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    *
from
    wfm_schema.tx_kpi_detail_v2 tkdv
where
    kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    *
from
    wfm_schema.tx_kpi_header_v2 tkhv
where
    id = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    *
from
    wfm_schema.tx_kpi_detail_v2 tkdv
where
    kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    *
from
    wfm_schema.tx_kpi_detail_v2 tkdv
    left join wfm_schema.tx_kpi_detail_listdata_v2 tkdlv on tkdv.id = tkdlv.tx_kpi_detail
where
    tkdv.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

select
    b.*
from
    wfm_schema.tx_kpi_group_v2 a
    inner join wfm_schema.tx_kpi_detail_v2 b on a.id = b.tx_kpi_group
    inner join wfm_schema.tm_kpi_sow_v2 c on a.tm_kpi_group = c.kpi_group
where
    a.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'
    and a.tm_kpi_group = 4;

select
    *
from
    wfm_schema.tx_kpi_detail_v2 a
    inner join wfm_schema.tx_kpi_type_v2 b on a.kpi_header = b.kpi_header
where
    a.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'
    and (
        a.tm_kpi_sow = 33
        or a.tm_kpi_sow = 35
    )
    and b.code = 'PLN';

SELECT
    b.kpi_header,
    b.code,
    b.score_kpi,
    a.score_final
FROM
    wfm_schema.tx_kpi_type_v2 b
    JOIN wfm_schema.tx_kpi_detail_v2 a ON b.kpi_header = a.kpi_header
WHERE
    b.code = 'PLN'
    AND a.tm_kpi_sow IN (33, 35)
    AND a.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e';

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
;

update wfm_schema.tx_kpi_detail_v2
set
    total = 0.0,
    pencapaian = 0.0,
    score_pencapaian = 100.0000,
    score_final = 70.000
where
    tm_kpi_sow = 35;

UPDATE wfm_schema.tx_kpi_type_v2 b
SET
    score_kpi = (
        SELECT
            SUM(a.score_final)
        FROM
            wfm_schema.tx_kpi_detail_v2 a
        WHERE
            a.kpi_header = b.kpi_header
            AND a.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'
            AND (
                a.tm_kpi_sow = 33
                OR a.tm_kpi_sow = 35
            )
    )
WHERE
    b.kpi_header = 'd75ed44e-b5e5-4b6f-8714-6e650f490b5e'
    AND b.code = 'PLN';

UPDATE wfm_schema.tx_kpi_type_v2 b
SET
    score_kpi = subquery.total_score
FROM
    (
        SELECT
            a.kpi_header,
            SUM(a.score_final) AS total_score
        FROM
            wfm_schema.tx_kpi_detail_v2 a
        WHERE
            a.tm_kpi_sow IN (33, 35)
        GROUP BY
            a.kpi_header
    ) AS subquery
WHERE
    b.kpi_header = subquery.kpi_header
    AND b.code = 'PLN';

UPDATE wfm_schema.tx_kpi_type_v2 b
SET
    score_kpi = subquery.total_score
FROM
    (
        SELECT
            a.kpi_header,
            SUM(a.score_final) AS total_score
        FROM
            wfm_schema.tx_kpi_detail_v2 a
            INNER JOIN wfm_schema.tm_kpi_scoring_v2 c ON b.tm_kpi_type = c.tm_kpi_type
        WHERE
            a.tm_kpi_sow IN (33, 34, 35)
            AND c.is_active = true
            and total_score >= c.min_value
            and total_score < c.max_value
    ) AS subquery
WHERE
    b.kpi_header = subquery.kpi_header
    AND b.code = 'PLN';

UPDATE wfm_schema.tx_kpi_type_v2 b
SET
    score_kpi = subquery.total_score,
    score_category = subquery.category_name
FROM
    (
        SELECT
            a.kpi_header,
            SUM(a.score_final) AS total_score,
            c.category_name,
            c.min_value,
            c.max_value
        FROM
            wfm_schema.tx_kpi_detail_v2 a
            INNER JOIN wfm_schema.tx_kpi_type_v2 b ON a.kpi_header = b.kpi_header
            INNER JOIN wfm_schema.tm_kpi_scoring_v2 c ON b.tm_kpi_type = c.tm_kpi_type
        WHERE
            a.tm_kpi_sow IN (33, 34, 35)
            AND c.is_active = true
        GROUP BY
            a.kpi_header,
            c.category_name,
            c.min_value,
            c.max_value
    ) AS subquery
WHERE
    b.kpi_header = subquery.kpi_header
    AND b.code = 'PLN'
    AND subquery.total_score >= subquery.min_value
    AND subquery.total_score < subquery.max_value;