  precision mediump float;
  
  uniform sampler2D sampler;
  
  varying vec2 fragTexCoord;
  
  void main(){
    gl_FragColor = texture2D(sampler, fragTexCoord);
  }