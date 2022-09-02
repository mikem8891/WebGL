// fragment shader

#define GAMMA 2.2

precision mediump float;

struct DirectionalLight{
  vec3 direction;
  vec3 color;
};

uniform sampler2D samplerText;
uniform sampler2D samplerSpec;
uniform vec3 ambLightInt;
uniform DirectionalLight sun;
uniform vec3 viewPos;

varying vec3 fragPosition;
varying vec3 fragNormal;
varying vec2 fragTexCoord;

void main(){
  
  vec3 normSunDir   = normalize(sun.direction);
  vec3 surfaceNorm  = normalize(fragNormal);
  vec3 reflectedRay = reflect(-normSunDir, surfaceNorm);
  
  vec4 texel = texture2D(samplerText, fragTexCoord);
  #if Convert_sRGB_to_Lin
  texel = texel * texel;
  #endif

  vec4 texelSpec = texture2D(samplerSpec, fragTexCoord);
  
  vec3 lightInt = ambLightInt +  // ambient light
    sun.color * max(dot(normSunDir, surfaceNorm), 0.0); // diffuse light
  vec3 specInt =  texelSpec.rgb * sun.color * pow(max(dot(normalize(viewPos - fragPosition), reflectedRay), 0.0), 256.0); // specular light
  
  vec4 colorLin = texel * vec4(lightInt, 1.0) + vec4(specInt, 1.0); 
  gl_FragColor = pow(colorLin, vec4(1.0/GAMMA)); // pseudo gamma correction
//  gl_FragColor = vec4(surfaceNorm, 1.0); // display normals for debugging
}