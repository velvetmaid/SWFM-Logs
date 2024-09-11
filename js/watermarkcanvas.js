let imgW = document.createElement("img");
// var wmimg = document.createElement("img");
let canvas = document.createElement('canvas');
let ctx = canvas.getContext("2d");

imgW.onload = () => {
  let watermark = document.createElement("img");
  
  watermark.onload = function() {applyTranparency(canvas,ctx,watermark)};

  watermark.setAttribute('crossOrigin', 'anonymous');
  watermark.src = canvas.toDataURL("image/png"); 
};

imgW.setAttribute('crossOrigin', 'anonymous');
imgW.src = "data:image/jpeg;base64," + $parameters.image;

// wmimg.setAttribute('crossOrigin', 'anonymous');
// wmimg.src = $parameters.WFMLogo;

function applyTranparency (canvas, ctx, watermark) {
  canvas.width = window.innerWidth;
  canvas.height = 145;
  
  ctx.fillStyle = "black";
  ctx.fillRect(0, 0, canvas.width, canvas.height);
  ctx.drawImage(watermark, 0, 0);
  ctx.font = "bold 25px Arial";
  ctx.fillStyle = "rgb(255, 255, 255)";
  ctx.canvas.style.position = "absolute";
  ctx.canvas.style.left = "0";
//   ctx.textAlign = "center";

// if (canvas.width >= 1200) {
//     x = canvas.width / 3;
// }

const txt = $parameters.watermarkText + '\n' + $parameters.watermarkText2 + '\n' + $parameters.watermarkText3 + '\n' + $parameters.watermarkText4 + '\n' + $parameters.watermarkText5 ;
const x = 0;
const y = 30;
const lineheight = 25;
const lines = txt.split('\n');

for (let i = 0; i < lines.length; i++) {
  ctx.fillText(lines[i], x, y + (i * lineheight));
}

  let image = ctx.getImageData(0, 0, canvas.width, canvas.height);
  let imageData = image.data,
      length = imageData.length;

  let opacity = (255 / (100 / $parameters.opacity));

  for (let i = 3; i < length; i += 4){  
    imageData[i] = (imageData[i] < opacity) ? imageData[i] : opacity;
  }
  image.data = imageData;
  ctx.putImageData(image, 0, 0);

  watermark.onload = () => {applyWatermark(canvas, ctx, imgW, watermark)};
  watermark.src = canvas.toDataURL("image/png");
  watermark.width = canvas.width;
  watermark.height = canvas.height;          
}

// watermark logo
function applyWatermark(canvas, ctx, imgW, watermark) {
    canvas.width = imgW.width || imgW.offsetWidth;
    canvas.height = imgW.height || imgW.offsetHeight;
    ctx.drawImage(imgW, 0, 0);
    // ctx.drawImage(wmimg, 275, 20, 200, 125);

    let position = $parameters.position,
    x = 0,
    y = 0;

    if (position.indexOf("top") != -1)
      y = $parameters.margin;
    else
      y = canvas.height - watermark.height - $parameters.margin;

    if (position.indexOf("left") != -1)
      x = $parameters.margin;
    else
        x = canvas.width - watermark.width - $parameters.margin;

    ctx.drawImage(watermark, x, y);

    let imageWatermarked = canvas.toDataURL("image/jpeg", $parameters.quality);    
    imageWatermarked = imageWatermarked.substring(imageWatermarked.indexOf(',') + 1);

    $parameters.watermarkedImage = imageWatermarked;       
    $resolve();    
}