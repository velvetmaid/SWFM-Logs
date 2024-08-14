const fs = require("fs");
const path = require("path");
const { poolNDM } = require("./config");

(async () => {
  const client = await poolNDM();

  const sqlFilePaths = [
    path.join(__dirname, "./queries/create_fna.sql"),
    path.join(__dirname, "./queries/create_attendance.sql"),
  ];

  try {
    for (const sqlFilePath of sqlFilePaths) {
      const sql = fs.readFileSync(sqlFilePath, "utf8");
      const entries = await client.query(sql);
      console.log(`Executed ${path.basename(sqlFilePath)} successfully!`);
      console.log(
        `Rows returned from ${path.basename(sqlFilePath)}:`,
        entries.rows.length
      );
    }
    console.log("All SQL files executed successfully!");
  } catch (err) {
    console.error("Error executing SQL files:", err.stack);
  } finally {
    await client.end();
  }
})();
