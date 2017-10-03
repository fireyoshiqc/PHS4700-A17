function g = g1(q0, t0, w0)
  a = [0 0 -9.8];
  g = [a q0(1:3)];
endfunction