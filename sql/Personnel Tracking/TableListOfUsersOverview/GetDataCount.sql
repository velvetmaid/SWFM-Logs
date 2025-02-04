-- with site
SELECT COUNT(*)
FROM (
    SELECT 
        combined_ticket.tx_user_mobile_management_id,
        combined_ticket.employee_name,
        combined_ticket.status,
        combined_ticket.created_at,
        combined_ticket.take_over_at,
        combined_ticket.checkin_at,
        combined_ticket.site_id,
        combined_ticket.area_id,
        combined_ticket.regional_id,
        combined_ticket.nop_id,
        combined_ticket.cluster_id
    FROM (
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            inap.status, 
            inap.created_at :: date,
            inap.take_over_at :: date,
            inap.checkin_at :: date,
            inap_site.site_id,
            inap_site.area_id,
            inap_site.regional_id,
            inap_site.nop_id,
            inap_site.cluster_id
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {tx_ticket_terr_opr} inap
            ON tumm.tx_user_mobile_management_id::varchar = inap.pic_id
        INNER JOIN {tx_site} inap_site
            ON inap.site_id = inap_site.site_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            inap.status, 
            inap.created_at, 
            inap.take_over_at, 
            inap.checkin_at,
            inap_site.site_id
        UNION ALL
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            sva.status, 
            sva.created_at :: date,
            sva.take_over_at :: date,
            sva.checkin_at :: date,
            sva_site.site_id,
            sva_site.area_id,
            sva_site.regional_id,
            sva_site.nop_id,
            sva_site.cluster_id
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {tx_cmsite_header} sva
            ON tumm.tx_user_mobile_management_id::varchar = sva.pic_id
        INNER JOIN {tx_site} sva_site
            ON sva.site_id = sva_site.site_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            sva.status, 
            sva.created_at, 
            sva.take_over_at, 
            sva.checkin_at,
            sva_site.site_id
        UNION ALL
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            pm.status, 
            pm.created_at :: date,
            pm.take_over_at :: date,
            pm.checkin_at :: date,
            pm_site.site_id,
            pm_site.area_id,
            pm_site.regional_id,
            pm_site.nop_id,
            pm_site.cluster_id
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {tx_pm_ticket_site} pm
            ON tumm.tx_user_mobile_management_id::varchar = pm.pic_id
        INNER JOIN {tx_site} pm_site
            ON pm.tx_site_id = pm_site.site_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            pm.status, 
            pm.created_at, 
            pm.take_over_at, 
            pm.checkin_at,
            pm_site.site_id
        UNION ALL
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            fna.status, 
            fna.created_at :: date,
            fna.take_over_at :: date,
            fna.checkin_at :: date,
            fna_site.site_id,
            fna_site.area_id,
            fna_site.regional_id,
            fna_site.nop_id,
            fna_site.cluster_id
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {ticket_technical_support} fna 
            ON tumm.tx_user_mobile_management_id::varchar = fna.pic_id
        INNER JOIN {tx_site} fna_site
            ON fna.site_id = fna_site.site_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            fna.status, 
            fna.created_at, 
            fna.take_over_at, 
            fna.checkin_at,
            fna_site.site_id
    ) AS combined_ticket
    GROUP BY 
        combined_ticket.tx_user_mobile_management_id, 
        combined_ticket.employee_name, 
        combined_ticket.status, 
        combined_ticket.created_at, 
        combined_ticket.take_over_at, 
        combined_ticket.checkin_at,
        combined_ticket.site_id,
        combined_ticket.area_id,
        combined_ticket.regional_id,
        combined_ticket.nop_id,
        combined_ticket.cluster_id
) AS final_count;

-- 
-- 
-- without site
SELECT COUNT(*)
FROM (
    SELECT 
        combined_ticket.tx_user_mobile_management_id,
        combined_ticket.employee_name,
        combined_ticket.area_id,
        combined_ticket.regional_id,
        combined_ticket.nop_id,
        combined_ticket.cluster_id,
        combined_ticket.status,
        combined_ticket.created_at,
        combined_ticket.take_over_at,
        combined_ticket.checkin_at
    FROM (
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            inap.status, 
            inap.created_at :: date,
            inap.take_over_at :: date,
            inap.checkin_at :: date
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {tx_ticket_terr_opr} inap
            ON tumm.tx_user_mobile_management_id::varchar = inap.pic_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            inap.status, 
            inap.created_at, 
            inap.take_over_at, 
            inap.checkin_at
        UNION ALL
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            sva.status, 
            sva.created_at :: date,
            sva.take_over_at :: date,
            sva.checkin_at :: date
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {tx_cmsite_header} sva
            ON tumm.tx_user_mobile_management_id::varchar = sva.pic_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            sva.status, 
            sva.created_at, 
            sva.take_over_at, 
            sva.checkin_at
        UNION ALL
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            pm.status, 
            pm.created_at :: date,
            pm.take_over_at :: date,
            pm.checkin_at :: date
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {tx_pm_ticket_site} pm
            ON tumm.tx_user_mobile_management_id::varchar = pm.pic_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            pm.status, 
            pm.created_at, 
            pm.take_over_at, 
            pm.checkin_at
        UNION ALL
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
            tumm.area_id,
            tumm.regional_id,
            tumm.nop_id,
            tumm.cluster_id,
            fna.status, 
            fna.created_at :: date,
            fna.take_over_at :: date,
            fna.checkin_at :: date
        FROM {tx_user_mobile_management} tumm
        INNER JOIN {ticket_technical_support} fna 
            ON tumm.tx_user_mobile_management_id::varchar = fna.pic_id
        GROUP BY 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name, 
            fna.status, 
            fna.created_at, 
            fna.take_over_at, 
            fna.checkin_at
    ) AS combined_ticket
    WHERE 
    (combined_ticket.area_id = @AreaId or @AreaId = '') and 
    (combined_ticket.regional_id = @RegionalId or @RegionalId = '') and 
    (combined_ticket.nop_id = @NopId or @NopId = '') and 
    (combined_ticket.cluster_id = @ClusterId or @ClusterId = 0)
    GROUP BY 
        combined_ticket.tx_user_mobile_management_id, 
        combined_ticket.employee_name,
        combined_ticket.area_id,
        combined_ticket.regional_id,
        combined_ticket.nop_id,
        combined_ticket.cluster_id,
        combined_ticket.status, 
        combined_ticket.created_at, 
        combined_ticket.take_over_at, 
        combined_ticket.checkin_at
) AS final_count;