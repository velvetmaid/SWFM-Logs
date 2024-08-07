const { getClient } = require("./get-client");

(async () => {
  const client = await getClient();

  const entries = await client.query(
    "SELECT * FROM wfm_schema.tm_area order by area_id asc limit 6"
  );

  console.log(entries.rows);

//   entries.rows.forEach((row, index) => {
//     console.log(`Entry ${index + 1}:`, row);
//   });
  await client.end();
})();
