function loadImage(url) {
  return new Promise( function (resolve, reject) {
    let img = new Image();
    img.onload = function () {return resolve(img);};
    img.onerror = function () { 
      return reject('Failed to load image from: ' + url);
    };
    img.src = url;
  });
}
async function loadText(url) {
  let responce = await fetch(url);
  let status = responce.status;
  if (200 <= status && status < 300){
    return responce.text();
  } else {
    throw 'Failed to load text from: ' + url;
  }
}
async function loadJSON(url) {
  let responce = await fetch(url);
  let status = responce.status;
  if (200 <= status && status < 300){
    return responce.json();
  } else {
    throw 'Failed to load JSON from: ' + url;
  }
}
async function loadCubemap(url, ext) {
  if (ext == null){
    ext = 'png';
  }
  let faces = await Promise.all([
    loadImage(url + 'posX.' + ext),
    loadImage(url + 'negX.' + ext),
    loadImage(url + 'posY.' + ext),
    loadImage(url + 'negY.' + ext),
    loadImage(url + 'posZ.' + ext),
    loadImage(url + 'negZ.' + ext)
  ]);
  return faces;
}