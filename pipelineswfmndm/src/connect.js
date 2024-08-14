require("dotenv").config();
const { poolSWFM, poolNDM } = require("./config");

(async () => {
  const poolA = await poolSWFM();
  const resA = await poolA.query("SELECT $1::text as connected", [
    "Connection to postgres SWFM successful!",
  ]);
  console.log(resA.rows[0].connected);
  await poolA.end();

  const poolB = await poolNDM();
  const resB = await poolB.query("SELECT $1::text as connected", [
    "Connection to postgres NDM successful!",
  ]);
  console.log(resB.rows[0].connected);
  await poolB.end();
})();
