// function getWeekNumber(d) {
//   d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
//   d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
//   const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
//   const weekNo = Math.ceil(((d - yearStart) / 86400000 + 1) / 7);
//   // return [d.getUTCFullYear(), weekNo];
//   return { d_year: d.getUTCFullYear(), d_week: weekNo };
//   // return weekNo;
// }
// // const abc = new Date(Date.UTC(2024, 0, 1));
// const abc = new Date("2024-12-30");
// // abc.getTime() + 7 * 60 * 60 * 1000
// // console.log(new Date());
// console.log(getWeekNumber(abc).d_week);
// console.log(getWeekNumber(abc).d_year);

function getWeekNumber(d) {
  d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
  d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
  const yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
  const weekNo = Math.ceil(((d - yearStart) / 86400000 + 1) / 7);

  return { d_year: d.getUTCFullYear(), d_week: weekNo };
}

// Example usage
const weekyear = new Date("2024-12-30");
const result = getWeekNumber(weekyear);

// Log the week number and year
console.log(result.d_week); // Week number
console.log(result.d_year); // Year

// Assuming you're working in an OutSystems context and need to assign these to output parameters
// $parameters.d_year = result.d_year;
// $parameters.d_week = result.d_week;

//
// function getWeekNumber2(d) {
//     d = new Date(Date.UTC(d.getFullYear(), d.getMonth(), d.getDate()));
//     d.setUTCDate(d.getUTCDate() + 4 - (d.getUTCDay() || 7));
//     var yearStart = new Date(Date.UTC(d.getUTCFullYear(), 0, 1));
//     var weekNo = Math.ceil(((d - yearStart) / 86400000 + 1) / 7);
//     if (weekNo < 1) {
//       yearStart = new Date(Date.UTC(d.getUTCFullYear() - 1, 0, 1));
//       weekNo = Math.ceil(((d - yearStart) / 86400000 + 1) / 7);
//     }
//     return [d.getUTCFullYear(), weekNo];
//   }

//   const xyz = new Date(Date.UTC(2024, 0, 0, 0, 0, 0));
//   console.log(getWeekNumber2(xyz));
