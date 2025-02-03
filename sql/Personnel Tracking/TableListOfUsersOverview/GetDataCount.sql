SELECT COUNT(*)
FROM (
    SELECT 
        combined_ticket.tx_user_mobile_management_id,
        combined_ticket.employee_name,
        combined_ticket.status,
        combined_ticket.created_at,
        combined_ticket.take_over_at,
        combined_ticket.checkin_at
    FROM (
        SELECT 
            tumm.tx_user_mobile_management_id, 
            tumm.employee_name,
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
    GROUP BY 
        combined_ticket.tx_user_mobile_management_id, 
        combined_ticket.employee_name, 
        combined_ticket.status, 
        combined_ticket.created_at, 
        combined_ticket.take_over_at, 
        combined_ticket.checkin_at
) AS final_count;