-- 1. Data all user MBP/TS, data Clock in Clock Out (daily)	
-- tx_terr_opr
-- tx_user_mobile_management
-- tx_location_device
-- tx_absen
-- 2. Data Transaksi Tiket INAP	
-- Tx_inap_header
-- tx_inap_ext,
-- tx_ticket_terr_opr
-- tx_ticket_terr_opr_ext
-- 3. Data KPI ,pengolahan data reportnya oleh tim dashboard	
-- tx_kpi_header_v2 
-- tx_kpi_detail_listdata_v2 
-- tx_kpi_group_v2
-- tx_kpi_detail_v2 
-- tx_kpi_type_v2"
-- 4. Data FNA	
-- ticket_technical_support
-- tx_ticket_terr_opr
SELECT
    *
FROM
    wfm_schema.tx_ticket_terr_opr ttto
WHERE
    EXTRACT(
        YEAR
        FROM
            ttto.created_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            ttto.created_at
    ) BETWEEN 6
    AND 9
ORDER BY
    ttto.tx_ticket_terr_opr_id ASC;

-- tx_user_mobile_management
SELECT
    *
FROM
    wfm_schema.tx_user_mobile_management a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.created_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.created_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.tx_user_management_id ASC;

-- tx_location_device
SELECT
    *
FROM
    wfm_schema.tx_location_device a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.currenttime
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.currenttime
    ) BETWEEN 6
    AND 9
ORDER BY
    a.currenttime ASC;

-- tx_absen
SELECT
    *
FROM
    wfm_schema.tx_absen a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.absendate
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.absendate
    ) BETWEEN 6
    AND 9
ORDER BY
    a.id ASC;

-- tx_inap_header
SELECT
    *
FROM
    wfm_schema.tx_inap_header a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.created_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.created_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.created_at ASC;

-- tx_inap_ext done
SELECT
    *
FROM
    wfm_schema.tx_inap_ext a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.created_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.created_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.created_at ASC;

-- tx_ticket_terr_opr_ext done
SELECT
    *
FROM
    wfm_schema.tx_ticket_terr_opr_ext a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.clear_on
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.clear_on
    ) BETWEEN 6
    AND 9
ORDER BY
    a.clear_on ASC;

-- tx_kpi_header_v2 done
SELECT
    *
FROM
    wfm_schema.tx_kpi_header_v2
WHERE
    year_period = 2024
    and month_period BETWEEN 6
    AND 9
ORDER BY
    month_period ASC;

-- tx_kpi_detail_listdata_v2 done
SELECT
    *
FROM
    wfm_schema.tx_kpi_detail_listdata_v2 a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.modified_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.modified_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.id ASC;

-- tx_kpi_group_v2 done
SELECT
    *
FROM
    wfm_schema.tx_kpi_group_v2 a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.modified_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.modified_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.id ASC;

-- tx_kpi_detail_v2 done
SELECT
    *
FROM
    wfm_schema.tx_kpi_detail_v2 a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.modified_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.modified_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.id ASC;

-- tx_kpi_type_v2 done
SELECT
    *
FROM
    wfm_schema.tx_kpi_type_v2 a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.modified_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.modified_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.id ASC;

-- ticket_technical_support done
SELECT
    *
FROM
    wfm_schema.ticket_technical_support a
WHERE
    EXTRACT(
        YEAR
        FROM
            a.created_at
    ) = 2024
    AND EXTRACT(
        MONTH
        FROM
            a.created_at
    ) BETWEEN 6
    AND 9
ORDER BY
    a.created_at ASC;