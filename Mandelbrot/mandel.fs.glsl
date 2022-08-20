// mandelbrot set fragment shader

precision highp float;

uniform vec2 viewportDim;
uniform float minR;
uniform float maxR;
uniform float minI;
uniform float maxI;

void main(){
  
  // Transform pixel space to Mandelbrot set space
  vec2 c = vec2(
    gl_fragCoord.x * (maxR - minR) / viewportDim.x + minR,
    gl_fragCoord.y * (maxI - minI) / viewportDim.y + minI
  );
  
  vec2 z = c;
  float iterations = 0.0;
  float maxIterations = 2000.0;
  const int maxii = 2000;
  
  // z(i+1) = z(i)^2 + c
  // i from 0 to 2000
  // |z(2000)| < 2
  
  for (int i = 0; i < maxii; i++){
    float t = 2.0 * z.x * z.y + c.y;    // temp var for z.y(i+1)
    z.x = z.x * z.x - z.y * z.y + c.x;  // z.x(i+1)
    z.y = t;
    
  }
  
}
 