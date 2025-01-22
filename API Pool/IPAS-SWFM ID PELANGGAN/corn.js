const cron = require("node-cron");
const processSeed = require("./ipasDataSync");

cron.schedule("10 44 09 * * *", async () => {
  const currentTime = new Date()
    .toString()
    .replace(/T/, ":")
    .replace(/\.\w*/, "");

  console.log("Cron job started at " + currentTime);
  await processSeed();
});
