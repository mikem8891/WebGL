// fragment shader

precision mediump float;

struct DirectionalLight{
  vec3 direction;
  vec3 color;
};

uniform sampler2D sampler;
uniform vec3 ambLightInt;
uniform DirectionalLight sun;

varying vec2 fragTexCoord;
varying vec3 fragNormal;

void main(){
  
  vec3 normSunDir  = normalize(sun.direction);
  vec3 surfaceNorm = normalize(fragNormal);
  
  vec4 texel = texture2D(sampler, fragTexCoord);
  
  vec3 lightInt = ambLightInt + 
    sun.color * max(dot(normSunDir, surfaceNorm), 0.0);
  
  vec4 linearColor = texel * vec4(lightInt, 1.0);
  gl_FragColor = sqrt(linearColor);  // pseudo gamma correction
//  gl_FragColor = vec4(surfaceNorm, 1.0); // display normals for debugging
}