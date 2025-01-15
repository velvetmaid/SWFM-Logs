const fs = require("fs");
const path = require("path");
const { poolSWFM, poolNDM } = require("./config");

(async () => {
  const client = await poolSWFM();
  const sqlQueries = path.join(__dirname, "./queries/select_fna.sql");

  const sql = fs.readFileSync(sqlQueries, "utf8");
  const entries = await client.query(sql);

  console.log(entries.rows);
  console.log(entries.rows.length);

  //   entries.rows.forEach((row, index) => {
  //     console.log(`Entry ${index + 1}:`, row);
  //   });
  await client.end();
})();
