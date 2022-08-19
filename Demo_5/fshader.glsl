// fragment shader
precision mediump float;

uniform sampler2D sampler;

varying vec2 fragTexCoord;
varying vec3 fragNormal;

void main(){
  gl_FragColor = vec4(fragNormal, 1.0)
  // gl_FragColor = texture2D(sampler, fragTexCoord);
}