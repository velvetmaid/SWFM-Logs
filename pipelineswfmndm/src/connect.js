require("dotenv").config();
const { poolSWFM, poolNDM } = require("./config");

(async () => {
  const poolA = await poolSWFM();
  const resA = await poolA.query("SELECT $1::text as connected", [
    "______________________________\nConnection to SWFM successful!\nHost :" +
      process.env.DB_A_HOST + "\nDatabase :" +
      process.env.DB_A_DATABASE,
  ]);
  console.log(resA.rows[0].connected);
  await poolA.end();

  const poolB = await poolNDM();
  const resB = await poolB.query("SELECT $1::text as connected", [
    "______________________________\nConnection to NDM successful!\nDatabase :" +
      process.env.DB_B_HOST + "\nDatabase :" +
      process.env.DB_B_DATABASE,
  ]);
  console.log(resB.rows[0].connected);
  await poolB.end();
})();
