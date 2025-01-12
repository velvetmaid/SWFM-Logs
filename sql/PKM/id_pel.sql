-- wfm_schema.tm_power_pln_pelanggan_ipas definition
-- Drop table
-- DROP TABLE wfm_schema.tm_power_pln_pelanggan_ipas;
CREATE TABLE wfm_schema.tm_power_pln_pelanggan_ipas (
    tm_power_pln_pelanggan_ipas_id SERIAL PRIMARY KEY,
    idpel varchar(255),
    pelname varchar(255),
    goltarif varchar(255),
    daya varchar(25),
    billtype varchar(255),
    plafond numeric(12, 2),
    siteid varchar(255),
    sitename varchar(255),
    regional varchar(255),
    nsa varchar(255),
    rtpo varchar(255),
    statussite varchar(255),
    tower varchar(255),
    statusidpel varchar(255),
    tx_request_powerid BIGINT,
    tm_powerid BIGINT UNIQUE,
    area varchar(255),
    billresponsibility varchar(255),
    siteowner varchar(255)
);

update
    wfm_schema.tm_power_pln_pelanggan_ipas
SET
    daya = REGEXP_REPLACE(daya, '[^\d]', '', 'g')
WHERE
    daya ~ '\d';

SELECT
    a.tx_site_id,
    b.id_pelanggan_pln
FROM
    wfm_schema.tx_pm_ticket_site a
    INNER JOIN wfm_schema.tx_pm_site_power_pln b ON a.pm_ticket_site_id = b.tx_pm_ticket_site_id
WHERE
    b.id_pelanggan_pln ~ '^\d+$'
    AND b.id_pelanggan_pln !~ '^(.)\1*$'
    AND length(b.id_pelanggan_pln) = 12
    AND b.id_pelanggan_pln NOT LIKE '0%'
GROUP BY
    a.tx_site_id,
    b.id_pelanggan_pln;

SELECT
    a.tx_site_id as site_id_pm,
    b.id_pelanggan_pln as idpel_pm,
    c.siteid as site_id_ipas,
    c.idpel as idpel_ipas
FROM
    wfm_schema.tx_pm_ticket_site a
    INNER JOIN wfm_schema.tx_pm_site_power_pln b ON a.pm_ticket_site_id = b.tx_pm_ticket_site_id
    left join wfm_schema.tm_power_pln_pelanggan_ipas c on a.tx_site_id = c.siteid
WHERE
    b.id_pelanggan_pln ~ '^\d+$' -- Memastikan hanya angka
    AND b.id_pelanggan_pln !~ '^(.)\1*$' -- Tidak semua angka sama
    AND length(b.id_pelanggan_pln) = 12 -- Panjangnya harus 12 digit
    AND b.id_pelanggan_pln NOT LIKE '0%' -- Tidak boleh diawali dengan angka 0
GROUP BY
    a.tx_site_id,
    b.tx_pm_site_power_pln_id,
    c.tm_power_pln_pelanggan_ipas_id;

-- 
-- 
-- 
SELECT
    b.tx_site_id as site_id_pm,
    c.id_pelanggan_pln as idpel_pm,
    a.siteid as site_id_ipas,
    a.idpel as idpel_ipas
FROM
    wfm_schema.tm_power_pln_pelanggan_ipas a
    LEFT JOIN wfm_schema.tx_pm_ticket_site b ON a.siteid = b.tx_site_id
    INNER JOIN wfm_schema.tx_pm_site_power_pln c ON b.pm_ticket_site_id = c.tx_pm_ticket_site_id
WHERE
    c.id_pelanggan_pln ~ '^\d+$' -- Memastikan hanya angka
    AND c.id_pelanggan_pln !~ '^(.)\1*$' -- Tidak semua angka sama
    AND length(c.id_pelanggan_pln) = 12 -- Panjangnya harus 12 digit
    AND c.id_pelanggan_pln NOT LIKE '0%' -- Tidak boleh diawali dengan angka 0
GROUP BY
    a.tm_power_pln_pelanggan_ipas_id,
    b.tx_site_id,
    c.tx_pm_site_power_pln_id;

-- 
-- 
-- 
SELECT
    COUNT(*)
FROM
    (
        SELECT
            b.tx_site_id as site_id_pm,
            c.id_pelanggan_pln as idpel_pm,
            a.siteid as site_id_ipas,
            a.idpel as idpel_ipas
        FROM
            wfm_schema.tm_power_pln_pelanggan_ipas a
            LEFT JOIN wfm_schema.tx_pm_ticket_site b ON a.siteid = b.tx_site_id
            INNER JOIN wfm_schema.tx_pm_site_power_pln c ON b.pm_ticket_site_id = c.tx_pm_ticket_site_id
        WHERE
            c.id_pelanggan_pln ~ '^\d+$' -- Memastikan hanya angka
            AND c.id_pelanggan_pln !~ '^(.)\1*$' -- Tidak semua angka sama
            AND length(c.id_pelanggan_pln) = 12 -- Panjangnya harus 12 digit
            AND c.id_pelanggan_pln NOT LIKE '0%' -- Tidak boleh diawali dengan angka 0
        GROUP BY
            a.tm_power_pln_pelanggan_ipas_id,
            b.tx_site_id,
            c.tx_pm_site_power_pln_id
    ) AS subquery;

SELECT
    b.tx_site_id as site_id_pm,
    c.id_pelanggan_pln as idpel_pm,
    a.siteid as site_id_ipas,
    a.idpel as idpel_ipas
FROM
    wfm_schema.tm_power_pln_pelanggan_ipas a
    LEFT JOIN wfm_schema.tx_pm_ticket_site b ON a.idpel = c.id_pelanggan_pln
    INNER JOIN wfm_schema.tx_pm_site_power_pln c ON b.pm_ticket_site_id = c.tx_pm_ticket_site_id
GROUP BY
    a.tm_power_pln_pelanggan_ipas_id,
    b.tx_site_id,
    c.tx_pm_site_power_pln_id;

SELECT
    a.siteid AS site_id_ipas,
    a.idpel AS idpel_ipas,
    b.tx_site_id AS site_id_pm,
    c.id_pelanggan_pln AS idpel_pm
FROM
    wfm_schema.tm_power_pln_pelanggan_ipas a
    LEFT JOIN wfm_schema.tx_pm_site_power_pln c ON a.idpel = c.id_pelanggan_pln
    INNER JOIN wfm_schema.tx_pm_ticket_site b ON b.pm_ticket_site_id = c.tx_pm_ticket_site_id
GROUP BY
    a.siteid,
    a.idpel,
    b.tx_site_id,
    c.id_pelanggan_pln;

-- 
-- 
SELECT
    a.siteid AS site_id_ipas,
    a.idpel AS idpel_ipas,
    b.tx_site_id AS site_id_pm,
    c.id_pelanggan_pln AS idpel_pm,
    a.statusidpel,
    a.billtype,
    d.is_active
FROM
    wfm_schema.tm_power_pln_pelanggan_ipas a
    LEFT JOIN wfm_schema.tx_pm_site_power_pln c ON a.idpel = c.id_pelanggan_pln
    LEFT JOIN wfm_schema.tx_pm_ticket_site b ON b.pm_ticket_site_id = c.tx_pm_ticket_site_id
    left join wfm_schema.tx_site d on b.tx_site_id = d.site_id
GROUP BY
    a.tm_power_pln_pelanggan_ipas_id,
    b.tx_site_id,
    c.tx_pm_site_power_pln_id,
    d.site_id;