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

function toRadians(degrees) {
  return degrees * (Math.PI / 180);
}

function calcRadius(lat1, lon1, lat2, lon2) {
  const x = haversineDistance(lat1, lon1, lat2, lon2);
  return (textResult =
    x > 79.2 ? "INAPPROPRIATE" : x > 70 ? "SEMIAPPROPRIATE" : "APPROPRIATE");
}
console.log(haversineDistance(-6.2308786, 106.8171, -6.2308786, 106.81751));
console.log(calcRadius(-6.2308786, 106.8751, -6.2308786, 106.8751));
