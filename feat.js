let originalText = "Loading",
  loadingElement = document.createElement("p"),
  i = 0;

loadingElement.innerText = originalText;
document.body.appendChild(loadingElement);

setInterval(function () {
  loadingElement.append(".");
  i++;

  if (i === 4) {
    loadingElement.innerText = originalText;
    i = 0;
  }
}, 250);

// Without element
let onlyText = "Loading";
let loadingText = onlyText;
let x = 0;

setInterval(function () {
  loadingText += ".";
  i++;

  if (i === 4) {
    loadingText = onlyText;
    i = 0;
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


