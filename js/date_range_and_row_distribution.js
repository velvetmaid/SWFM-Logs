// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
// once result v1
// Total row dan jumlah hari
const totalRow = 600;
const jumlahHari = 30;

// Hitung jumlah row per hari
const jumlahPerHari = Math.floor(totalRow / jumlahHari);
const sisaRow = totalRow % jumlahHari;

// Buat array untuk menampung hasil
let data = [];

// Buat tanggal mulai
let tanggalMulai = new Date();

// Fungsi untuk menambahkan hari ke tanggal
function tambahHari(tanggal, hari) {
    let result = new Date(tanggal);
    result.setDate(result.getDate() + hari);
    return result;
}

// Distribusikan row ke setiap hari
for (let i = 0; i < jumlahHari; i++) {
    let tanggal = tambahHari(tanggalMulai, i);
    for (let j = 0; j < jumlahPerHari; j++) {
        data.push({ Tanggal: tanggal.toISOString().split('T')[0] });
    }
}

// Distribusikan sisa row ke beberapa hari pertama
for (let i = 0; i < sisaRow; i++) {
    let tanggal = tambahHari(tanggalMulai, i);
    data.push({ Tanggal: tanggal.toISOString().split('T')[0] });
}

// Tampilkan hasil
console.log(data);
// --------------------------------------------------------------------------
// --------------------------------------------------------------------------



// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
// once result v2
function createDateRange() {
    // Mendapatkan tanggal hari ini
    const today = new Date();
    
    // Mendapatkan tahun dan bulan dari tanggal hari ini
    const year = today.getFullYear();
    const month = today.getMonth();
    
    // Menentukan tanggal mulai (20 bulan sekarang)
    const startDate = new Date(year, month, 20);
    
    // Menentukan bulan dan tahun akhir
    let endYear = year;
    let endMonth = month + 1;
    
    // Jika bulan sekarang Desember
    if (endMonth > 11) {
        endYear += 1;
        endMonth = 0; // Januari
    }
    
    // Menentukan tanggal akhir (25 bulan berikutnya)
    const endDate = new Date(endYear, endMonth, 25);
    
    return { startDate, endDate };
}

const { startDate, endDate } = createDateRange();
console.log(`Start date: ${startDate}`);
console.log(`End date: ${endDate}`);
// --------------------------------------------------------------------------
// --------------------------------------------------------------------------



// both result
// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
function createDateRange() {
    const today = new Date();
    const year = today.getFullYear();
    const month = today.getMonth(); // Bulan dimulai dari 0 (Januari) hingga 11 (Desember)

    // Menentukan tanggal mulai (20 bulan sekarang)
    const startDate = new Date(year, month, 20);

    // Menentukan bulan dan tahun akhir
    let endYear = year;
    let endMonth = month + 1;
    if (endMonth > 11) { // Jika bulan berikutnya adalah Januari tahun depan
        endMonth = 0;
        endYear += 1;
    }

    // Menentukan tanggal akhir (25 bulan berikutnya)
    const endDate = new Date(endYear, endMonth, 25);

    return { startDate, endDate };
}

const { startDate, endDate } = createDateRange();
console.log(Start date: ${startDate});
console.log(End date: ${endDate});
// --------------------------------------------------------------------------
// --------------------------------------------------------------------------
