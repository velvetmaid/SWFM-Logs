function toRadians(degrees) {
  return degrees * (Math.PI / 180);
}

function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371000;
  const dLat = toRadians(lat2 - lat1);
  const dLon = toRadians(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) *
      Math.cos(toRadians(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = R * c;
  return distance;
}

function calcRadius(lat1, lon1, lat2, lon2) {
  const x = haversineDistance(lat1, lon1, lat2, lon2);
  return x > 79.2 ? "INAPPROPRIATE" : x > 70 ? "SEMIAPPROPRIATE" : "APPROPRIATE";
}

const lat1 = -3.191625;
const lon1 = 104.568101;
const lat2 = -3.191640;
const lon2 = 104.570630;

console.log(`Distance: ${haversineDistance(lat1, lon1, lat2, lon2)}`);
console.log(`LatLong1: (${lat1}, ${lon1})`);
console.log(`LatLong2: (${lat2}, ${lon2})`);
console.log(`Distance (m): ${haversineDistance(lat1, lon1, lat2, lon2).toFixed(2)}`);
console.log(`Radius Status: ${calcRadius(lat1, lon1, lat2, lon2)}`);