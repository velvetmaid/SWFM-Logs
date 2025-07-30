    SELECT 
        inap_ticket_no,
        tx_ticket_terr_opr.ticket_no,
        severity,
        tickettype,
        tx_site.site_id,
        tx_site.site_name,
        tx_site.class_site_name,
        tm_cluster.cluster_name,'',
        tx_ticket_terr_opr_ext.mc_assigned,
        impact,
        occuredtime,
        tx_ticket_terr_opr.created_at,
        '',
        '',
        '',
        tx_inap_header.status,
        tx_ticket_terr_opr.status,
        pic_name,
        tm_nop.nop_name,
        tm_regional.regional_name,
        tm_area.area_name,
        is_escalate,
        escalate_to,
        cleared_time,
        CASE
            WHEN UPPER(tx_inap_header.status) = 'CLOSED' or UPPER(tx_inap_header.status) = 'RESOLVED' THEN
                CASE WHEN tx_ticket_terr_opr.pic_name = '' THEN 'Auto Resolved' ELSE 'Manual Resolved' END
            ELSE ''
        END, -- isautoresolved
        AA.running_hour_start,
        AA.rh_start_time,
        AA.running_hour_stop,
        AA.rh_stop_time,
        tx_ticket_terr_opr.rc_owner,
        tm_rootcausecategory.name,
        RC1.name,
        RC2.name,
        tx_ticket_terr_opr.notes,
        tx_ticket_terr_opr.resolution_action,
        tx_ticket_terr_opr.take_over_at,
        tx_ticket_terr_opr.checkin_at,
        tx_inap_header.rootcause_1,
        tx_inap_header.rootcause_2,
        tx_inap_header.resolution_action,
        CASE
            WHEN tx_inap_header.sla_duration > 0 AND tx_inap_header.sla_point = 1 THEN 'IN SLA'
            WHEN tx_inap_header.sla_duration > 0 AND tx_inap_header.sla_point <> 1 THEN 'OUT SLA'
            ELSE 'SLA NOT AVAILABLE'
        END,
        tx_inap_header.faultlevel,
        tx_inap_header.ticket_nossa_no,
        tx_inap_header.assigneegroup,
        tx_inap_header.summary,
        tx_inap_header.description,
        tx_ticket_terr_opr.submitted_at,
        tx_ticket_terr_opr.incident_priority,
        tx_ticket_terr_opr.hub,
        CASE
            WHEN tx_ticket_terr_opr.is_exclude THEN 'YES'
            ELSE 'NO'
        END,
        CASE
            WHEN tx_inap_header.user_creator = 'admin' THEN 'Auto'
            WHEN tx_inap_header.user_creator = '' THEN ''
            ELSE 'Manual'
        END,
        tx_inap_header.user_creator,
        tx_ticket_terr_opr_ext.clear_on,
        tx_ticket_terr_opr_ext.rank,
        tx_inap_header.closed_at,
        tx_ticket_terr_opr_ext.dispatch_name,
        tx_ticket_terr_opr_ext.dispatch_date,
        tx_ticket_terr_opr.follow_up_at,
        tx_ticket_terr_opr_ext.rc_owner_eng_init,
        RCCAT.name,
        RC1En.name,
        RC2En.name,
        CASE WHEN tx_ticket_terr_opr_ext.rc_validated THEN 'Yes' ELSE 'No' END as rc_validated,
        tx_ticket_terr_opr_ext.rc_validated_at,
        tx_ticket_terr_opr_ext.rc_validated_by,
       CASE 
       WHEN (
        (
            LOWER(tx_ticket_terr_opr.inap_rootcause) ILIKE '%power%' 
            AND tx_inap_header.tickettype = 'Incident'
            AND (
                tx_site.is_backup_by_tp = TRUE 
                OR tx_site.ada_genset = TRUE
            )
        ) 
        OR 
        (
            LOWER(tx_ticket_terr_opr.inap_rootcause) ILIKE '%power%' 
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
        END,
        CASE
            WHEN tx_ticket_terr_opr_ext.is_forced THEN 'YES'
            ELSE 'NO'
        END,
        tx_user_mobile_management.email,
        tx_ticket_terr_opr_ext.rat,
        tx_ticket_terr_opr_parking.status,
        tx_ticket_terr_opr_parking.start_parking,
        tx_ticket_terr_opr_parking.end_parking
    FROM wfm_schema.tx_ticket_terr_opr
    INNER JOIN wfm_schema.tx_site ON tx_site.site_id = tx_ticket_terr_opr.site_id
    LEFT JOIN wfm_schema.tx_ticket_terr_opr_ext ON tx_ticket_terr_opr_ext.tx_ticket_terr_opr_id = tx_ticket_terr_opr.tx_ticket_terr_opr_id
    LEFT JOIN wfm_schema.tm_cluster ON tm_cluster.cluster_id = tx_ticket_terr_opr_ext.cluster_id
    left join wfm_schema.tm_nop on tm_nop.nop_id = tx_ticket_terr_opr_ext.nop_id
    left join wfm_schema.tm_regional on tm_regional.regional_id =tx_ticket_terr_opr_ext.regional_id
    left join wfm_schema.tm_area on tm_area.area_id =tx_ticket_terr_opr_ext.area_id
    LEFT JOIN wfm_schema.tx_inap_header ON tx_inap_header.vendorrefid = tx_ticket_terr_opr.inap_ticket_no
    LEFT JOIN wfm_schema.tm_rootcausecategory ON tx_ticket_terr_opr.issue_category = CAST(tm_rootcausecategory.tm_rootcausecategory_id as text)
    LEFT JOIN wfm_schema.tm_rootcause AS RC1 ON (RC1.code = tx_ticket_terr_opr.rootcause1 AND (CAST(RC1.rootcausecategory_id as text) = tx_ticket_terr_opr.issue_category) AND RC1.rc_owner = tx_ticket_terr_opr.rc_owner)
    LEFT JOIN wfm_schema.tm_rootcause AS RC2 ON (RC2.code = tx_ticket_terr_opr.rootcause2 AND (CAST(RC2.parent_id as text) = tx_ticket_terr_opr.rootcause1) AND RC2.rc_owner = tx_ticket_terr_opr.rc_owner)
    LEFT JOIN wfm_schema.mv_tx_terr_opr_mbp_agg AA ON AA.ticket_terr_opr_id = tx_ticket_terr_opr.tx_ticket_terr_opr_id
    LEFT JOIN wfm_schema.tm_rootcause AS RC1En ON (RC1En.code = tx_ticket_terr_opr_ext.rootcause1_eng_init AND  RC1En.rc_owner = tx_ticket_terr_opr_ext.rc_owner_eng_init)
    LEFT JOIN wfm_schema.tm_rootcause AS RC2En ON (RC2En.code = tx_ticket_terr_opr_ext.rootcause2_eng_init AND (CAST(RC2En.parent_id as text) = tx_ticket_terr_opr_ext.rootcause1_eng_init) AND RC2En.rc_owner = tx_ticket_terr_opr_ext.rc_owner_eng_init) 
    LEFT JOIN wfm_schema.tm_rootcausecategory AS RCCAT ON tx_ticket_terr_opr_ext.rc_category_eng_init = CAST(RCCAT.tm_rootcausecategory_id as text)
    LEFT JOIN wfm_schema.tx_user_mobile_management On tx_ticket_terr_opr.pic_id = CAST(tx_user_mobile_management.tx_user_mobile_management_id as text)
    LEFT JOIN wfm_schema.tx_ticket_terr_opr_parking ON tx_ticket_terr_opr.tx_ticket_terr_opr_id = tx_ticket_terr_opr_parking.tx_ticket_terr_opr_id
    limit 10