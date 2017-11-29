function [xi yi zi face] = Devoir4 (nout, nin, poso, name = "Rayons")
  format short g
  
  constantes = defConstantes();
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  h = constantes.cylindre.hauteur;
  
  figure('name', name);
  
  grid on;
  [cx, cy, cz] = cylinder();
  surf(2*cx+rc(1), 2*cy+rc(2), h*cz+rc(3)-h/2, 'FaceAlpha', 0.0)
   
  #[s,t]=resoudreRayonCylindre(constantes, [0 0 5], [1, 1]/norm([1,1]))  #TODO Remove?
  
  # Angles en radians (put into the constants file)
  anglePolaireInitial = atan((rc(2)+2*sin(10*pi/6))/(rc(1)+2*cos(10*pi/6)))
  anglePolaireFinal = atan((rc(2)+2*sin(5*pi/6))/(rc(1)+2*cos(5*pi/6)))
  angleAzimutalInitial = atan((sqrt(rc(1)^2+rc(2)^2)-R)/(rc(3)+h/2-poso(3)))
  if (poso(3) < (rc(3)-h/2))
    angleAzimutalFinal = atan((sqrt(rc(1)^2+rc(2)^2)+R)/(rc(3)-h/2-poso(3)))
  else
    angleAzimutalFinal = pi+atan((sqrt(rc(1)^2+rc(2)^2)-R)/(rc(3)-h/2-poso(3)))
  end
  
  nAnglesPolaire = 1000;  # TODO Optimize
  nAnglesAzimutal = 1000;
  
  for nIterPolaire = 1:nAnglesPolaire
    # Calculer l'angle polaire
    anglePolaire = anglePolaireInitial + (2*nIterPolaire - 1)(anglePolaireFinal - anglePolaireInitial)/2*nIterPolaire;
    
    for nIterAzimutal = 1:nAnglesAzimutal
      # Calculer l'angle azimutal pour l'iteration
      angleAzimutal = angleAzimutalInitial + (2*nIterAzimutal - 1)(angleAzimutalFinal - angleAzimutalInitial)/2*nIterAzimutal;
      
      # Calculer le vecteur directeur initial
      dInit = [sin(anglePolaire)*cos(angleAzimutal), sin(anglePolaire)sin(AngleAzimutal), cos(anglePolaire)];
      dInit = dInit/norm(dInit);  

      # TODO Put this in a function that returns the collision & what it collided with
      # Determiner si le rayon touche au cylindre
      #v = [4+2*cos(5*pi/6), 4+2*sin(5*pi/6), 0]/norm([4+2*cos(5*pi/6), 4+2*sin(5*pi/6), 0])
      v = [1; 1; 0.37]/norm([1; 1; 0.37]);
      f = @(params) resoudreRayonCylindre(params, constantes, poso', v);
      [x, fval, exitflag] = fsolve(f, [0,0])
      s = x(1);
      zst = poso'+v*s;  # Point de collision potentiel avec le cote du cylindre
      if (exitflag == 1 && zst(3) >= rc(3)-h/2 && zst(3) <= rc(3)+h/2)
        # Collision valide avec le rayon du cylindre
        hold on;
        plot3([poso(1);zst(1)], [poso(2);zst(2)], [poso(3);zst(3)]);
        axis square; 
        view(3);
      else
        # Verifier avec le haut et le bas du cylindre
        #s = resoudreHautBasCylindre(constantes, poso, dInit);
        s = resoudreHautBasCylindre(constantes, poso', v);
        if (s > 1000000)  # Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
          # Rejeter le rayon, ne devrait pas arriver si on choisit bien nos angles
          display("Ray discarded");
          continue;
        else
          # Collision valide avec le haut ou le bas du cylindre
          zst = poso'+v*s;  # Point de collision avec le cote du cylindre
          hold on;
          plot3([poso(1);zst(1)], [poso(2);zst(2)], [poso(3);zst(3)]);
          axis square; 
          view(3);
        endif
      endif
      
      # Si le rayon touche au cylindre
      posObservateur = poso;
      pointIntersection = zst;
      distanceParcourue = norm(pointIntersection - posObservateur);
      
      #TODO Add collision logic for top and bottom
      # Determiner la normale d'une surface tangante au cylindre au point d'intersection (i)
      centreDuCercle = [rc(1), rc(2), pointIntersection(3)];
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
        # Le rayon est rejete
        continue;
      
      # Calculer la direction refracte du rayon
      # TODO Need to give better variable names
      # TODO Check if the new direction calculation works
      angleTransmis = asin((nLiquide/nCylindre)*sin(angleIncidence));
      dApres = -i*cos(angleTransmis) + k*sin(angleTransmis);
      dApres = dApres/norm(dApres);
      
      # A l'interieur du cylindre
      for nReflectTotInterne = 1:100  # On se limite a 100 reflexions internes
        dRayonIncident = dApres;
        
        # Calculer le prochain point d'intersection
        prochainPointIntersection = [0, 0, 0];  # TODO Apply magic courbe parametrique fuckery
        # TODO Return a variable or something that says what it collided with

        # Calculer la distance parcourue
        distanceParcourue = distanceParcourue + norm(prochainPointIntersection - pointIntersection);
        pointIntersection = prochainPointIntersection;
        
        # TODO Fonction to determine which side of the object it collided with
        # Si le rayon a touche a l'objet
        #if ()
          # TODO Mettre la couleur appropriee and go to the next rayon (push in the vector of points)
          # (the distance is already accurate & dInit has the initial direction)
          # break;
        
        #TODO Add collision logic for top and bottom
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
        
        if (estTransmise(nCylindre, nLiquide, angleIncidence))
          # Rejeter le rayon
          break;
        
        # Si le rayon est reflechie dans le cylindre calculer le prochain vecteur directeur
        dApres = cos(angleIncidence)*i + sin(angleIncidence)*k;
        dApres = dApres/norm(dApres);
endfunction

function estRefl = estReflechie(nInit, nFinal, angleInit)
  estRefl = (nInit > nFinal) && (angleInit < -abs(arcsin(nFinal/nInit))) && (angleInit > abs(arcsin(nFinal/nInit)));
endfunction

function estTrans = estTransmise(nInit, nFinal, angleInit)
  estTrans = not(estReflechie(nInit, nFinal, angleInit));
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
  s = Inf;
  if (u(3)!=0)
    shaut = (rc(3)+h/2-r0(3))/u(3);
    sbas = (rc(3)-h/2-r0(3))/u(3); 
    if (shaut >= 0 && (norm((r0+shaut*u)-(rc+[0;0;h/2]))) <= R)
      % Collision valide avec le haut du cylindre
      s = min(s, shaut);
    endif
    if (sbas >= 0 && (norm((r0+sbas*u)-(rc-[0;0;h/2]))) <= R)
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
