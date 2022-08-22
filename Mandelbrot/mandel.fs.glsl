// mandelbrot set fragment shader

#define PI 3.1415926535897932384

precision highp float;

uniform vec2 viewportDim;
uniform float minR;
uniform float maxR;
uniform float minI;
uniform float maxI;

void main(){
  
  // Transform pixel space to Mandelbrot set space
  const vec2 c = vec2(
    gl_FragCoord.x * (maxR - minR) / viewportDim.x + minR,
    gl_FragCoord.y * (maxI - minI) / viewportDim.y + minI
  );
  
  vec2 z = c;
  float iter = 0.0;
  const float maxIters = 2000.0;
  const int maxii = 2000;
  
  // z(i+1) = z(i)^2 + c
  // i from 0 to 2000
  // while |z(2000)| < 2
  
  for (int i = 0; i < maxii; i++){
    float t = 2.0 * z.x * z.y + c.y;    // temp var for z.y(i+1)
    z.x = z.x * z.x - z.y * z.y + c.x;  // z.x(i+1)
    z.y = t;
    
    if (z.x * z.x + z.y * z.y > 4.0){
      break;
    }
    
    iter += 1.0;
  }
  
  if (iter >= maxIters){
    discard;
  } else {
    float fi = 1.25*PI*log(1 + iter)/log(1 + maxIter);
    gl_FragColor = vec4(cos(fi - PI), cos(fi - 0.5*PI), max(cos(fi), cos(fi - 1.5*PI)), 1.0);
  }
}
 