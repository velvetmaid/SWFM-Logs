const { poolSWFM, poolNDM } = require("./config");
const fs = require("fs");
const path = require("path");

(async () => {
  const client = await poolSWFM();
  const sqlFilePath = path.join(__dirname, "./queries/read_clock_in_out.sql");

  const sql = fs.readFileSync(sqlFilePath, "utf8");
  const entries = await client.query(sql);

  console.log(entries.rows);

  //   entries.rows.forEach((row, index) => {
  //     console.log(`Entry ${index + 1}:`, row);
  //   });
  await client.end();
})();
