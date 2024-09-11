WITH site_list AS (
  SELECT unnest(ARRAY[
    'MXW132', 'EPC003', 'MXS048', 'MXW125', 'MXV006', 'EPC008', 'EPC006', 'MXU050', 'MQG008', 'MXU043',
    'MXT046', 'MXW091', 'MXW097', 'MXW090', 'MXW078', 'MXW076', 'MXV001', 'MXO060', 'MXY003', 'MXW131',
    'MXU047', 'MXW114', 'MXU046', 'MXO037', 'MXO059', 'MXO061', 'MXW079', 'MXX127', 'MXL002', 'MQJ003',
    'MXW048', 'MXW115', 'MXW112', 'MXW098', 'MXY002', 'MXN012', 'MXY007', 'MXY008', 'MXO042', 'MQG004',
    'MXO050', 'MXO058', 'MQG006', 'MXX132', 'MQG003', 'MXN020', 'MXW099', 'MXY006', 'MXU051', 'MXU045',
    'COB024', 'MXS047'
  ]) AS site_id
)
SELECT sl.site_id
FROM site_list sl
LEFT JOIN wfm_schema.tx_site ts ON sl.site_id = ts.site_id
WHERE ts.site_id IS NULL;   