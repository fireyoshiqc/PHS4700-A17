function qs = SEDRK4t0(q0, t0, w0, DeltaT, g)
  k1= feval(g, q0, t0, w0 );
  k2= feval(g, (q0+k1*DeltaT/2), (t0+DeltaT/2), w0);
  k3= feval(g, (q0+k2*DeltaT/2), (t0+DeltaT/2), w0);
  k4= feval(g, (q0+k3*DeltaT),(t0+DeltaT), w0);
  qs= q0+ DeltaT*( k1 + 2*k2 + 2*k3 + k4 )/6;
endfunction