function qs = SEDRK4t0(q0, t0, w0, DeltaT, g, masse)
  k1= feval(g, q0, masse);
  k2= feval(g, (q0+k1*DeltaT/2), masse);
  k3= feval(g, (q0+k2*DeltaT/2), masse);
  k4= feval(g, (q0+k3*DeltaT), masse);
  qs= q0+ DeltaT*( k1 + 2*k2 + 2*k3 + k4 )/6;
endfunction