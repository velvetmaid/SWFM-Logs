select
    sub_query.[inap_ticket_no],
    sub_query.[site_id],
    sub_query.[ticket_no],
    sub_query.[incident_priority],
    sub_query.[rank],
    sub_query.[status],
    sub_query.[created_at],
    sub_query.rank_func,
    sub_query.[severity],
    sub_query.[user_creator],
    sub_query.[occuredtime],
    sub_query.[sla_duration],
    sub_query.[sla_time],
    sub_query.[clear_on],
    sub_query.[site_name],
    sub_query.[tx_ticket_terr_opr_id],
    sub_query.[is_escalate],
    sub_query.[pic_id],
    sub_query.[pic_name],
    sub_query.[tickettype],
    sub_query.[class_site_name],
    sub_query.[is_forced],
    sub_query.[nop_id],
    sub_query.[regional_id],
    sub_query.[cluster_id],
    sub_query.[area_id],
    sub_query.[vendorrefid],
    sub_query.[ticket_priority],
    sub_query.[urgency],
    sub_query.[inap_rootcause],
    sub_query.[cleared_time],
    sub_query.[site_latitude],
    sub_query.[site_longitude],
    sub_query.[follow_up_at]
from
    (
        select
            { tx_ticket_terr_opr }.[inap_ticket_no],
            { tx_ticket_terr_opr }.[site_id],
            { tx_ticket_terr_opr }.[ticket_no],
            { tx_ticket_terr_opr }.[incident_priority],
            { tx_ticket_terr_opr_ext }.[rank],
            { tx_ticket_terr_opr }.[status],
            { tx_ticket_terr_opr }.[created_at],
            { tx_inap_header }.[severity],
            { tx_inap_header }.[user_creator],
            { tx_inap_header }.[occuredtime],
            { tx_inap_header }.[sla_duration],
            (
                { tx_inap_header }.[occuredtime] + INTERVAL '1 hour' * { tx_inap_header }.[sla_duration]
            ) as sla_time,
            { tx_ticket_terr_opr_ext }.[clear_on],
            ROW_NUMBER() OVER (
                PARTITION BY { tx_ticket_terr_opr }.[inap_ticket_no],
                { tx_site }.[cluster_id]
                Order by
                    CASE
                        WHEN { tx_ticket_terr_opr }.[status] = 'SUBMITTED' THEN 1
                        ELSE 0
                    END ASC,
                    CASE
                        WHEN extract(
                            year
                            from
                                { tx_ticket_terr_opr }.[follow_up_at]
                        ) <> 1900 THEN 1
                        ELSE 0
                    END ASC,
                    CASE
                        WHEN { tx_ticket_terr_opr_ext }.[rank] = 0 THEN 1
                        ELSE 0
                    END ASC,
                    { tx_ticket_terr_opr_ext }.[rank] ASC
            ) as rank_func,
            { tx_ticket_terr_opr }.[site_name],
            { tx_ticket_terr_opr }.[tx_ticket_terr_opr_id],
            { tx_ticket_terr_opr }.[is_escalate],
            { tx_ticket_terr_opr }.[pic_id],
            { tx_ticket_terr_opr }.[pic_name],
            { tx_inap_header }.[tickettype],
            { tx_site }.[class_site_name],
            { tx_ticket_terr_opr_ext }.[is_forced],
            { tx_site }.[nop_id],
            { tx_site }.[regional_id],
            { tx_site }.[cluster_id],
            { tx_site }.[area_id],
            { tx_inap_header }.[vendorrefid],
            { tx_ticket_terr_opr }.[ticket_priority],
            { tx_ticket_terr_opr }.[urgency],
            { tx_ticket_terr_opr }.[inap_rootcause],
            { tx_inap_header }.[cleared_time],
            { tx_site }.[site_latitude],
            { tx_site }.[site_longitude],
            { tx_ticket_terr_opr }.[follow_up_at]
        from
            { tx_ticket_terr_opr }
            left join { tx_ticket_terr_opr_ext } on { tx_ticket_terr_opr }.[tx_ticket_terr_opr_id] = { tx_ticket_terr_opr_ext }.tx_ticket_terr_opr_id
            inner join { tx_inap_header } on { tx_ticket_terr_opr }.[inap_ticket_no] = { tx_inap_header }.[vendorrefid]
            inner join { tx_site } on { tx_ticket_terr_opr }.[site_id] = { tx_site }.[site_id]
        where
            { tx_ticket_terr_opr }.[created_at] > '2024-09-10 00:00:00'
            and --{tx_ticket_terr_opr}.[inap_ticket_no] like 'IM-%' and
            { tx_ticket_terr_opr }.[status] not in (
                'RESOLVED',
                'CLOSED',
                'CANCELED',
                'ESCALATED TO INSERA',
                'ESCALATED TO CTS'
            )
        group by
            { tx_ticket_terr_opr }.[inap_ticket_no],
            { tx_ticket_terr_opr }.[site_id],
            { tx_ticket_terr_opr }.[ticket_no],
            { tx_ticket_terr_opr }.[incident_priority],
            { tx_ticket_terr_opr_ext }.[rank],
            { tx_ticket_terr_opr }.[status],
            { tx_ticket_terr_opr }.[created_at],
            { tx_inap_header }.[severity],
            { tx_inap_header }.[user_creator],
            { tx_inap_header }.[occuredtime],
            { tx_inap_header }.[sla_duration],
            { tx_ticket_terr_opr_ext }.[clear_on],
            { tx_ticket_terr_opr }.[site_name],
            { tx_ticket_terr_opr }.[tx_ticket_terr_opr_id],
            { tx_ticket_terr_opr }.[is_escalate],
            { tx_ticket_terr_opr }.[pic_id],
            { tx_ticket_terr_opr }.[pic_name],
            { tx_inap_header }.[tickettype],
            { tx_site }.[class_site_name],
            { tx_ticket_terr_opr_ext }.[is_forced],
            { tx_site }.[nop_id],
            { tx_site }.[regional_id],
            { tx_site }.[cluster_id],
            { tx_site }.[area_id],
            { tx_inap_header }.[vendorrefid],
            { tx_ticket_terr_opr }.[ticket_priority],
            { tx_ticket_terr_opr }.[urgency],
            { tx_ticket_terr_opr }.[inap_rootcause],
            { tx_inap_header }.[cleared_time],
            { tx_site }.[site_latitude],
            { tx_site }.[site_longitude],
            { tx_ticket_terr_opr }.[follow_up_at]
    ) as sub_query
