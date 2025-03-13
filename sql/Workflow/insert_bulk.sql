INSERT INTO
    wfm_admin_schema.tx_eventlog (
        id,
        event_id,
        event_type,
        application_id,
        application_name,
        transaction_id,
        process_id,
        process_name,
        activity_id,
        activity_name,
        actioner_id,
        actioner_name,
        actioner_email,
        actioner_nik,
        actioner_title,
        action_id,
        action_name,
        "comment",
        created_on,
        action_on,
        module_id,
        module_name,
        role_name
    )
VALUES
    (
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        ''
    );

INSERT INTO
    wfm_admin_schema.tx_eventlog (
        id,
        event_id,
        event_type,
        application_id,
        application_name,
        transaction_id,
        process_id,
        process_name,
        activity_id,
        activity_name,
        actioner_id,
        actioner_name,
        actioner_email,
        actioner_nik,
        actioner_title,
        action_id,
        action_name,
        "comment",
        created_on,
        action_on,
        module_id,
        module_name,
        role_name
    )
VALUES
    (
        generate guid (),
        / / id '1',
        / / event_id 'Workflow',
        / / event_type '2',
        / / application_id 'WFM',
        / / application_name pake transaction_id,
        / / transaction_id '46',
        / / process_id 'Corrective Maintenance',
        / / process_name '',
        / / activity_id 'CANCELED',
        / / activity_name '16351',
        / / actioner_id 'Backofficee',
        / / actioner_name '',
        / / actioner_email '',
        / / actioner_nik '',
        / / actioner_title '',
        / / action_id 'UPDATED FROM BACKOFFICE',
        / / action_name '',
        / / comment CURRENT_DATE_TIME,
        / / created_on CURRENT_DATE_TIME,
        / / action_on '',
        / / module_id '',
        / / module_name '' / / role_name
    );

INSERT INTO
    wfm_admin_schema.tx_eventlog (
        id,
        event_id,
        event_type,
        application_id,
        application_name,
        transaction_id,
        process_id,
        process_name,
        activity_name,
        actioner_id,
        actioner_name,
        action_name,
        created_on,
        action_on
    )
VALUES
    (
        generate_guid (), -- id
        '1', -- event_id
        'Workflow', -- event_type
        '2', -- application_id
        'WFM', -- application_name
        pake transaction_id, -- transaction_id
        '46', -- process_id
        'Corrective Maintenance', -- process_name
        'CANCELED', -- activity_name
        '16351', -- actioner_id
        'Backofficee', -- actioner_name
        'UPDATED FROM BACKOFFICE', -- action_name
        CURRENT_DATE_TIME, -- created_on
        CURRENT_DATE_TIME -- action_on
    );


-- YES
INSERT INTO
    wfm_admin_schema.tx_eventlog (
        id,
        event_id,
        event_type,
        application_id,
        application_name,
        transaction_id,
        process_id,
        process_name,
        activity_name,
        actioner_id,
        actioner_name,
        action_name,
        comment,
        created_on,
        action_on
    )
VALUES
    (
        gen_random_uuid (), -- id
        '1', -- event_id
        'Workflow', -- event_type
        '2', -- application_id
        'WFM', -- application_name
        '12529', -- transaction_id
        '46', -- process_id
        'Corrective Maintenance', -- process_name
        'CANCELED', -- activity_name
        '16351', -- actioner_id
        'backoffice', -- actioner_name
        'UPDATED FROM BACKOFFICE', -- action_name
        'Berdasarkan Pengajuan di Email dan MoM Kesepakatan antara ENOM dan Telkomsel', -- comment
        NOW (), -- created_on
        NOW () -- action_on
    );

-- BULK 1 TRANSACTION ID
INSERT INTO wfm_admin_schema.tx_eventlog (
    id,
    event_id,
    event_type,
    application_id,
    application_name,
    transaction_id,
    process_id,
    process_name,
    activity_name,
    actioner_id,
    actioner_name,
    action_name,
    comment,
    created_on,
    action_on
)
SELECT
    gen_random_uuid(), -- id
    '1', -- event_id
    'Workflow', -- event_type
    '2', -- application_id
    'WFM', -- application_name
    transaction_id, -- transaction_id dari array
    '46', -- process_id
    'Corrective Maintenance', -- process_name
    'CANCELED', -- activity_name
    '16351', -- actioner_id
    'Backoffice', -- actioner_name
    'UPDATED FROM BACKOFFICE', -- action_name
    'Berdasarkan Pengajuan di Email dan MoM Kesepakatan antara ENOM dan Telkomsel', -- comment
    NOW(), -- created_on
    NOW()  -- action_on
FROM unnest(array[
    11944, 12332, 12681, 14152, 10677, 12403, 13046, 11208, 12413, 11394, 
    11680, 13798, 12879, 11759, 12682, 12869, 11942, 12050, 11814, 12304,
    12305, 12314, 12563, 12591, 12732, 12764, 12867, 12871, 12872, 13166,
    12924, 12993, 13034, 12995, 13526, 13527, 13531, 8712, 12221, 12048,
    12844, 12635, 12659, 12406, 12346, 12280, 13542, 8177, 12404, 12300
]) AS transaction_id;

-- BULK 2 TRANSACTION ID
WITH ids AS (
  SELECT unnest(ARRAY[
    '13435',
    '3857',
    '13267',
    '5593',
    '7470',
    '5831',
    '4024',
    '7019'
  ]) AS transaction_id
)
INSERT INTO
    wfm_admin_schema.tx_eventlog (
        id,
        event_id,
        event_type,
        application_id,
        application_name,
        transaction_id,
        process_id,
        process_name,
        activity_name,
        actioner_id,
        actioner_name,
        action_name,
        comment,
        created_on,
        action_on
    )
SELECT 
    gen_random_uuid(), 
    '1', 
    'Workflow', 
    '2', 
    'WFM', 
    transaction_id, 
    '46', 
    'Corrective Maintenance', 
    'CANCELED', 
    '16351', 
    'Backoffice', 
    'UPDATED FROM BACKOFFICE', 
    'Berdasarkan Pengajuan di Email dan MoM Kesepakatan antara ENOM dan Telkomsel',
    NOW(), 
    NOW()
FROM ids;
