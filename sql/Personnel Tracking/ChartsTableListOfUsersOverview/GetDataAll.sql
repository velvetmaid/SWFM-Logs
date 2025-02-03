SELECT
    combined_ticket.tx_user_mobile_management_id,
    combined_ticket.employee_name,
    MAX(
        CASE
            WHEN source = 'INAP' THEN ticket_no
            ELSE NULL
        END
    ) AS inap_ticket_no,
    MAX(
        CASE
            WHEN source = 'SVA' THEN ticket_no
            ELSE NULL
        END
    ) AS sva_ticket_no,
    MAX(
        CASE
            WHEN source = 'PM' THEN ticket_no
            ELSE NULL
        END
    ) AS pm_ticket_no,
    MAX(
        CASE
            WHEN source = 'FNA' THEN ticket_no
            ELSE NULL
        END
    ) AS fna_ticket_no,
    SUM(
        CASE
            WHEN source = 'INAP' THEN inap_ticket_count
            ELSE 0
        END
    ) AS inap_ticket_count,
    SUM(
        CASE
            WHEN source = 'SVA' THEN sva_ticket_count
            ELSE 0
        END
    ) AS sva_ticket_count,
    SUM(
        CASE
            WHEN source = 'PM' THEN pm_ticket_count
            ELSE 0
        END
    ) AS pm_ticket_count,
    SUM(
        CASE
            WHEN source = 'FNA' THEN fna_ticket_count
            ELSE 0
        END
    ) AS fna_ticket_count,
    SUM(ticket_count) AS total_ticket_count
FROM
    (
        SELECT
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            inap.status,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            'INAP' AS source,
            string_agg(inap.ticket_no, ', ') AS ticket_no,
            inap.created_at :: date,
            inap.take_over_at :: date,
            inap.checkin_at :: date,
            COUNT(*) AS inap_ticket_count,
            0 AS sva_ticket_count,
            0 AS pm_ticket_count,
            0 AS fna_ticket_count,
            COUNT(*) AS ticket_count
        FROM
            {tx_user_mobile_management} tumm
            INNER JOIN {tx_ticket_terr_opr} inap ON tumm.tx_user_mobile_management_id :: varchar = inap.pic_id
        WHERE 
            (
                (tumm.area_id = @Area OR @Area = '') AND
                (tumm.regional_id = @Regional OR @Regional = '') AND
                (tumm.nop_id = @NOP OR @NOP = '') AND
                (tumm.cluster_id = @Cluster OR @Cluster = 0)
            ) AND 
            (
                (@StartDate = '1900-01-01' AND @EndDate = '1900-01-01') OR
                (inap.created_at BETWEEN @StartDate AND @EndDate)
            )           
        GROUP BY
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            inap.status,
            inap.created_at,
            inap.take_over_at,
            inap.checkin_at
        UNION
        ALL
        SELECT
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            sva.status,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            'SVA' AS source,
            string_agg(sva.ticket_no, ', ') AS ticket_no,
            sva.created_at :: date,
            sva.take_over_at :: date,
            sva.checkin_at :: date,
            0 AS inap_ticket_count,
            COUNT(*) AS sva_ticket_count,
            0 AS pm_ticket_count,
            0 AS fna_ticket_count,
            COUNT(*) AS ticket_count
        FROM
            {tx_user_mobile_management} tumm
            INNER JOIN {tx_cmsite_header} sva ON tumm.tx_user_mobile_management_id :: varchar = sva.pic_id
        WHERE 
            (
                (tumm.area_id = @Area OR @Area = '') AND
                (tumm.regional_id = @Regional OR @Regional = '') AND
                (tumm.nop_id = @NOP OR @NOP = '') AND
                (tumm.cluster_id = @Cluster OR @Cluster = 0)
            ) AND 
            (
                (@StartDate = '1900-01-01' AND @EndDate = '1900-01-01') OR
                (sva.created_at BETWEEN @StartDate AND @EndDate)
            )
        GROUP BY
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            sva.status,
            sva.created_at,
            sva.take_over_at,
            sva.checkin_at
        UNION
        ALL
        SELECT
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            pm.status,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            'PM' AS source,
            string_agg(pm.pm_ticket_site_id, ', ') AS ticket_no,
            pm.created_at :: date,
            pm.take_over_at :: date,
            pm.checkin_at :: date,
            0 AS inap_ticket_count,
            0 AS sva_ticket_count,
            COUNT(*) AS pm_ticket_count,
            0 AS fna_ticket_count,
            COUNT(*) AS ticket_count
        FROM
            {tx_user_mobile_management} tumm
            INNER JOIN {tx_pm_ticket_site} pm ON tumm.tx_user_mobile_management_id :: varchar = pm.pic_id
        WHERE 
            (
                (tumm.area_id = @Area OR @Area = '') AND
                (tumm.regional_id = @Regional OR @Regional = '') AND
                (tumm.nop_id = @NOP OR @NOP = '') AND
                (tumm.cluster_id = @Cluster OR @Cluster = 0)
            ) AND 
            (
                (@StartDate = '1900-01-01' AND @EndDate = '1900-01-01') OR
                (pm.created_at BETWEEN @StartDate AND @EndDate)
            )
       GROUP BY
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            pm.status,
            pm.created_at,
            pm.take_over_at,
            pm.checkin_at
        UNION
        ALL
        SELECT
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            fna.status,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            'FNA' AS source,
            string_agg(fna.no_ticket, ', ') AS ticket_no,
            fna.created_at :: date,
            fna.take_over_at :: date,
            fna.checkin_at :: date,
            0 AS inap_ticket_count,
            0 AS sva_ticket_count,
            0 AS pm_ticket_count,
            COUNT(*) AS fna_ticket_count,
            COUNT(*) AS ticket_count
        FROM
            {tx_user_mobile_management} tumm
            INNER JOIN {ticket_technical_support} fna ON tumm.tx_user_mobile_management_id :: varchar = fna.pic_id
        WHERE 
            (
                (tumm.area_id = @Area OR @Area = '') AND
                (tumm.regional_id = @Regional OR @Regional = '') AND
                (tumm.nop_id = @NOP OR @NOP = '') AND
                (tumm.cluster_id = @Cluster OR @Cluster = 0)
            ) AND 
            (
                (@StartDate = '1900-01-01' AND @EndDate = '1900-01-01') OR
                (fna.created_at BETWEEN @StartDate AND @EndDate)
            )
        GROUP BY
            tumm.tx_user_mobile_management_id,
            tumm.employee_name,
            fna.status,
            fna.created_at,
            fna.take_over_at,
            fna.checkin_at
    ) AS combined_ticket
GROUP BY
    combined_ticket.tx_user_mobile_management_id,
    combined_ticket.employee_name;