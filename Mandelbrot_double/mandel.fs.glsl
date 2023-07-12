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
uniform float ZERO;
uniform float ONE;

float f(float a){ return ONE*a + ZERO; } // faux function to prevent compiler optimizations
vec2 f(vec2 a){ return ONE*a + ZERO; } 

vec2 dbit(vec2 a){
  float cx = f(a.x + a.y);
  float cy = a.y - f(cx - a.x);
  return vec2(cx, cy);
}

vec2 dadd(vec2 a, vec2 b){
  float cx = f(a.x + b.x); // Most significant bits
  float ce = f(cx - b.x);
  float cy = f(a.x - ce) + f(b.x - f(cx - ce)) + a.y + b.y; //Accounting for any error in cx and adding the least significant bits
  return dbit(vec2(cx, cy));
}

vec2 dmul(vec2 a, vec2 b){
  float bit12 = 4096.0;     // Constant for shifting a value 12 bits
  float a12x = f(bit12 * a.x); 
  float b12x = f(bit12 * b.x);
  float axx = f(a.x + a12x) - a12x; // Truncates the 12 least sig bits in a.x
  float bxx = f(b.x + b12x) - b12x; // Truncates the 12 least sig bits in b.x
  float axy = f(a.x - axx); // The 12 least sig bits in a.x
  float bxy = f(b.x - bxx); // The 12 least sig bits in b.x
  float cx = a.x * b.x;  // Most significant bits of the result
  float cy = f(f(axx * bxx - cx) + f(axx * bxy) + f(axy * bxx)) + f(axy * bxy) + f(a.x * b.y) + a.y * b.x;
  return vec2(cx, cy);
}

vec2 dsq(vec2 a){
  float bit12 = 4096.0;     // Constant for shifting a value 12 bits
  float a12x = f(bit12 * a.x); 
  float axx = f(a.x + a12x) - a12x; // Truncates the 12 least sig bits in a.x
  float axy = a.x - axx; // The 12 least sig bits in a.x
  float cx = a.x * a.x;  // Most significant bits of the result
  float cy = f(f(axx * axx - cx) + f(2.0 * axx * axy)) + f(axy * axy + 2.0 * a.x * a.y);
  return vec2(cx, cy);
}

void main(){
  
  // Transform pixel space to Mandelbrot set space
  /*
  vec2 c = vec2(
    gl_FragCoord.x * (maxR - minR) / viewportDim.x + minR,
    gl_FragCoord.y * (maxI - minI) / viewportDim.y + minI
  );
  */
  vec2 cx = dadd(vec2(avgR, avgRe), vec2((gl_FragCoord.x / viewportDim.x - 0.5) * rngR, 0));
  vec2 cy = dadd(vec2(avgI, avgIe), vec2((gl_FragCoord.y / viewportDim.y - 0.5) * rngI, 0));

  vec2 x  = cx;
  vec2 y  = cy;
  float iter = 0.0;
  const float maxIters = 2000.0;
  const int maxii = 2000;
  
  // z(i+1) = z(i)^2 + c
  // i from 0 to 2000
  // while |z(2000)| < 2
  
  for (int i = 0; i < maxii; i++){

    vec2 t = dadd(2.0 * dmul(x, y), cy); // temp var for z.y(i+1)
    x = dadd(dadd(dsq(x), -dsq(y)), cx); // z.x(i+1) = z.x^2  - z.y^y  + c.x
    y = t;                               // z.y(i+1) = 2.0 * z.x * z.y + c.y
    
    vec2 mag = dadd(dsq(x), dsq(y));
    if (mag.x > 4.0){
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
 