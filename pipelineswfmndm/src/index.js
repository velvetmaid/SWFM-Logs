const cron = require("node-cron");
const processFNA = require("./seed_fna");

cron.schedule("40 03 17 * * *", async () => {
  const currentTime = new Date()
    .toString()
    .replace(/T/, ":")
    .replace(/\.\w*/, "");

  console.log("Cron job started at " + currentTime);
  await processFNA();
});
