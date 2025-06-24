CREATE OR REPLACE VIEW wfm_schema.vw_site_mapping_info AS
SELECT 
    ts.site_id, 
    ts.site_name, 
    ta.area_id, 
    ta.area_name, 
    tr.regional_id, 
    tr.regional_name,
    tn.nop_id,
    tn.nop_name,
    tc.cluster_id, 
    tc.cluster_name, 
    ts.is_active, 
    ts.is_delete
FROM wfm_schema.tx_site ts 
LEFT JOIN wfm_schema.tm_area ta ON ts.area_id = ta.area_id
LEFT JOIN wfm_schema.tm_regional tr ON ts.regional_id = tr.regional_id
LEFT JOIN wfm_schema.tm_nop tn ON ts.nop_id = tn.nop_id
LEFT JOIN wfm_schema.tm_cluster tc ON ts.cluster_id = tc.cluster_id;

