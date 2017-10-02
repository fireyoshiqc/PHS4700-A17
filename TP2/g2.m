function g = g2(q0, t0)
  constantes = defConstantes();
  % force gravitationnelle
  f = constantes.balle.m * [0 0 -9.8];
  % force de frottement visqueux
  aire_balle = pi*constantes.balle.r^2;
  f = f - (constantes.physiques.rho*constantes.physiques.cv*aire_balle/2)*norm(q0(1:3))*q0(1:3);
  % F = ma. Obtenir l'accélération
  a = f/constantes.balle.m;
  g = [a q0(1:3)];
endfunction