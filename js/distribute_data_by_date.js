function getStartDate() {
    return new Date(new Date().getFullYear(), 0, 20);
}

function getEndDate() {
    const endDate = new Date(new Date().getFullYear(), 1, 19);
    return endDate;
}

function generateDateRange(startDate, endDate) {
    const dateArray = [];
    for (let d = new Date(startDate); d <= endDate; d.setDate(d.getDate() + 1)) {
        dateArray.push(new Date(d));
    }
    return dateArray;
}

function distributeDataEvenly(totalData, dateRange) {
    const dataPerDay = Math.floor(totalData / dateRange.length);
    const remainder = totalData % dateRange.length;
    return dateRange.map((date, index) => ({
        date,
        data: dataPerDay + (index < remainder ? 1 : 0)
    }));
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
