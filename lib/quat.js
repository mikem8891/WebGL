var quat = {
  // q = x*I + y*j + z*k + w
  // q[0] = x
  // q[1] = y
  // q[2] = z
  // q[3] = w
  add : function(out, a, b){
    out[0] = a[0] + b[0];
    out[1] = a[1] + b[1];
    out[2] = a[2] + b[2];
    out[3] = a[3] + b[3];
  }
};