-- Select User List
SELECT 
    tx_user_management.username AS username,
    tx_user_management.email AS email,
    tx_user_management.employee_name AS employe_name,
    tm_regional.regional_name AS regional_name,
    tm_cluster.cluster_name AS cluster_name,
    tm_area.area_name AS area_name
FROM 
    tx_user_management
JOIN 
    tm_regional ON tx_user_management.regional_id = tm_regional.regional_id
JOIN 
    tm_cluster ON tx_user_management.cluster_id = tm_cluster.cluster_id
JOIN 
    tm_area ON tx_user_management.area_id = tm_area.area_id;

-- Select Absent
select a.absendate, a.userid, b.timein ,c.timeout,d.username, d.area_id, d.regional_id, d.network_service_name,d.cluster_name,d.rtp from wfm_schema.tx_absen a 
left join 
(select absendate, userid, min(absentime) timein from wfm_schema.tx_absen where absentype=true group by userid, absendate) b
on a.userid=b.userid and a.absendate=b.absendate
left join
(select absendate, userid, max(absentime) timeout from wfm_schema.tx_absen where absentype=false group by userid, absendate) c
on a.userid=c.userid and a.absendate=c.absendate
left join
(select a.ref_user_id,a.username, a.area_id, a.regional_id, a.ns_id,b.network_service_name,a.cluster_id,c.cluster_name,a.rtp from wfm_schema.tx_user_management a
left join wfm_schema.tm_network_service b on a.ns_id = b.network_service_id
left join wfm_schema.tm_cluster c on a.cluster_id = c.cluster_id
where a.is_active=true) d
on a.userid= d.ref_user_id
group by a.absendate, a.userid, b.timein, c.timeout, d.username,d.area_id, d.regional_id, d.network_service_name,d.cluster_name,d.rtp order by a.absendate desc;

-- Create user mobile management
CREATE TABLE wfm_schema.tx_user_mobile_management
(
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    role_id INT,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255)
)

-- Create mapping_user_mobile_role unused
CREATE TABLE wfm_schema.mapping_user_mobile_role (
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_management_id INT,
    tx_user_mobile_management_id INT,
    role_id INT,
    ref_user_id INT,
    role_name VARCHAR(255),
    role_code VARCHAR(255)
)

