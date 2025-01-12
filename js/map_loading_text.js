function getWeekNumber(date) {
  // Copy date so don't modify original
  date = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
  // Set to nearest Thursday: current date + 4 - current day number
  // Make Sunday's day number 7
  date.setUTCDate(date.getUTCDate() + 4 - (date.getUTCDay() || 7));
  // Get first day of year
  var yearStart = new Date(Date.UTC(date.getUTCFullYear(), 0, 1));
  // Calculate full weeks to nearest Thursday
  var weekNumber = Math.ceil(((date - yearStart) / 86400000 + 1) / 7);
  return weekNumber;
}

// Without element
let onlyText = "Loading";
let loadingText = onlyText;
let x = 0;

setInterval(function () {
  loadingText += ".";
  x++;

  if (x === 4) {
    loadingText = onlyText;
    x = 0;
  }

  console.log(loadingText);
}, 500);

let text = "Loading";
let loadText = text;
let z = 0;

function updateloadText() {
  loadText += ".";
  z++;

  if (z === 4) {
    loadText = text;
    z = 0;
  }

  console.log(loadText);
  return loadText;
}

$parameters.loadText = setInterval(updateloadText, 250);

// SAMPLE LIST SITE
var sitelanglot = [
  { name: "site1", lat: -40.99497, lon: 174.50808, status: "in progress" },
  { name: "site2", lat: -41.30269, lon: 173.63696, status: "completed" },
  { name: "site3", lat: -41.49413, lon: 173.5421, status: "in progress" },
  { name: "site4", lat: -40.98585, lon: 174.50659, status: "completed" },
  { name: "site5", lat: -40.93163, lon: 173.81726, status: "in progress" },
];

// TAMPILKAN MAP
var map = L.map("map").setView([-41.3058, 174.82082], 8);

// LOOPING LIST SITE KEMUDIAN TAMPILKAN ICON
for (var i = 0; i < sitelanglot.length; i++) {
  // Pilih ikon berdasarkan status
  var iconUrl =
    sitelanglot[i].status === "in progress"
      ? "TOWERBIRU.png"
      : "TOWERHITAM.png";

  var customIcon = L.icon({
    iconSize: [32, 32], //UKURAN ICON
    popupAnchor: [0, -32],
  });

  // DEFINE LIST SITE TADI
  var marker = new L.marker([sitelanglot[i].lat, sitelanglot[i].lon], {
    icon: customIcon,
  })
    .bindPopup(sitelanglot[i].name + sitelanglot[i].status)
    // bindpop up untuk menampilkan pop up ketika icon diklik
    .addTo(map);
}


// Distance KM Long & Lat
alert(getDistanceFromLatLonInKm(59.3293371,13.4877472,59.3225525,13.4619422).toFixed(1));



function getDistanceFromLatLonInKm(lat1,lon1,lat2,lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2-lat1);  // deg2rad below
  var dLon = deg2rad(lon2-lon1); 
  var a = 
    Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * 
    Math.sin(dLon/2) * Math.sin(dLon/2)
    ; 
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a)); 
  var d = R * c; // Distance in km
  return d;
}
function deg2rad(deg) {
  return deg * (Math.PI/180);
}