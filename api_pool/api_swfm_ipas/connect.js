require("dotenv").config();
const { poolSWFM } = require("./config");

(async () => {
  const poolA = await poolSWFM();
  const resA = await poolA.query("SELECT $1::text as connected", [
    "______________________________\nConnection to SWFM successful!\nHost :" +
      process.env.DB_HOST + "\nDatabase :" +
      process.env.DB_DATABASE,
  ]);
  console.log(resA.rows[0].connected);
  await poolA.end();
})();
