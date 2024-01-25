// test visualize image
let template = `<img src='{{img}}'/>`;

pm.visualizer.set(template, {
  img: `data:image/jpeg;base64,${
    pm.response.json()["TagihanListrik"]["attachment_buktibayar"]
  }`,
});
