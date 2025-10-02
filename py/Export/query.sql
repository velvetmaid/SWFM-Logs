SELECT *
FROM wfm_schema.tx_kpi_header_v2
INNER JOIN wfm_schema.tx_kpi_group_v2 
  ON tx_kpi_header_v2.id = tx_kpi_group_v2.kpi_header
INNER JOIN wfm_schema.tx_kpi_detail_v2
  ON tx_kpi_detail_v2.tx_kpi_group = tx_kpi_group_v2.id
INNER JOIN wfm_schema.tx_kpi_type_v2
  ON tx_kpi_header_v2.id = tx_kpi_type_v2.kpi_header
INNER JOIN wfm_schema.tm_kpi_type_v2
  ON tx_kpi_type_v2.tm_kpi_type = tm_kpi_type_v2.id
INNER JOIN wfm_schema.tx_kpi_detail_listdata_v2
  ON tx_kpi_detail_v2.id = tx_kpi_detail_listdata_v2.tx_kpi_detail 
WHERE month_period = 9 
  AND year_period = 2025
LIMIT 10;