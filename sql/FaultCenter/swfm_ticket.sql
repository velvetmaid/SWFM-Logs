    SELECT 
        inap_ticket_no as ticket_number_inap,
        ticket_no as ticket_number_swfm,
        severity,
        tickettype as type_ticket,
        tx_site.site_id,
        tx_site.site_name,
        tx_site.class_site_name as site_class,
        tm_cluster.cluster_name as cluster_to,
        tx_ticket_terr_opr_ext.mc_assigned as sub_cluster,
        impact,
        occuredtime as occured_time,
        tx_ticket_terr_opr.created_at,
        '' as duration_ticket,
        '' as age_ticket,
        '' as ne_class,
        tx_inap_header.status as ticket_inap_status,
        tx_ticket_terr_opr.status as ticket_swfm_status,
        pic_name as pic_take_over_ticket,
        tm_nop.nop_name as nop,
        tm_regional.regional_name as regional,
        tm_area.area_name as area,
        is_escalate,
        escalate_to,
        cleared_time,
        CASE
            WHEN UPPER(tx_inap_header.status) = 'CLOSED' or UPPER(tx_inap_header.status) = 'RESOLVED' THEN
                CASE WHEN tx_ticket_terr_opr.pic_name = '' THEN 'Auto Resolved' ELSE 'Manual Resolved' END
            ELSE ''
        END as is_auto_resolve, -- isautoresolved
        AA.running_hour_start as rh_start,
        AA.rh_start_time,
        AA.running_hour_stop as rh_stop,
        AA.rh_stop_time,
        tx_ticket_terr_opr.rc_owner,
        tm_rootcausecategory.name as rc_categry,
        RC1.name as rc1,
        RC2.name as rc2,
        tx_ticket_terr_opr.notes,
        tx_ticket_terr_opr.resolution_action,
        tx_ticket_terr_opr.take_over_at as take_over_date,
        tx_ticket_terr_opr.checkin_at as check_in_at,
        tx_inap_header.rootcause_1 as inap_rc_1,
        tx_inap_header.rootcause_2 as inap_rc_2,
        tx_inap_header.resolution_action as inap_resolution_action,
        CASE
            WHEN tx_inap_header.sla_duration > 0 AND tx_inap_header.sla_point = 1 THEN 'IN SLA'
            WHEN tx_inap_header.sla_duration > 0 AND tx_inap_header.sla_point <> 1 THEN 'OUT SLA'
            ELSE 'SLA NOT AVAILABLE'
        END as sla_status,
        tx_inap_header.faultlevel as fault_level,
        tx_inap_header.ticket_nossa_no as nossa_no,
        tx_inap_header.assigneegroup as assignee_group,
        tx_inap_header.summary,
        tx_inap_header.description,
        tx_ticket_terr_opr.submitted_at as submitted_time,
        tx_ticket_terr_opr.incident_priority,
        tx_ticket_terr_opr.hub,
        CASE
            WHEN tx_ticket_terr_opr.is_exclude THEN 'YES'
            ELSE 'NO'
        END as is_exclude_in_kpi,
        CASE
            WHEN tx_inap_header.user_creator = 'admin' THEN 'Auto'
            WHEN tx_inap_header.user_creator = '' THEN ''
            ELSE 'Manual'
        END as ticket_creation,
        tx_inap_header.user_creator as ticket_creator,
        tx_ticket_terr_opr_ext.clear_on as site_cleared_on,
        tx_ticket_terr_opr_ext.rank,
        tx_inap_header.closed_at,
        tx_ticket_terr_opr_ext.dispatch_name as dispatch_by,
        tx_ticket_terr_opr_ext.dispatch_date,
        tx_ticket_terr_opr.follow_up_at,
        tx_ticket_terr_opr_ext.rc_owner_eng_init as rc_owner_engineer,
        RCCAT.name as rc_category_engineer,
        RC1En.name as rc_1_engineer,
        RC2En.name as rc_2_engineer,
        CASE WHEN tx_ticket_terr_opr_ext.rc_validated THEN 'Yes' ELSE 'No' END as rc_validated,
        tx_ticket_terr_opr_ext.rc_validated_at,
        tx_ticket_terr_opr_ext.rc_validated_by,
       CASE 
       WHEN (
        (
            LOWER(tx_ticket_terr_opr.inap_rootcause) LIKE '%power%' 
            AND tx_inap_header.tickettype = 'Incident'
            AND (
                tx_site.is_backup_by_tp = TRUE 
                OR tx_site.ada_genset = TRUE
            )
        ) 
        OR 
        (
            LOWER(tx_ticket_terr_opr.inap_rootcause) LIKE '%power%' 
            AND tx_inap_header.tickettype = 'Incident'
            AND ((LOWER(tx_site.class_site_name) ILIKE '%silver%') or (LOWER(tx_site.class_site_name) ILIKE '%bronze%'))
        )
        ) 
        THEN 
        CASE 
            WHEN tx_ticket_terr_opr.pic_id <> '' THEN 'Dispatched'
            ELSE 'Hold'
        END
        ELSE 'Dispatched'
        END as holding_status,
        CASE
            WHEN tx_ticket_terr_opr_ext.is_forced THEN 'YES'
            ELSE 'NO'
        END as is_force_dispatch
    FROM wfm_schema.tx_ticket_terr_opr
    INNER JOIN wfm_schema.tx_site ON tx_site.site_id = tx_ticket_terr_opr.site_id
    LEFT JOIN wfm_schema.tm_cluster ON tm_cluster.cluster_id =  tx_site.cluster_id
    left join wfm_schema.tm_nop on tm_nop.nop_id = tx_site.nop_id
    left join wfm_schema.tm_regional on tm_regional.regional_id = tx_site.regional_id
    left join wfm_schema.tm_area on tm_area.area_id = tx_site.area_id
    LEFT JOIN wfm_schema.tx_inap_header ON tx_inap_header.vendorrefid = tx_ticket_terr_opr.inap_ticket_no
    LEFT JOIN wfm_schema.tm_rootcausecategory ON tx_ticket_terr_opr.issue_category = CAST(tm_rootcausecategory.tm_rootcausecategory_id as text)
    LEFT JOIN wfm_schema.tm_rootcause AS RC1 ON (RC1.code = tx_ticket_terr_opr.rootcause1 AND (CAST(RC1.rootcausecategory_id as text) = tx_ticket_terr_opr.issue_category) AND RC1.rc_owner = tx_ticket_terr_opr.rc_owner)
    LEFT JOIN wfm_schema.tm_rootcause AS RC2 ON (RC2.code = tx_ticket_terr_opr.rootcause2 AND (CAST(RC2.parent_id as text) = tx_ticket_terr_opr.rootcause1) AND RC2.rc_owner = tx_ticket_terr_opr.rc_owner)
    LEFT JOIN
    (
        select ticket_terr_opr_id,MAX(running_hour_start)running_hour_start,
                MAX(rh_start_time)rh_start_time,
                MAX(running_hour_stop)running_hour_stop,
                MAX(rh_stop_time)rh_stop_time
        from wfm_schema.tx_terr_opr_mbp
        group by ticket_terr_opr_id
    )AA ON AA.ticket_terr_opr_id = tx_ticket_terr_opr.tx_ticket_terr_opr_id
    LEFT JOIN wfm_schema.tx_ticket_terr_opr_ext ON tx_ticket_terr_opr_ext.tx_ticket_terr_opr_id = tx_ticket_terr_opr.tx_ticket_terr_opr_id
    LEFT JOIN wfm_schema.tm_rootcause AS RC1En ON (RC1En.code = tx_ticket_terr_opr_ext.rootcause1_eng_init AND  RC1En.rc_owner = tx_ticket_terr_opr_ext.rc_owner_eng_init)
    LEFT JOIN wfm_schema.tm_rootcause AS RC2En ON (RC2En.code = tx_ticket_terr_opr_ext.rootcause2_eng_init AND (CAST(RC2En.parent_id as text) = tx_ticket_terr_opr_ext.rootcause1_eng_init) AND RC2En.rc_owner = tx_ticket_terr_opr_ext.rc_owner_eng_init)
    LEFT JOIN wfm_schema.tm_rootcausecategory AS RCCAT ON tx_ticket_terr_opr_ext.rc_category_eng_init = CAST(RCCAT.tm_rootcausecategory_id as text)
    LEFT JOIN wfm_schema.tx_user_mobile_management On tx_ticket_terr_opr.pic_id = CAST(tx_user_mobile_management.tx_user_mobile_management_id as text)
    where
    EXTRACT(MONTH FROM tx_inap_header.occuredtime) = 1 
	AND EXTRACT(YEAR FROM tx_inap_header.occuredtime) = 2025
    ORDER BY tx_inap_header.occuredtime, tx_ticket_terr_opr_ext.rank