function [xi yi zi face] = Devoir4 (nout, nin, poso, name = "Graphique de la trajectoire")
  format short g
  
  constantes = defConstantes();
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  h = constantes.cylindre.hauteur;
  
  #[s,t]=resoudreRayonCylindre(constantes, [0 0 5], [1, 1]/norm([1,1]))
  
  # Angles en radians (put into the constants file)
  anglePolaireInitial = atan((4+2*sin(10*pi/6))/(4+2*cos(10*pi/6)))
  anglePolaireFinal = atan((4+2*sin(5*pi/6))/(4+2*cos(5*pi/6)))
  angleAzimutalInitial = atan((sqrt(4^2+4^2)-R)/(rc(3)+h/2-poso(3)))
  if (poso(3) < 2)
    angleAzimutalFinal = atan((sqrt(4^2+4^2)+R)/(rc(3)-h/2-poso(3)))
  else
    angleAzimutalFinal = pi+atan((sqrt(4^2+4^2)-R)/(rc(3)-h/2-poso(3)))
  end
  
  nAnglesPolaire = 0;
  nAnglesAzimutal = 0;
  
  for nIterPolaire = 1:nAnglesPolaire
    # Calculer l'angle polaire
    anglePolaire = anglePolaireInitial + (2*nIterPolaire - 1)(anglePolaireFinal - anglePolaireInitial)/2*nIterPolaire;
    
    for nIterAzimutal = 1:nAnglesAzimutal
      # Calculer l'angle azimutal pour l'iteration
      angleAzimutal = angleAzimutalInitial + (2*nIterAzimutal - 1)(angleAzimutalFinal - angleAzimutalInitial)/2*nIterAzimutal;
      
      # Calculer le vecteur directeur initial
      dInit = unit([sin(anglePolaire)*cos(angleAzimutal), sin(anglePolaire)cos(angleAzimutal), cos(anglePolaire)]);  

      # Determiner si le rayon entre dans le cylindre
      # Si le rayon ne touche pas au cylindre 
      # TODO Assign white? colour to pixel?
      #if (neTouchePas)
      #  continue;

      # Calculs initiaux avant l'entree dans le cylindre
      v = [4+2*cos(5*pi/6), 4+2*sin(5*pi/6)]/norm([4+2*cos(5*pi/6), 4+2*sin(5*pi/6)])
      f = @(params) resoudreRayonCylindre(params, constantes, [0 0 5], v);
      [x, fval, exitflag] = fsolve(f, [0,0])
      s = x(0);
      zst = poso+dInit*s;
      rc = constantes.cylindre.centre;
      h = constantes.cylindre.hauteur;
      if (exitflag == 1 && zst(3) >= rc(3)-h/2 && zst(3) <= rc(3)+h/2)
        #collision valide avec le rayon du cylindre
      else
        #verifier avec le haut et le bas du cylindre
        s = resoudreHautBasCylindre(constantes, poso, dInit);
        if (s > 1000000)  # Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
          # Discarder le rayon, ne devrait pas arriver si on choisit bien nos angles
        endif
      endif
      
      # Si le rayon touche au cylindre
      posObservateur = poso;
      pointIntersection = [0, 0, 0];  # TODO Apply magic courbe parametrique fuckery
      distanceParcourue = norm(pointIntersection - posObservateur);
      
      # Determiner la normale d'une surface tangante au cylindre au point d'intersection (i)
      centreDuCercle = [constantes.cylindre.centre(1), constantes.cylindre.centre(2), pointIntersection(3)];
      i = (pointIntersection - centreDuCercle);
      i = i/norm(i);
      
      # TODO Mettre le calcul d'angle d'incidence dans une fonction separee
      # Calculer la normale du plan d'incidence (j)
      j = cross(dInit, i);
      j = j/norm(j);
      
      # Determiner l'angle d'incidence du rayon
      k = cross(i, j);
      k = k/norm(k);
      angleIncidence = asin(dot(dInit, k));
      
      # Rejeter le rayon si elle est reflechie par le cylindre
      nLiquide = nout;
      nCylindre = nin;
      if (estReflechie(nLiquide, nCylindre, angleIncidence))
        # Reflexion sur la surface du cylindre (reflexion totale interne du liquide)
        # TODO Mettre ce pixel en blanc? Et passer au prochain rayon
        continue;
      
      # Calculer la direction refracte du rayon
      # TODO Need to give better variable names
      angleTransmis = asin((nLiquide/nCylindre)*sin(angleIncidence));
      dFinal = -i*cos(angleTransmis) + k*sin(angleTransmis);
      
      # A l'interieur du cylindre
      for nReflectTotInterne = 1:100  # On se limite a 100 reflexions internes
        dRayonIncident = dFinal;
        
        # Calculer le prochain point d'intersection
        prochainPointIntersection = [0, 0, 0];  # TODO Apply magic courbe parametrique fuckery
        # TODO Return a variable or something that says what it collided with

        # Calculer la distance parcourue
        distanceParcourue = distanceParcourue + norm(prochainPointIntersection - pointIntersection);
        pointIntersection = prochainPointIntersection;
        
        # Si le rayon a toucher a l'objet
        #if ()
          # TODO Mettre la couleur appropriee and go to the next rayon
          # (the distance is already accurate & dInit has the initial direction)
          
        # Si le rayon touche au cylindre il faut determiner l'angle d'incidence
        # Determiner la normale d'une surface tangante au cylindre au point d'intersection (i)
        centreDuCercle = [constantes.cylindre.centre(1), constantes.cylindre.centre(2), pointIntersection(3)];
        i = (centreDuCercle - pointIntersection);
        i = i/norm(i);
      
        # Calculer la normale du plan d'incidence (j)
        j = cross(dInit, i);
        j = j/norm(j);
      
        # Determiner l'angle d'incidence du rayon
        k = cross(i, j);
        k = k/norm(k);
        angleIncidence = asin(dot(dInit, k));
        
        #if (estTransmise(nCylindre, nLiquide, angleIncidence))
          # TODO Mettre white or just not do anything? and go to the next rayon
        
        # Si le rayon est reflechie dans le cylindre calculer le prochain vecteur directeur
        dFinal = cos(angleIncidence)*i + sin(angleIncidence)*k;
endfunction

function estRefl = estReflechie(nInit, nFinal, angleInit)
  estRefl = (nInit > nFinal) && (angleInit < -abs(arcsin(nFinal/nInit))) && (angleInit > abs(arcsin(nFinal/nInit)));
end function

function estTrans = estTransmise(nInit, nFinal, angleInit)
  estTrans = not(estReflechie(nInit, nFinal, angleInit));
end function

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
  s = Inf;
  if (u(3)!=0)
    shaut = (rc(3)+h/2-r0(3))/u(3);
    sbas = (rc(3)-h/2-r0(3))/u(3); 
    if (shaut >= 0 && ((r0+s*u)-(rc+[0;0;h/2])) <= R)
      % Collision valide avec le haut du cylindre
      s = min(s, shaut);
    endif
    if (sbas >= 0 && ((r0+s*u)-(rc-[0;0;h/2])) <= R)
      % Collision valide avec le bas du cylindre
      s = min(s, sbas);
    endif
  endif
  
endfunction

function dessinerGraphique(constantes, positions, rotations, name)
  figure('name', name);
  view(2);
  grid on;
endfunction
