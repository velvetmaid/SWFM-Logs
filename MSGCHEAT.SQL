SELECT
    a.pic_id,
    count(
        CASE
            WHEN a.status :: text = 'IN PROGRESS' :: text THEN 1
            ELSE NULL :: integer
        END
    ) AS take_over_ticket,
    count(
        CASE
            WHEN a.status :: text = 'ASSIGNED' :: text
            OR a.status :: text = 'CANCELED' :: text
            OR a.status :: text = 'ESCALATED TO CTS' :: text
            OR a.status :: text = 'ESCALATED TO INSERA' :: text
            OR a.status :: text = 'NEW' :: text
            OR a.status :: text = 'RESOLVED' :: text
            OR a.status :: text = 'SUBMITTED' :: text THEN 1
            ELSE NULL :: integer
        END
    ) AS open_ticket,
    count(
        CASE
            WHEN a.status :: text = 'CLOSED' :: text THEN 1
            ELSE NULL :: integer
        END
    ) AS close_ticket
FROM
    wfm_schema.tx_ticket_terr_opr a
    inner join wfm_schema.tx_site ts on a.site_id = ts.site_id
WHERE
    a.created_at >= (CURRENT_DATE - '1 day' :: interval)
    and ts.cluster_id = 445
GROUP BY
    a.pic_id;

select
    *
from
    wfm_schema.tx_user_mobile_management tumm
    inner join wfm_schema.tx_ticket_terr_opr ttto 
    on tumm.tx_user_mobile_management_id::varchar = ttto.pic_id
where
    tumm.tx_user_mobile_management_id = 1959
    or tumm.tx_user_mobile_management_id = 2146
    or tumm.tx_user_mobile_management_id = 2152
    or tumm.tx_user_mobile_management_id = 2170
    or tumm.tx_user_mobile_management_id = 2356