-- Add area_id, regional_id, nop_id, cluster_id
alter table wfm_schema.ticket_technical_support
add column area_id VARCHAR(5),
add column regional_id VARCHAR(5),
add column nop_id VARCHAR(30),
add column cluster_id INT;

-- Add foreign key site_id
ALTER TABLE wfm_schema.ticket_technical_support ADD CONSTRAINT ticket_technical_support_site_id_fkey FOREIGN KEY (site_id) REFERENCES wfm_schema.tx_site (site_id);

-- OPTIONAL: Add foreign key area_id, regional_id, nop_id, cluster_id
ALTER TABLE wfm_schema.ticket_technical_support ADD CONSTRAINT ticket_technical_support_area_id_fkey FOREIGN KEY (area_id) REFERENCES wfm_schema.tm_area (area_id),
ADD CONSTRAINT ticket_technical_support_regional_id_fkey FOREIGN KEY (regional_id) REFERENCES wfm_schema.tm_regional (regional_id),
ADD CONSTRAINT ticket_technical_support_nop_id_fkey FOREIGN KEY (nop_id) REFERENCES wfm_schema.tm_nop (nop_id),
ADD CONSTRAINT ticket_technical_support_cluster_id_fkey FOREIGN KEY (cluster_id) REFERENCES wfm_schema.tm_cluster (cluster_id);

-- Update area_id, regional_id, nop_id, cluster_id reference from tx_site
UPDATE wfm_schema.ticket_technical_support a
SET
    area_id = ts.area_id,
    regional_id = ts.regional_id,
    nop_id = ts.nop_id,
    cluster_id = ts.cluster_id
FROM
    wfm_schema.tx_site ts
WHERE
    a.site_id = ts.site_id;

-- Check site_id that does not exist in tx_site
SELECT
    *
FROM
    wfm_schema.ticket_technical_support
WHERE
    site_id IS NOT NULL
    AND site_id NOT IN (
        SELECT
            site_id
        FROM
            wfm_schema.tx_site
    );

-- Check result
select
    *
from
    wfm_schema.ticket_technical_support