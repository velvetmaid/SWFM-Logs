function remainDayRange(startDate, dayRange) {
  const rangeMs = dayRange * 24 * 60 * 60 * 1000;
  const limitTime = new Date(startDate.getTime() + rangeMs);

  $parameters.IntervalInstance = setInterval(() => {
    const currentDate = new Date();

    if (currentDate > limitTime) {
      $actions.ResultRemainingInterval("SUSPEND");
      // console.log("Sudah lewat");
      $parameters.IsSuspend = true;
      clearInterval($parameters.IntervalInstance);
    } else {
      const remainTime = limitTime - currentDate;
      const remainSec = Math.floor(remainTime / 1000);
      const remainDays = Math.floor(remainSec / (24 * 60 * 60));
      const remainHours = Math.floor((remainSec % (24 * 60 * 60)) / (60 * 60));
      const remainMinutes = Math.floor((remainSec % (60 * 60)) / 60);
      const remainSeconds = remainSec % 60;

      const ouputText =
        remainDays > 0
          ? remainDays +
            " hari, " +
            remainHours +
            " jam, " +
            remainMinutes +
            " menit, " +
            remainSeconds +
            " detik"
          : remainHours > 0
          ? remainHours +
            " jam, " +
            remainMinutes +
            " menit, " +
            remainSeconds +
            " detik"
          : remainMinutes > 0
          ? remainMinutes + " menit, " + remainSeconds + " detik"
          : "< 1 menit";
      $actions.ResultRemainingInterval(ouputText);
      // console.log(remainDays + " hari, " + remainHours + " jam, " + remainMinutes + " menit, " + remainSeconds + " detik");
    }
  }, 1000);
}

const startDate = new Date($parameters.StartDate);
const dayRange = $parameters.DayRange;

remainDayRange(startDate, dayRange);
