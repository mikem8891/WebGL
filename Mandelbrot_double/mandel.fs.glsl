// mandelbrot set fragment shader

#define PI 3.1415926535897932384

precision highp float;

uniform vec2 viewportDim;
uniform float minR;
uniform float maxR;
uniform float rngR;
uniform float avgR;
uniform float avgRe;
uniform float minI;
uniform float maxI;
uniform float rngI;
uniform float avgI;
uniform float avgIe;

void main(){
  
  // Transform pixel space to Mandelbrot set space
  /*
  vec2 c = vec2(
    gl_FragCoord.x * (maxR - minR) / viewportDim.x + minR,
    gl_FragCoord.y * (maxI - minI) / viewportDim.y + minI
  );
  */
  vec2 dc = vec2(
    (gl_FragCoord.x / viewportDim.x - 0.5) * rngR,
    (gl_FragCoord.y / viewportDim.y - 0.5) * rngI
  );
  vec2 c  =  vec2(avgR, avgI) + dc;
  vec2 ce = (vec2(avgR, avgI) - c) + dc + vec2(avgRe, avgIe);

  vec2 z  = c;
  vec2 ze = ce;
  float iter = 0.0;
  const float maxIters = 2000.0;
  const int maxii = 2000;
  
  // z(i+1) = z(i)^2 + c
  // i from 0 to 2000
  // while |z(2000)| < 2
  
  for (int i = 0; i < maxii; i++){
    float te = 2.0 * (ze.x * z.y + z.x * ze.y + ze.x * ze.y) + ce.y;
    ze.x = 2.0 * (z.x * ze.x - z.y * ze.y) + ze.x * ze.x - ze.y * ze.y + ce.x;
    ze.y = te;

    float t = 2.0 * z.x * z.y + c.y;    // temp var for z.y(i+1)
    z.x = z.x * z.x - z.y * z.y + c.x;  // z.x(i+1)
    z.y = t;
    
    float zx = z.x + ze.x;
    ze.x = ze.x - (zx - z.x);
    z.x = zx;
    float zy = z.y + ze.y;
    ze.y = ze.y - (zy - z.y);
    z.y = zy;
    if (zx * zx + zy * zy > 4.0){
      break;
    }
    
    iter += 1.0;
  }
  
  if (iter >= maxIters){
    discard;
  } else {
    float fi = 1.25*PI*sqrt(iter)/sqrt(maxIters);
//    float fi = 1.25*PI*log(1.0 + iter)/log(1.0 + maxIters);
    gl_FragColor = vec4(
      cos(fi - PI), cos(fi - 0.5*PI), 
      max(cos(fi), cos(fi - 1.5*PI)), 1.0);
  }
}
 