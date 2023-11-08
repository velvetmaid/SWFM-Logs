let originalText = "Loading",
    loadingElement = document.createElement("p"),
    i = 0;

loadingElement.innerText = originalText;
document.body.appendChild(loadingElement);

setInterval(function() {
    loadingElement.append(".");
    i++;

    if(i === 4) {
        loadingElement.innerText = originalText;
        i = 0;
    }
}, 250);

// Without element
let onlyText = "Loading";
let loadingText = onlyText;
let x = 0;

setInterval(function() {
    loadingText += ".";
    i++;

    if (i === 4) {
        loadingText = onlyText;
        i = 0;
    }

    console.log(loadingText);
}, 500);

let text = "Loading";
let loadText = text;
let z = 0;

function updateloadText() {
    loadText += ".";
    z++;

    if (z === 4) {
        loadText = text;
        z = 0;
    }

    console.log(loadText);
    return loadText;
}

$parameters.loadText = setInterval(updateloadText, 250);
