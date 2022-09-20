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

async function createLinkedProgram(gl,  vertexShaderURL, fragmentShaderURL){

  var vertexShaderText   = loadText(vertexShaderURL);
  var fragmentShaderText = loadText(fragmentShaderURL);
  
  var program = gl.createProgram();

  // Create Blank Shaders Object
  var vertexShader   = gl.createShader(gl.VERTEX_SHADER);
  var fragmentShader = gl.createShader(gl.FRAGMENT_SHADER);
  
  // Set shader source code
  gl.shaderSource(vertexShader,   await vertexShaderText);
  gl.shaderSource(fragmentShader, await fragmentShaderText);
  
  // Compiler shader with source code
  gl.compileShader(vertexShader);
  gl.compileShader(fragmentShader);
  
  // Check for compilation errors
  if (!gl.getShaderParameter(vertexShader, gl.COMPILE_STATUS)){
    alert('ERROR compiling vertex shader!', 
                  gl.getShaderInfoLog(vertexShader));
    return;
  }
  if (!gl.getShaderParameter(fragmentShader, gl.COMPILE_STATUS)){
    alert('ERROR compiling fragment shader!\n' + gl.getShaderInfoLog(fragmentShader));
    return;
  }
  
  // Create and link the program to run the shaders
  gl.attachShader(program, vertexShader);
  gl.attachShader(program, fragmentShader);
  gl.linkProgram(program);
  
  // Check for errors
  if (!gl.getProgramParameter(program, gl.LINK_STATUS)){
    alert('ERROR linking program\n' + 
                  gl.getProgramInfoLog(program));
    return;
  }
  gl.validateProgram(program);
  if (!gl.getProgramParameter(program, gl.VALIDATE_STATUS)){
    alert('ERROR validating program', 
                  gl.getProgramInfoLog(program));
    return;
  }
  console.log('Program loaded @:', performance.now());
  return program;
}