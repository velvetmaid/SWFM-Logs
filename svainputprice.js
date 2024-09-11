let inputPrice = parseFloat($parameters.Price);
let inputPercent = parseFloat($parameters.Percent);
let minPrice = parseFloat($parameters.Min);
let maxPrice = parseFloat($parameters.Max);
let isManagementFee = $parameters.ManagementFee;

function validateInputPrice(inPrice, inPercent, inPriceMin, inPriceMax, isManagementFee) {
    const maxLimit = 1000000000;
    const minLimit = 0;
    if (inPrice > maxLimit || inPrice < minLimit) {
        $parameters.Message = "Invalid Price.";
        return;
    }

    if (!isNaN(inPriceMin) && isNaN(inPriceMax)) {
        if (inPrice < inPriceMin) {
            $parameters.Message =  `Price must be greater than ${inPriceMin}`;
            return; 
        }
    } else if (isNaN(inPriceMin) && !isNaN(inPriceMax)) {
        if (inPrice > inPriceMax) {
            $parameters.Message =  `Price must be less than ${inPriceMax}`;
            return;
        } 
    } else if (!isNaN(inPriceMin) && !isNaN(inPriceMax)) {
        if (inPrice < inPriceMin || inPrice > inPriceMax ) {
            $parameters.Message = `Price must be between ${inPriceMin} and ${inPriceMax}`;
            return;
            }
    }

    let finalPrice;
    if (isManagementFee) {
        finalPrice = inPrice + (inPrice * (inPercent / 100))
    } else {
        finalPrice = parseFloat(inPercent) / 100 * parseFloat(inPrice)
    }
    let resultString = finalPrice.toFixed(0)
    $parameters.ResultPrice = parseInt(resultString, 10)
    $parameters.Message = "Valid price"
    }

validateInputPrice(inputPrice, inputPercent, minPrice, maxPrice, isManagementFee)