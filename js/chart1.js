let rawConfig = `{
    "chart": {
        "type": "area",
        "zooming": {}
    },
    "title": {
        "text": "Baru ini"
    },
    "legend": {},
    "xAxis": {
        "labels": {
            "style": {}
        }
    },
    "yAxis": [],
    "series": [],
    "plotOptions": {
        "column": {
            "dataLabels": {}
        }
    }
}`
let rawSeries = `[{"Data":[{"name":"Jun","y":"15"},{"name":"Nov","y":"115"}]}]`

let config = JSON.parse(rawConfig);
let parsedSeries = JSON.parse(rawSeries);

config.chart.type = 'column';

config.series = parsedSeries.map(ser => ({
  data: ser.Data.map(point => ({
    name: point.name,
    y: Number(point.y)
  }))
}));

console.log("Final config:", config);
console.log("Final config:", JSON.stringify(config, null, 2));
