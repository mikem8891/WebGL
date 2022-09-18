// fragment shader

#define GAMMA 2.2

precision mediump float;

struct DirectionalLight{
  vec3 direction;
  vec3 color;
};

uniform samplerCube samplerText;
uniform samplerCube samplerSpec;
uniform sampler2D samplerNorm;
//uniform samplerCube samplerSky;
uniform vec3 ambLightInt;
uniform DirectionalLight sun;
uniform vec3 viewPos;

varying vec3 fragPosition;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBitan;
varying vec2 fragTexCoord;
varying vec3 fragTexCoord3;

float LinearToSRGB(float Lin){
  if (Lin <= 0.0031308049)
    return Lin*12.92;
  return 1.055*pow(Lin, 0.416666667)-0.055;
}

vec4 LinearToSRGB(vec4 Lin){
  float sR = LinearToSRGB(Lin.r);
  float sG = LinearToSRGB(Lin.g); 
  float sB = LinearToSRGB(Lin.b);
  return vec4(sR, sG, sB, Lin.a);
}

void main(){
  
  vec3 normSunDir    = normalize(sun.direction);
  vec3 texelNorm     = 2.0 * texture2D(samplerNorm, fragTexCoord).rgb - 1.0;
  vec3 normFragNorm  = normalize(fragNormal);
  vec3 normFragTan   = normalize(fragTangent - dot(normFragNorm, fragTangent));
  vec3 normFragBitan = cross(normFragNorm, normFragTan);
  mat3 tanSpace      = mat3(normFragTan, normFragBitan, normFragNorm);
  vec3 surfaceNorm   = normalize(tanSpace * texelNorm);
  vec3 reflectedRay  = reflect(-normSunDir, surfaceNorm);
  
//  vec4 texel = texture2D(samplerText, fragTexCoord);
  vec4 texel = textureCube(samplerText, fragTexCoord3);
  #if Convert_sRGB_to_Lin
  texel = texel * texel;
  #endif

  vec4 texelSpec = textureCube(samplerSpec, fragTexCoord3);
  
  vec3 lightInt = ambLightInt +  // ambient light
    sun.color * max(dot(normSunDir, surfaceNorm), 0.0); // diffuse light
  vec3 specInt =  texelSpec.rgb * sun.color * pow(max(dot(normalize(viewPos - fragPosition), reflectedRay), 0.0), 256.0); // specular light
  
  vec4 colorLin = texel * vec4(lightInt, 1.0) + vec4(specInt, 1.0); 
  gl_FragColor = LinearToSRGB(colorLin); // gamma correction
//  gl_FragColor = vec4(surfaceNorm, 1.0); // display normals for debugging
}