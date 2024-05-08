let inputPrice = parseFloat($parameters.Price);
let inputPercent = parseFloat($parameters.Percent);
let minPrice = parseFloat($parameters.Min);
let maxPrice = parseFloat($parameters.Max);

console.log(inputPrice + "-" + inputPercent + "-" + minPrice + "-" + maxPrice);

function validateInputPrice(inPrice, inPercent, inPriceMin, inPriceMax) {
  const maxLimit = 1000000000;
  const minLimit = 0;

  if (inPrice > maxLimit || inPrice < minLimit) {
    $parameters.Message = "Invalid Price.";
    return;
  }

  if (!isNaN(inPriceMin) && isNaN(inPriceMax)) {
    if (inPrice < inPriceMin) {
      $parameters.Message = `Input price must be greater than ${inPriceMin}`;
      return;
    }
  } else if (isNaN(inPriceMin) && !isNaN(inPriceMax)) {
    if (inPrice > inPriceMax) {
      $parameters.Message = `Input price must be less thani ${inPriceMax}`;
      return;
    }
  } else if (!isNaN(inPriceMin) && !isNaN(inPriceMax)) {
    if (inPrice < inPriceMin || inPrice > inPriceMax) {
      $parameters.Message = `Input price must be between ${inPriceMin} and ${inPriceMax}`;
      return;
    }
  }

  let resultPrice = (parseFloat(inPercent) / 100) * parseFloat(inPrice);
  let resultString = resultPrice.toFixed(0);
  $parameters.ResultPrice = parseInt(resultString, 10);
  $parameters.Message = "Valid price";
}

validateInputPrice(inputPrice, inputPercent, minPrice, maxPrice);

console.log(validateInputPrice(inputPrice, inputPercent, minPrice, maxPrice));
