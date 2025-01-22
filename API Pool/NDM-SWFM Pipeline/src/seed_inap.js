const fs = require("fs");
const path = require("path");
const { performance } = require("perf_hooks");
const { poolSWFM, poolNDM } = require("./config");
const columnFNA = require("./config/inap_structure.json")

async function processFNA() {
  const clientA = await poolSWFM();
  const clientB = await poolNDM();

  try {
    const startA = performance.now();
    const fnaQueriesPath = path.join(
      __dirname,
      "./queries/select_fna.sql"
    );
    const selectFNAQueries = fs.readFileSync(fnaQueriesPath, "utf8");
    const resultA = await clientA.query(selectFNAQueries);
    const endA = performance.now();
    console.log(
      `Select FNA queries executed in ${Math.round(endA - startA)} ms`
    );

    const numParams = columnFNA.length;
    const placeholders = Array.from(
      { length: numParams },
      (_, i) => `$${i + 1}`
    ).join(", ");

    const insertOrUpdateFNA = `
      INSERT INTO wfm_schema.tx_field_operation_non_alarm (${columnFNA.join(
        ", "
      )})
      VALUES (${placeholders})
      ON CONFLICT (tx_field_operation_non_alarm_id)
      DO UPDATE SET ${columnFNA
        .map((col) => `${col} = EXCLUDED.${col}`)
        .join(", ")};
    `;

    const startB = performance.now();
    for (const row of resultA.rows) {
      const params = columnFNA.map((col) => row[col]);
      await clientB.query(insertOrUpdateFNA, params);
    }
    const endB = performance.now();
    console.log(
      `Insert/Update FNA queries executed in ${Math.round(endB - startB)} ms`
    );

    console.log("Data seed successfully!");
  } catch (err) {
    console.error("Error during data seed:", err.stack);
  } finally {
    await clientA.end();
    await clientB.end();
  }
}
processFNA();
// module.exports = processFNA;
