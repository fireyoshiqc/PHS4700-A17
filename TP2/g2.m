function g = g2(constantes, q0, w0)
  aire_balle = pi*constantes.balle.r^2;
  f = constantes.balle.m * [0 0 -9.8];
  f = f - (constantes.physiques.rho*constantes.physiques.cv*aire_balle/2)*norm(q0(1:3))*q0(1:3);
  a = f/constantes.balle.m;
  g = [a q0(1:3)];
endfunction