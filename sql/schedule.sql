DELETE FROM
  wfm_schema.tx_location_device
WHERE
  currenttime < now() - INTERVAL 1 DAY;