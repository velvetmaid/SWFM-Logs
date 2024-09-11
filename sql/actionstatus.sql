create table wfm_schema.tx_status_action (
    id SERIAL primary key,
    process_code VARCHAR(10),
    action_name VARCHAR(50),
    current_status VARCHAR(50),
    next_status VARCHAR(50)
);

create table wfm_schema.tx_mapping_status_action (
    id SERIAL primary key,
    id_status_action BIGINT references wfm_schema.tx_status_action (id),
    id_tm_user_role BIGINT references wfm_schema.tm_user_role (tm_user_role_id)
);


'MXO060',
'MXO037',
'MXO059',
'MXO061',
'MXW079',
'MXO042',
'MXO050',
'MXO058',


-- wfm_schema.tm_all_tagihan_listrik definition

-- Drop table

-- DROP TABLE wfm_schema.tm_all_tagihan_listrik;

CREATE TABLE wfm_schema.tm_all_tagihan_listrik (
	billingid varchar(50) primary key,
	idpel varchar(50),
	pelname varchar(255),
	goltarif varchar(50),
	daya varchar(50),
	billtype varchar(50),
	siteid varchar(25),
	towerprovider varchar(255),
	periode varchar(25),
	status varchar(50),
	billstatus varchar(50),
	tagihan varchar(50),
	"token" varchar(100),
    statustoken varchar(50),
	kwhawal varchar(50),
	kwhakhir varchar(50),
	kwhpakai varchar(50),
	pathevidence varchar(50),
	is_release bool
);