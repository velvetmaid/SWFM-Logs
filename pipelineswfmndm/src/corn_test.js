const cron = require("node-cron");

// second minute hour dayofmonth month day of week
cron.schedule("* * * * * *", function () {
  const currentTime = new Date()
    .toString()
    .replace(/T/, ":")
    .replace(/\.\w*/, "");

  console.log("running a task every sec " + currentTime);
});
