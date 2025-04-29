let inputPrice = isNaN(parseFloat($parameters.Price)) ? 0 : parseFloat($parameters.Price);
let inputPercent = isNaN(parseFloat($parameters.Percent)) ? 0 : parseFloat($parameters.Percent);
let inputQty = isNaN(parseFloat($parameters.Qty)) ? 1 : parseFloat($parameters.Qty);
let minPrice = isNaN(parseFloat($parameters.Min)) ? null : parseFloat($parameters.Min);
let maxPrice = isNaN(parseFloat($parameters.Max)) ? null : parseFloat($parameters.Max);
let isManagementFee = $parameters.ManagementFee;

const formatCurrency = (value) => {
    return new Intl.NumberFormat("id-ID", { style: "currency", currency: "IDR" }).format(value);
};

function validateInputPrice(inPrice, inPercent, inQty, inPriceMin, inPriceMax, isManagementFee) {
    const maxLimit = 1000000000;
    const minLimit = 0;

    // Validasi jika harga tidak valid
    if (isNaN(inPrice) || inPrice > maxLimit || inPrice < minLimit) {
        $parameters.Message = "Invalid Price.";
        $parameters.IsValid = false;
        return;
    }

    // Jika Min dan Max Price belum ada, tampilkan pesan Range Price not available
    if (inPriceMin === null || inPriceMax === null) {
        $parameters.Message = "Range price not available.";
        $parameters.IsValid = false;
        return;
    }

    // Validasi jika harga lebih kecil dari minPrice
    if (!isNaN(inPriceMin) && inPrice < inPriceMin) {
        $parameters.Message = `Price must be greater than ${formatCurrency(inPriceMin)}`;
        $parameters.IsValid = false;
        return;
    }

    // Validasi jika harga lebih besar dari maxPrice
    if (!isNaN(inPriceMax) && inPrice > inPriceMax) {
        $parameters.Message = `Price must be less than ${formatCurrency(inPriceMax)}`;
        $parameters.IsValid = false;
        return;
    }

    // Validasi harga berada dalam rentang yang valid
    if (!isNaN(inPriceMin) && !isNaN(inPriceMax)) {
        if (inPrice < inPriceMin || inPrice > inPriceMax) {
            $parameters.Message = `Price must be between ${formatCurrency(inPriceMin)} and ${formatCurrency(inPriceMax)}`;
            $parameters.IsValid = false;
            return;
        }
    }

    // Kalkulasi harga akhir
    let finalPrice;
    if (isManagementFee) {
        finalPrice = (inPrice * inQty) + (inPrice * inQty * (inPercent / 100));
    } else {
        finalPrice = (inPercent / 100) * inPrice;
    }

    // Menyimpan hasil harga final
    $parameters.ResultPrice = Math.round(finalPrice);
    $parameters.Message = "Valid Price";
    $parameters.IsValid = true;
}

validateInputPrice(inputPrice, inputPercent, inputQty, minPrice, maxPrice, isManagementFee);