where
    sub_query.rank_func <= @Limit
    AND 
    (
        (
            sub_query.ticket_no like '%' || @Search || '%'
            or UPPER(sub_query.site_id) like '%' || UPPER(@Search) || '%'
            or UPPER(sub_query.site_name) like '%' || UPPER(@Search) || '%'
        )
        AND (
            UPPER(sub_query.status) = UPPER(@Status)
            or @Status = ''
        )
        AND (
            UPPER(sub_query.nop_id) = UPPER(@nop_id)
            or @nop_id = ''
        )
        AND (
            UPPER(sub_query.regional_id) = UPPER(@regional_id)
            or @regional_id = ''
        )
        AND (
            sub_query.cluster_id = @cluster_id
            or @cluster_id = 0
        )
        AND (
            sub_query.pic_id = @pic_id
            or sub_query.pic_id = ''
        )
        AND (
            sub_query.vendorrefid like '%' || @vendorrefid || '%'
        )
        AND (UPPER(sub_query.area_id) = UPPER(@area_id))
    )
    AND (
        CASE
            WHEN @TicketRolle = 'TS' THEN sub_query.ticket_no like 'TS%'
            WHEN @TicketRolle = 'MBP' THEN sub_query.ticket_no like 'BPS%'
            WHEN @TicketRolle = 'TSMBP' THEN sub_query.ticket_no <> ''
            ELSE sub_query.ticket_no = ''
        END
    )
    AND (
        UPPER(sub_query.severity) like '%' || UPPER(@Severity) || '%'
    )
    OR (
        sub_query.pic_id = @pic_id
        and sub_query.status = 'SUBMITTED'
    )
    OR (
        sub_query.pic_id = @pic_id
        and extract(
            year
            from
                sub_query.follow_up_at
        ) <> 1900
    )