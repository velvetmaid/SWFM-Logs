const fs = require("fs");
const path = require("path");
const { performance } = require("perf_hooks");
const { poolSWFM, poolNDM } = require("./config");
const columnAttendance = require("./config/attendance_structure.json")

async function processAttendance() {
  const clientA = await poolSWFM();
  const clientB = await poolNDM();

  try {
    const startA = performance.now();
    const attendanceQueriesPath = path.join(
      __dirname,
      "./queries/select_attendance.sql"
    );
    const selectAttendanceQueries = fs.readFileSync(attendanceQueriesPath, "utf8");
    const resultA = await clientA.query(selectAttendanceQueries);
    const endA = performance.now();
    console.log(
      `Select Attendance queries executed in ${Math.round(endA - startA)} ms`
    );

    const numParams = columnAttendance.length;
    const placeholders = Array.from(
      { length: numParams },
      (_, i) => `$${i + 1}`
    ).join(", ");

    const insertOrUpdateAttendance = `
      INSERT INTO wfm_schema.tx_attendance (${columnAttendance.join(
        ", "
      )})
      VALUES (${placeholders})
      ON CONFLICT (tx_attendance_id)
      DO UPDATE SET ${columnAttendance
        .map((col) => `${col} = EXCLUDED.${col}`)
        .join(", ")};
    `;

    const startB = performance.now();
    for (const row of resultA.rows) {
      const params = columnAttendance.map((col) => row[col]);
      await clientB.query(insertOrUpdateAttendance, params);
    }
    const endB = performance.now();
    console.log(
      `Insert/Update Attendance queries executed in ${Math.round(endB - startB)} ms`
    );

    console.log("Data seed successfully!");
  } catch (err) {
    console.error("Error during data seed:", err.stack);
  } finally {
    await clientA.end();
    await clientB.end();
  }
}
processAttendance();
// module.exports = processAttendance;
