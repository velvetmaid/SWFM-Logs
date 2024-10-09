function getStartDate() {
    const today = new Date();
    const year = today.getFullYear();
    const month = 0;
    return new Date(year, month, 20);
}

function getEndDate() {
    const today = new Date();
    const year = today.getFullYear();
    const month = 0;
    
    let endYear = year;
    let endMonth = month + 1;
    
    if (endMonth > 11) {
        endYear += 1;
        endMonth = 0; // Januari
    }

    return new Date(endYear, endMonth, 19);
}

function generateDateRange(startDate, endDate) {
    const dateArray = [];
    let currentDate = new Date(startDate);
    
    while (currentDate <= endDate) {
        dateArray.push(new Date(currentDate));
        currentDate.setDate(currentDate.getDate() + 1);
    }
    
    return dateArray;
}

function distributeDataEvenly(totalData, dateRange) {
    const dataPerDay = Math.floor(totalData / dateRange.length);
    const remainder = totalData % dateRange.length;
    const distribution = dateRange.map((date, index) => ({
        date,
        data: dataPerDay + (index < remainder ? 1 : 0)
    }));
    
    return distribution;
}

const startDate = getStartDate();
const endDate = getEndDate();
const dateRange = generateDateRange(startDate, endDate);

const totalData = 100;
const distributedData = distributeDataEvenly(totalData, dateRange);

console.log(`Start date: ${startDate}`);
console.log(`End date: ${endDate}`);
console.log('Distributed data:');
distributedData.forEach(entry => {
    console.log(`${entry.date.toDateString()}: ${entry.data} items`);
});