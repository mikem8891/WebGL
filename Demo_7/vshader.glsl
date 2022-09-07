// vertex shader

precision mediump float;

uniform mat4 mWorld;
uniform mat4 mView;
uniform mat4 mProj;

attribute vec3 vertPosition;
attribute vec3 vertNormal;
attribute vec2 vertTexCoord;

varying vec3 fragPosition;
varying vec3 fragNormal;
varying vec2 fragTexCoord;

void main(){
  fragPosition = (mWorld * vec4(vertNormal, 1.0)).xyz;
  fragNormal   = (mWorld * vec4(vertNormal, 0.0)).xyz;
  gl_Position  = mProj * mView * vec4(fragPosition, 1.0);
  fragTexCoord = vertTexCoord;
}