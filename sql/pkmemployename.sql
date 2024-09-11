alter table wfm_schema.tx_recap_pln
add column submit_name VARCHAR(100),
add column approve_name VARCHAR(100)


CREATE TABLE wfm_schema.tm_kabupaten (
	kabupaten_id INT,
	kabupaten_name varchar(100),
	created_by varchar(255),
	created_at TIMESTAMP WITHOUT TIME ZONE,
	modified_by varchar(255),
	modified_at TIMESTAMP WITHOUT TIME ZONE ,
	deleted_by varchar(255),
	deleted_at TIMESTAMP WITHOUT TIME ZONE,
	is_active bool DEFAULT true,
	is_delete bool DEFAULT false
);