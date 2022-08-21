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
  const int maxii = 500;
  
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
  
  vec3 setComColor = vec3(0.0, 0.0, 1.0);
  
  if (iterations >= maxIterations){
    discard;
  } else {
    setComColor = vec3(
      max(min(4.0*(iterations - maxIterations/4.0)/maxIterations, -2.0*((iterations-maxIterations)/maxIterations)), 0.0),
      max(min(4.0*iterations/maxIterations, 1.0 - 4.0*((iterations-maxIterations/4.0)/maxIterations)), 0.0), 
      max(max(1.0 - 4.0*iterations/(maxIterations), 2.0*(iterations - maxIterations/2.0)), 0.0)
    );
    gl_FragColor = vec4(setComColor, 1.0);
  }
}
 