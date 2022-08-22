// fragment shader

precision mediump float;

struct DirectionalLight{
  vec3 direction;
  vec3 color;
};

uniform sampler2D sampler;
uniform vec3 ambLightInt;
uniform DirectionalLight sun;
//uniform vec3 sunlightInt;
//uniform vec3 sunlightDir;

varying vec2 fragTexCoord;
varying vec3 fragNormal;

void main(){
  
//  vec3 ambLightInt = vec3( 0.1,  0.1,  0.1);
//  vec3 sunlightInt = vec3( 1.5,  1.5,  1.5);
//  vec3 sunlightDir = vec3(-3.0,  1.0, -4.0);
  vec3 normSunDir  = normalize(sun.direction);
  vec3 surfaceNorm = normalize(fragNormal);
  
  vec4 texel = texture2D(sampler, fragTexCoord);
  
  vec3 lightInt = ambLightInt + 
    sun.color * max(dot(normSunDir, surfaceNorm), 0.0);
  
  gl_FragColor = texel * vec4(lightInt, 1.0);
//  gl_FragColor = vec4(surfaceNorm, 1.0); // for debugging
}