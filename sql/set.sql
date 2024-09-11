SELECT nextval('ams_schema.part_catalog_part_catalog_id_seq')
SELECT setval('ams_schema.part_catalog_part_catalog_id_seq', (SELECT MAX(part_catalog_id) FROM ams_schema.part_catalog)+1);



