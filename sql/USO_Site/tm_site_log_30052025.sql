-- Update tm_mapping_structure_area with area, regional, nop, and cluster names
UPDATE
    wfm_uso_schema.tm_mapping_structure_area AS tmsa
SET
    area_name = ta.area_name,
    regional_name = tr.regional_name,
    nop_name = tn.nop_name,
    cluster_name = tc.cluster_name
FROM
    wfm_uso_schema.tm_area ta,
    wfm_uso_schema.tm_regional tr,
    wfm_uso_schema.tm_nop tn,
    wfm_uso_schema.tm_cluster tc
WHERE
    ta.area_id = tmsa.area_id
    AND tr.regional_id = tmsa.regional_id
    AND tn.nop_id = tmsa.nop_id
    AND tc.cluster_id = tmsa.cluster_id
    AND (
        tmsa.area_name IS NULL
        OR tmsa.area_name = ''
        OR tmsa.regional_name IS NULL
        OR tmsa.regional_name = ''
        OR tmsa.nop_name IS NULL
        OR tmsa.nop_name = ''
        OR tmsa.cluster_name IS NULL
        OR tmsa.cluster_name = ''
    );

-- Alter OS SQL
UPDATE
    {tm_mapping_structure_area} AS tmsa
SET
    area_name = ta.area_name,
    regional_name = tr.regional_name,
    nop_name = tn.nop_name,
    cluster_name = tc.cluster_name
FROM
    {tm_area} ta,
    {tm_regional} tr,
    {tm_nop} tn,
    {tm_cluster} tc
WHERE
    ta.area_id = tmsa.area_id
    AND tr.regional_id = tmsa.regional_id
    AND tn.nop_id = tmsa.nop_id
    AND tc.cluster_id = tmsa.cluster_id
    AND (
        tmsa.area_name IS NULL
        OR tmsa.area_name = ''
        OR tmsa.regional_name IS NULL
        OR tmsa.regional_name = ''
        OR tmsa.nop_name IS NULL
        OR tmsa.nop_name = ''
        OR tmsa.cluster_name IS NULL
        OR tmsa.cluster_name = ''
    );