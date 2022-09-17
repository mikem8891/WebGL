// vertex shader

precision mediump float;

uniform mat4 mWorld;
uniform mat4 mView;
uniform mat4 mProj;

attribute vec3 vertPosition;
attribute vec3 vertNormal;
attribute vec3 vertTangent;
attribute vec3 vertBitan;
attribute vec2 vertTexCoord;

varying vec3 fragPosition;
varying vec3 fragNormal;
varying vec3 fragTangent;
varying vec3 fragBitan;
varying vec2 fragTexCoord;
varying vec3 fragTexCoord3;

void main(){
  fragPosition = (mWorld * vec4(vertPosition, 1.0)).xyz;
  fragNormal   = (mWorld * vec4(vertNormal,   0.0)).xyz;
  fragTangent  = (mWorld * vec4(vertTangent,  0.0)).xyz;
  fragBitan    = (mWorld * vec4(vertBitan,    0.0)).xyz;
  gl_Position  = mProj * mView * vec4(fragPosition, 1.0);
  fragTexCoord = vertTexCoord;
  fragTexCoord3= vertNormal;
}