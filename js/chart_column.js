function getData(n) {
    const arr = [];
    let a, b, c, spike;
    for (let i = 0; i < n; i = i + 1) {
        if (i % 100 === 0) {
            a = 2 * Math.random();
        }
        if (i % 1000 === 0) {
            b = 2 * Math.random();
        }
        if (i % 10000 === 0) {
            c = 2 * Math.random();
        }
        if (i % 50000 === 0) {
            spike = 10;
        } else {
            spike = 0;
        }
        arr.push([i, 2 * Math.sin(i / 100) + a + b + c + spike + Math.random()]);
    }
    return arr;
}

const data = getData(10);

const configJSON = {
    chart: {
        type: 'column',
        zooming: {
            type: 'x'
        },
        panning: true,
        panKey: 'shift'
    },
    title: {
        text: 'Highcharts drawing ' + data.length + ' points'
    },
    subtitle: {
        text: 'Using the Boost module'
    },
    tooltip: {
        valueDecimals: 2
    },
    series: [{
        data: data
    }]
};

console.log(configJSON); 
// 
// 
// 

function getData(n) {
    const arr = [];
    let a = 0, b = 0, c = 0, spike = 0;

    for (let i = 0; i < n; i++) {
        if (i % 100 === 0) a = 2 * Math.random();
        if (i % 1000 === 0) b = 2 * Math.random();
        if (i % 10000 === 0) c = 2 * Math.random();
        spike = (i % 50000 === 0) ? 10 : 0;

        arr.push([
            i,
            2 * Math.sin(i / 100) + a + b + c + spike + Math.random()
        ]);
    }
    return arr;
}

const data = getData(50);

const baseConfig = {
    chart: {
        zooming: { type: 'x' },
        panning: true,
        panKey: 'shift'
    },
    title: {
        text: 'Highcharts drawing ' + data.length + ' points'
    },
    subtitle: {
        text: 'Using the Boost module'
    },
    tooltip: {
        valueDecimals: 2
    },
    plotOptions: {
        series: {
            colorByPoint: true
        }
    },
    series: [{
        data: data
    }]
};

console.time('column');
Highcharts.chart('containerColumn', {
    ...structuredClone(baseConfig), 
    chart: {
        ...baseConfig.chart,
        type: 'column'
    }
});
console.timeEnd('column');

console.time('pie');
Highcharts.chart('containerPie', {
    ...structuredClone(baseConfig),
    chart: {
        ...baseConfig.chart,
        type: 'pie'
    }
});
console.timeEnd('pie');




