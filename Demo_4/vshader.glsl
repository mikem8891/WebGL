  precision mediump float;
  
  uniform mat4 mWorld;
  uniform mat4 mView;
  uniform mat4 mProj;
  
  attribute vec3 vertPosition;
  attribute vec2 vertTexCoord;
  
  varying vec2 fragTexCoord;

  void main(){
    gl_Position = mProj * mView * mWorld * vec4(vertPosition, 1.0);
    fragTexCoord = vertTexCoord;
  }