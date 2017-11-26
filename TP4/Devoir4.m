function [xi yi zi face] = Devoir4 (nout, nin, poso, name = "Graphique de la trajectoire")
  format short g
  
  constantes = defConstantes();
  
  #[s,t]=resoudreRayonCylindre(constantes, [0 0 5], [1, 1]/norm([1,1]))
  
%  # Angles en radians (put into the constants file)
%  anglePolaireInitial = 0
%  anglePolaireFinal = pi/2
%  angleAzimutalInitial = 
%  angleAzimutalFinal = 
%  
%  nAnglesPolaire = 
%  nAnglesAzimutal = 
%  
%  for nIterPolaire = 1:nAnglesPolaire
%    # Calculer l'angle polaire
%    anglePolaire = anglePolaireInitial + (2*nIterPolaire - 1)(anglePolaireFinal - anglePolaireInitial)/2*nIterPolaire;
%    
%    for nIterAzimutal = 1:nAnglesAzimutal
%      # Calculer l'angle azimutal pour l'iteration
%      angleAzimutal = angleAzimutalInitial + (2*nIterAzimutal - 1)(angleAzimutalFinal - angleAzimutalInitial)/2*nIterAzimutal;
%      
%      # Calculer le vecteur directeur initial
%      dInit = unit([sin(anglePolaire)*cos(angleAzimutal), sin(anglePolaire)cos(angleAzimutal), cos(anglePolaire)]);
%      
%      
%      # Determiner si le rayon entre dans le cylindre
%      (x - constantes.cylindre.centre(1))^2 + (y - constantes.cylindre.centre(2))^2 - (constantes.cylindre.rayon)^2 = 0;
%      
%      
%      #for ()


  % Calculs initiaux avant l'entree dans le cylindre
  
  v = [4+2*cos(5*pi/6), 4+2*sin(5*pi/6)]/norm([4+2*cos(5*pi/6), 4+2*sin(5*pi/6)])
  f = @(params) resoudreRayonCylindre(params, constantes, [0 0 5], v);
  [x, fval, exitflag] = fsolve(f, [0,0])
  s = x(0);
  zst = poso+dInit*s;
  rc = constantes.cylindre.centre;
  h = constantes.cylindre.hauteur;
  if (exitflag == 1 && zst(3) >= rc(3)-h/2 && zst(3) <= rc(3)+h/2)
    %collision valide avec le rayon du cylindre
  else
    %verifier avec le haut et le bas du cylindre
    s = resoudreHautBasCylindre(constantes, poso, dInit);
    if (s > 1000000) % Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
      % Discarder le rayon, ne devrait pas arriver si on choisit bien nos angles
    endif
  endif
      
      
endfunction

function F = resoudreRayonCylindre(params, constantes, r0, u)
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  h = constantes.cylindre.hauteur;
  
  xs = u(1)*params(1) + r0(1);
  ys = u(2)*params(1) + r0(2);
  #zs = dInit(3)*s + r0(3);
  xt = R*cos(params(2)) + rc(1);
  yt = R*sin(params(2)) + rc(2);
  ztbas = rc(3)-h/2;
  zthaut = rc(3)+h/2;
  
  F(1) = xs - xt;
  F(2) = ys - yt;
 
endfunction

function s = resoudreHautBasCylindre(constantes, r0, u)
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  h = constantes.cylindre.hauteur;
  shaut = (rc(3)+h/2-r0(3))/u(3);
  sbas = (rc(3)-h/2-r0(3))/u(3);
  s = Inf;
  if (shaut >= 0 && ((r0+s*u)-(rc+[0;0;h/2])) <= R)
    % Collision valide avec le haut du cylindre
    s = min(s, shaut);
  endif
  if (sbas >= 0 && ((r0+s*u)-(rc-[0;0;h/2])) <= R)
    % Collision valide avec le bas du cylindre
    s = min(s, sbas);
  endif
endfunction

function dessinerGraphique(constantes, positions, rotations, name)
  figure('name', name);
  view(2);
  grid on;
endfunction
