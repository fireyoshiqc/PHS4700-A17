function g = gfrt(q0, m) % m est la masse de l'auto pour laquelle on calcule
  g = 9.81;
  v = q0(1:2);
  mu = 0.075;
  if (norm(v) < 50)
    mu = 0.15*(1-(norm(v)/100));
  endif
  % Force de frottement
  if norm(v) == 0
    f_frottement = [0, 0];
  else
    f_frottement = -mu*m*g*(v/norm(v));
  endif 
  % F = ma
  a = f_frottement/m;
  g = [a q0(1:2)];
endfunction