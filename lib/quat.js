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
    return out;
  },
  sub : function(out, a, b){
    out[0] = a[0] - b[0];
    out[1] = a[1] - b[1];
    out[2] = a[2] - b[2];
    out[3] = a[3] - b[3];
    return out;
  },
  mul : function(out, a, b){
    out[0] =  a[0]*b[3] + a[1]*b[2] - a[2]*b[1] + a[3]*b[0];
    out[1] = -a[0]*b[2] + a[1]*b[3] + a[2]*b[0] + a[3]*b[1];
    out[2] =  a[0]*b[1] - a[1]*b[0] + a[2]*b[3] + a[3]*b[2];
    out[3] = -a[0]*b[0] - a[1]*b[1] - a[2]*b[2] + a[3]*b[3];
    return out;
  },
  neg : function(out, a){
    out[0] = -a[0];
    out[1] = -a[1];
    out[2] = -a[2];
    out[3] = -a[3];
    return out;
  },
  conj : function(out, a){
    out[0] = -a[0];
    out[1] = -a[1];
    out[2] = -a[2];
    out[3] =  a[3];
    return out;
  },
  len : function(a){
    let x = a[0];
    let y = a[1];
    let z = a[2];
    let w = a[3];
    return Math.hypot(x, y, z, w);
  },
  lenSq : function(a){
    return a[0]*b[0] + a[1]*b[1] + a[2]*b[2] + a[3]*b[3];
  },
  inv : function(out, a){
    let invSq = 1/this.lenSq(a);
    out[0] = -a[0]*invSq;
    out[1] = -a[1]*invSq;
    out[2] = -a[2]*invSq;
    out[3] =  a[3]*invSq;
    return out;
  }
};