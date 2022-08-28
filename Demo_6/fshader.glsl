// fragment shader

precision mediump float;

struct DirectionalLight{
  vec3 direction;
  vec3 color;
};

uniform sampler2D sampler;
uniform vec3 ambLightInt;
uniform DirectionalLight sun;

varying vec3 fragPosition;
varying vec3 fragNormal;
varying vec2 fragTexCoord;

void main(){
  
  vec3 normSunDir  = normalize(sun.direction);
  vec3 surfaceNorm = normalize(fragNormal);
  
  vec4 texel = texture2D(sampler, fragTexCoord);
  
  vec3 lightInt = ambLightInt +  // ambient light
    sun.color * max(dot(normSunDir, surfaceNorm), 0.0) + // diffuse light
    sun.color * pow(max(dot()
  
  gl_FragColor = texel * vec4(sqrt(lightInt), 1.0); // sqrt for pseudo gamma correction
//  gl_FragColor = vec4(surfaceNorm, 1.0); // display normals for debugging
}