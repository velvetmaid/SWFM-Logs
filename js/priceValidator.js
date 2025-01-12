// test visualize image
let template = `<img src='{{img}}'/>`;

pm.visualizer.set(template, {
  img: `data:image/jpeg;base64,${
    pm.response.json()["TagihanListrik"]["attachment_buktibayar"]
  }`,
});

function validateInputPriceWithLimit(
  inputPrice,
  priceMin,
  priceMaks,
  maxLimit = 1000000000,
  minLimit = -1000000000
) {
  if (inputPrice > maxLimit) {
    return `Input harga tidak boleh lebih dari ${maxLimit}`;
  }
  if (inputPrice < minLimit) {
    return `Input harga tidak boleh kurang dari ${minLimit}`;
  }

  if (priceMin !== null && priceMaks === null) {
    if (inputPrice < priceMin) {
      return `Input harga harus lebih besar atau sama dengan ${priceMin}`;
    }
  } else if (priceMin === null && priceMaks !== null) {
    if (inputPrice > priceMaks) {
      return `Input harga harus lebih kecil atau sama dengan ${priceMaks}`;
    }
  } else if (priceMin !== null && priceMaks !== null) {
    if (inputPrice < priceMin || inputPrice > priceMaks) {
      return `Input harga harus antara ${priceMin} dan ${priceMaks}`;
    }
  } else if (inputPrice < 0) {
    return `Input harga tidak boleh negatif`;
  }

  return "Input harga valid";
}

console.log(validateInputPriceWithLimit(1000000001, null, null)); // Input harga tidak boleh lebih dari 1000000000
console.log(validateInputPriceWithLimit(-1000000001, null, null)); // Input harga tidak boleh kurang dari -1000000000
