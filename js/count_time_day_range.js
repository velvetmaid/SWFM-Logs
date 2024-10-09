function remainDayRange(startDate, dayRange) {
    const rangeMs = dayRange * 24 * 60 * 60 * 1000;
    const limitTime = new Date(startDate.getTime() + rangeMs);

    const intervalId = setInterval(() => {
        const currentDate = new Date();

        if (currentDate > limitTime) {
            console.log(`Sudah lewat`);
            clearInterval(intervalId)
        } else {
            const remainTime = limitTime - currentDate;
            const remainSec = Math.floor(remainTime / 1000);
            const remainDays = Math.floor(remainSec / (24 * 60 * 60));
            const remainHours = Math.floor((remainSec % (24 * 60 * 60)) / (60 * 60));
            const remainMinutes = Math.floor((remainSec % (60 * 60)) / 60);
            const remainSeconds = remainSec % 60;
            console.log("Sisa waktu: " + remainDays + " hari, " + remainHours + " jam, " + remainMinutes + " menit, " + remainSeconds + " detik");
        }
    }, 1000);
}

const startDate = new Date(); 
const dayRange = 7; 

remainDayRange(startDate, dayRange);
