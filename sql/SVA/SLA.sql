-- SLA
WITH sla_eventlog AS (
    SELECT
        transaction_id,
        activity_name,
        action_on
    FROM
        wfm_admin_schema.tx_eventlog
    WHERE
        application_name = 'WFM'
        AND process_id = '46'
        AND activity_name IN (
            'Approval By Manager NOS',
            'Work Approval by NOS MGR'
        )
),
sla as (
    select
        tch.cmsite_id,
        CASE
            WHEN (
                CASE
                    WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
                    ELSE 30 * 24 * 60
                END
            ) >= (
                CASE
                    WHEN tch.closed_at = DATE '1900-01-01' THEN EXTRACT(
                        EPOCH
                        FROM
                            (closed.action_on - approval.action_on)
                    ) / 60
                    ELSE EXTRACT(
                        EPOCH
                        FROM
                            (tch.closed_at - tch.draft_approve_date)
                    ) / 60
                END
            ) THEN TRUE
            ELSE FALSE
        END AS is_in_sla,
        CASE
            WHEN tch.closed_at = DATE '1900-01-01' THEN EXTRACT(
                EPOCH
                FROM
                    (closed.action_on - approval.action_on)
            ) / 60
            ELSE EXTRACT(
                EPOCH
                FROM
                    (tch.closed_at - tch.draft_approve_date)
            ) / 60
        END AS mttr,
        tch.ready_for_fms_time + (
            CASE
                WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
                ELSE 30 * 24 * 60
            END
        ) * INTERVAL '1 minute' AS sla_end,
        CASE
            WHEN tch.cm_urgency = 'HIGH' THEN 48 * 60
            ELSE 30 * 24 * 60
        END AS sla_param
    FROM
        wfm_schema.tx_cmsite_header tch
        LEFT JOIN sla_eventlog approval ON approval.transaction_id = tch.cmsite_id :: varchar
        AND approval.activity_name = 'Approval By Manager NOS'
        LEFT JOIN sla_eventlog closed ON closed.transaction_id = tch.cmsite_id :: varchar
        AND closed.activity_name = 'Work Approval by NOS MGR'
    WHERE
        tch.status NOT IN ('WAITING ACTIVITY APPROVAL', 'CANCELED')
        AND tch.draft_status = 'READY FOR FMS'
    LIMIT
        10
)
select
    *
from
    sla