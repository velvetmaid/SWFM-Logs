select
    tih.vendorrefid AS ticket_number_inap,
    ttto.ticket_no AS ticket_number_swfm,
    tih.severity,
    tih.tickettype as type_ticket,
    ttto.site_id,
    ttto.site_name,
    tttoe.class_name as site_class,
    tttoe.cluster_name as cluster_to,
    tmc.mc_name as sub_cluster,
    tih.impact,
    tih.occuredtime,
    tih.created_at,
    tih.cleared_time - tih.occuredtime as duration_ticket,
    -- now() - tih.occuredtime as age_ticket,
    'n/a' as ne_class,
    tih.status as ticket_inap_status,
    ttto.status as ticket_swfm_status,
    ttto.pic_name as pic_take_over_ticket,
    tttoe.nop_name as nop,
    tttoe.regional_name as regional,
    tttoe.area_id as area,
    ttto.is_escalate,
    ttto.escalate_to,
    tih.cleared_time,
    ttto.is_autoresolved as is_auto_resolved,
    'n/a' as rh_start,
    'n/a' as rh_start_time,
    'n/a' as rh_stop,
    'n/a' as rh_stop_time,
    ttto.rc_owner,
    'n/a' as rc_category,
    'n/a' as rc_1,
    'n/a' as rc_2,
    tih.notes as note,
    ttto.resolution_action,
    ttto.take_over_at as take_over_date,
    ttto.checkin_at as check_in_at,
    'n/a' as inap_rc_1,
    'n/a' as inap_rc_2,
    tih.resolution_action as inap_resolution_action,
    CASE
        WHEN tih.sla_point = 1 THEN true
        ELSE false
    END as sla_status,
    ttto.faultlevel as fault_level,
    tih.ticket_nossa_no as nossa_no,
    tih.assigneegroup as assignee_group,
    tih.summary,
    tih.description,
    ttto.submitted_at as submitted_time,
    ttto.incident_priority,
    ttto.hub,
    ttto.is_exclude as is_exclude_in_kpi,
    ttto.created_at as ticket_creation,
    tih.user_creator as ticket_creator,
    tttoe.clear_on as site_cleared_on,
    tttoe.rank,
    tih.closed_at,
    tttoe.dispatch_name as dispatch_by,
    tttoe.dispatch_date
from
    wfm_schema.tx_inap_header tih
    inner join wfm_schema.tx_inap_ext tie on tih.vendorrefid = tie.vendorrefid
    inner join wfm_schema.tx_ticket_terr_opr ttto on tih.vendorrefid = ttto.inap_ticket_no
    inner join wfm_schema.tx_ticket_terr_opr_ext tttoe on ttto.tx_ticket_terr_opr_id = tttoe.tx_ticket_terr_opr_id
    left join wfm_schema.tm_mapping_mc_site tmms on ttto.site_id = tmms.site_id
    inner join wfm_schema.tm_microcluster tmc on tmms.mc_id = tmc.mc_id
where
    ttto.status = 'CLOSED'
limit
    10