-- Create mapping_user_mobile_role
CREATE TABLE wfm_schema.tm_user_mobile_role
(
    tm_user_mobile_role_id SERIAL PRIMARY KEY,
    code varchar(50),
    name varchar(255),
    description varchar(255),
    created_by varchar(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by varchar(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by varchar(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN
)

----------UP PROD 24/10/2023-----------------
CREATE TABLE IF NOT EXISTS wfm_schema.bps_exportpdf_form
(
    bps_exportpdf_form_id SERIAL PRIMARY KEY,
    nama_vendor VARCHAR(255),
    job_title VARCHAR(255),
    responsibility_name1 VARCHAR(255),
    responsibility_job_title1 VARCHAR(255),
    responsibility_name2 VARCHAR(255),
    responsibility_job_title2 VARCHAR(255),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at time without time zone
)

CREATE TABLE IF NOT EXISTS wfm_schema.bps_monitoring
(
    bps_monitoring_id SERIAL PRIMARY KEY,
    no_ticket VARCHAR(255),
    status_ticket VARCHAR(255),
    ref_number VARCHAR(255),
    source_ticket VARCHAR(255),
    group_ticket VARCHAR(255),
    mbp_unit VARCHAR(255),
    site_class VARCHAR(255),
    site_id VARCHAR(255),
    site_name VARCHAR(255),
    user_requestor VARCHAR(255),
    role_name VARCHAR(255),
    assignee_name VARCHAR(255),
    cancel_note VARCHAR(255),
    last_alarm_clear VARCHAR(255),
    resolution_category1 VARCHAR(255),
    resolution_category2 VARCHAR(255),
    resolution_category3 VARCHAR(255),
    issue_category VARCHAR(255),
    root_category1 VARCHAR(255),
    root_category2 VARCHAR(255),
    root_category3 VARCHAR(255),
    resolution_action VARCHAR(255),
    user_submiter VARCHAR(255),
    preparation_time TIMESTAMP WITHOUT TIME ZONE,
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    request_time TIMESTAMP WITHOUT TIME ZONE,
    ack_time TIMESTAMP WITHOUT TIME ZONE,
    departure_time TIMESTAMP WITHOUT TIME ZONE,
    arrival_time TIMESTAMP WITHOUT TIME ZONE,
    cancel_time TIMESTAMP WITHOUT TIME ZONE,
    rh_stop_time TIMESTAMP WITHOUT TIME ZONE,
    leave_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_approver VARCHAR(255),
    running_hour_start_photo VARCHAR(50),
    running_hour_stop_photo VARCHAR(50),
    kwhphoto_before VARCHAR(50),
    kwhphoto_after VARCHAR(50),
    rectifierphoto_before VARCHAR(50),
    rectifierphoto_after VARCHAR(50),
    btsphoto_before VARCHAR(50),
    btsphoto_after VARCHAR(50),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    rh_start_time TIMESTAMP WITHOUT TIME ZONE,
    note VARCHAR(255),
    need_key BOOLEAN,
    kwhmeter BOOLEAN,
    running_hour_start numeric,
    running_hour_stop numeric,
    assignee_id INT,
    note_mobile VARCHAR(255)
)

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support
(
    ticket_technical_support_id SERIAL PRIMARY KEY,
    site_id VARCHAR(25),
    cluster_area VARCHAR(25),
    category VARCHAR(25),
    ticket_subject VARCHAR(50),
    job_details VARCHAR(255),
    job_targets VARCHAR(255),
    sla_start TIMESTAMP WITHOUT TIME ZONE,
    sla_end TIMESTAMP WITHOUT TIME ZONE,
    sla_range VARCHAR(25),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    no_ticket UNIQUE VARCHAR(25),
    activity_name VARCHAR(255),
    role_name VARCHAR(255),
    respone_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_submitter VARCHAR(255),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    user_approve VARCHAR(255),
    note VARCHAR(255),
    review VARCHAR(255),
    status VARCHAR(25),
    rootcause1 VARCHAR(255),
    rootcause2 VARCHAR(255),
    rootcause3 VARCHAR(255),
    rootcause_remark VARCHAR(255),
    resolution_action VARCHAR(255),
    pic_id VARCHAR(255),
    pic_name VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    issue_category VARCHAR(255)
)

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support_file
(
    ticket_technical_support_file_id SERIAL PRIMARY KEY,
    ticket_technical_support_id INT,
    file_name VARCHAR(255),
    file_uploader VARCHAR(255),
    file_uploader_role VARCHAR(255),
    created_at VARCHAR(255),
    file_sftp_id VARCHAR(255)
    -- CONSTRAINT ticket_technical_support_file_pkey PRIMARY KEY (ticket_technical_support_file_id),
    -- CONSTRAINT ticket_technical_support_file_ticket_technical_support_id_fkey FOREIGN KEY (ticket_technical_support_id)
    -- REFERENCES wfm_schema.ticket_technical_support (ticket_technical_support_id) MATCH SIMPLE
    -- ON UPDATE NO ACTION
    -- ON DELETE NO ACTION
)

---------------END PROD 24/10/23

-- LAST PROD 29/OCT/23
CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support
(
    ticket_technical_support_id INT NOT NULL DEFAULT nextval('wfm_schema.ticket_technical_support_ticket_technical_support_id_seq'::regclass),
    site_id VARCHAR(25),
    cluster_area VARCHAR(25),
    category VARCHAR(25),
    ticket_subject VARCHAR(50),
    job_details VARCHAR(255),
    job_targets VARCHAR(255),
    sla_start TIMESTAMP WITHOUT TIME ZONE,
    sla_end TIMESTAMP WITHOUT TIME ZONE,
    sla_range VARCHAR(25),
    created_by bigint,
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by bigint,
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    no_ticket VARCHAR(25),
    activity_name VARCHAR(255),
    role_name VARCHAR(255),
    respone_time TIMESTAMP WITHOUT TIME ZONE,
    submit_time TIMESTAMP WITHOUT TIME ZONE,
    user_submitter VARCHAR(255),
    approve_time TIMESTAMP WITHOUT TIME ZONE,
    user_approve VARCHAR(255),
    note VARCHAR(255),
    review VARCHAR(255),
    status VARCHAR(25),
    rootcause1 VARCHAR(255),
    rootcause2 VARCHAR(255),
    rootcause3 VARCHAR(255),
    rootcause_remark VARCHAR(255),
    resolution_action VARCHAR(255),
    pic_id VARCHAR(255),
    pic_name VARCHAR(255),
    description VARCHAR(255),
    name VARCHAR(255),
    issue_category VARCHAR(255),
    CONSTRAINT ticket_technical_support_pkey PRIMARY KEY (ticket_technical_support_id),
    CONSTRAINT ticket_technical_support_no_ticket_key UNIQUE (no_ticket)
);

CREATE TABLE IF NOT EXISTS wfm_schema.ticket_technical_support_file
(
    ticket_technical_support_file_id INT NOT NULL DEFAULT nextval('wfm_schema.ticket_technical_support_file_ticket_technical_support_file_seq'::regclass),
    ticket_technical_support_id INT,
    file_name VARCHAR(255),
    file_uploader VARCHAR(255),
    file_uploader_role VARCHAR(255),
    created_at VARCHAR(255),
    file_sftp_id VARCHAR(255),
    CONSTRAINT ticket_technical_support_file_pkey PRIMARY KEY (ticket_technical_support_file_id)
);
END;

-- END LAST PROD 29/OCT/23

-- User and role mobile

BEGIN;
CREATE TABLE IF NOT EXISTS wfm_schema.mapping_user_mobile_role
(
    mapping_user_mobile_role_id SERIAL PRIMARY KEY,
    tx_user_management_id INT,
    tx_user_mobile_management_id INT,
    role_id INT,
    ref_user_id INT,
    role_name VARCHAR(255),
    role_code VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
);

-- JSON Structure local var
{ 
    "mapping_user_mobile_role": 
        {
        "mapping_user_mobile_role_id" : 1,
        "tx_user_management" : 1,
        "tx_user_mobile_management_id" : 1,
        "role_id" : 1,
        "ref_user_id" : 1
        }
}

CREATE TABLE IF NOT EXISTS wfm_schema.tx_user_mobile_management
(
    tx_user_mobile_management_id SERIAL PRIMARY KEY,
    username VARCHAR(255),
    email VARCHAR(255),
    user_password VARCHAR(255),
    is_organic BOOLEAN,
    tx_user_management_id INT,
    role_id INT,
    ref_user_id INT,
    partner_id INT,
    description VARCHAR(255),
    created_by VARCHAR(255),
    created_at TIMESTAMP WITHOUT TIME ZONE,
    modified_by VARCHAR(255),
    modified_at TIMESTAMP WITHOUT TIME ZONE,
    deleted_by VARCHAR(255),
    deleted_at TIMESTAMP WITHOUT TIME ZONE,
    is_active BOOLEAN,
    is_delete BOOLEAN,
    employee_name VARCHAR(255),
    area_id VARCHAR(5),
    regional_id VARCHAR(5),
    ns_id VARCHAR(30),
    cluster_id INT,
    deviceid VARCHAR(255),
    rtp VARCHAR(255),
);
END;

-- End user role