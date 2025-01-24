select * from wfm_schema.tx_kpi_header_v2 tkhv 
where month_period = 7 and year_period = 2024;

select * from wfm_schema.tx_kpi_group_v2 tkgv; 

select tkgv.*, tkhv.*, tktv.* from wfm_schema.tx_kpi_group_v2 tkgv 
inner join wfm_schema.tx_kpi_header_v2 tkhv 
on tkgv.kpi_header = tkhv.id 
inner join wfm_schema.tx_kpi_type_v2 tktv 
on tkgv.tx_kpi_type = tktv.id;

select * from wfm_schema.tx_kpi_type_v2 tktv 
inner join wfm_schema.tx_kpi_header_v2 tkhv 
on tktv.kpi_header = tkhv.id 
inner join wfm_schema.tx_kpi_group_v2 tkgv 
on tkgv.kpi_header = tkhv.id 
where tktv.code = 'PLN' and tkhv.month_period = 7 and tkhv.year_period = 2024

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