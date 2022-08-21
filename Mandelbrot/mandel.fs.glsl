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
    gl_FragCoord.x * (maxR - minR) / viewportDim.x + minR,
    gl_FragCoord.y * (maxI - minI) / viewportDim.y + minI
  );
  
  vec2 z = c;
  float iterations = 0.0;
  float maxIterations = 500.0;
  const int maxii = maxIterations;
  
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
    
    iterations += 1.0;
  }
  
  if (iterations < maxIterations){
    discard;
  } else {
    gl_FragColor = vec4(0.0, 0.0, 1.0, 1.0);
  }
}
 