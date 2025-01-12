const totalRow = 5;
const jumlahHari = 3;

// Hitung jumlah row per hari
const jumlahPerHari = Math.floor(totalRow / jumlahHari);
const sisaRow = totalRow % jumlahHari;

// Buat array untuk menampung hasil
let data = [];
let inYear = 2025;
let inMonth = 0;
let inDay = 10;

// Buat tanggal mulai
const startDate = new Date();
startDate.setFullYear(inYear, inMonth, inDay);
// Fungsi untuk menambahkan hari ke tanggal
function tambahHari(tanggal, hari) {
  let result = new Date(tanggal);
  result.setDate(result.getDate() + hari);
  return result;
}

// Distribusikan row ke setiap hari
for (let i = 0; i < jumlahHari; i++) {
  let tanggal = tambahHari(startDate, i);
  for (let j = 0; j < jumlahPerHari; j++) {
    data.push(tanggal.toISOString().split("T")[0]);
  }
}

// Distribusikan sisa row ke beberapa hari pertama
for (let i = 0; i < sisaRow; i++) {
  let tanggal = tambahHari(startDate, i);
  data.push(tanggal.toISOString().split("T")[0]);
}

// Tampilkan hasil
console.log(data);
