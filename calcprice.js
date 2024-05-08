let params = {
    Price: "1500", // Example value
    Percent: "90%", // Example value
    Min: "500", // Example value
    Max: "1500", // Example value
    Message: "", // Placeholder for the message output
    ResultPrice: 0 // Placeholder for the result price output
};

let inputPrice = parseFloat(params.Price);
let inputPercent = parseFloat(params.Percent);
let minPrice = parseFloat(params.Min);
let maxPrice = parseFloat(params.Max);

function validateInputPrice(inPrice, inPercent, inPriceMin, inPriceMax) {
    console.log(`Validating: Price=${inPrice}, Percent=${inPercent}, Min=${inPriceMin}, Max=${inPriceMax}`);
    
    if (inPrice > 1000000000 || inPrice < 0) {
        console.log("Price out of general bounds.");
        params.Message = "Invalid Price.";
        return;
    }

    if (!isNaN(inPriceMin) && isNaN(inPriceMax)) {
        if (inPrice < inPriceMin) {
            console.log("Price below minimum.");
            params.Message = `Input price must be greater than ${inPriceMin}`;
            return;
        }
    } else if (isNaN(inPriceMin) && !isNaN(inPriceMax)) {
        if (inPrice > inPriceMax) {
            console.log("Price above maximum.");
            params.Message = `Input price must be less than ${inPriceMax}`;
            return;
        }
    } else if (!isNaN(inPriceMin) && !isNaN(inPriceMax)) {
        if (inPrice < inPriceMin || inPrice > inPriceMax) {
            console.log("Price outside of specified range.");
            params.Message = `Input price must be between ${inPriceMin} and ${inPriceMax}`;
            return;
        }
    }

    let resultPrice = inPercent / 100 * inPrice;
    params.ResultPrice = Math.round(resultPrice);
    params.Message = "Valid price";
    console.log("Price validation passed.");
}

validateInputPrice(inputPrice, inputPercent, minPrice, maxPrice);
console.log(params.Message, params.ResultPrice);