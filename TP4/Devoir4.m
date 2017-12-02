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
  
  # TODO Put angles into the constants file?
  # Angle Polaire (theta) : Descend de l'axe des z vers le plan xy
  # Angle Azimutal (phi) : Augmente dans le sens ccw de l'axe des x positif dans le plan xy
  # Angles en radians
  angleAzimutalInitial = atan((rc(2)+2*sin(10*pi/6))/(rc(1)+2*cos(10*pi/6)))
  angleAzimutalFinal = atan((rc(2)+2*sin(5*pi/6))/(rc(1)+2*cos(5*pi/6)))
  anglePolaireInitial = atan((sqrt(rc(1)^2+rc(2)^2)-R)/(rc(3)+h/2-poso(3)))
  if (poso(3) < (rc(3)-h/2))
    anglePolaireFinal = atan((sqrt(rc(1)^2+rc(2)^2)+R)/(rc(3)-h/2-poso(3)))
  else
    anglePolaireFinal = pi+atan((sqrt(rc(1)^2+rc(2)^2)-R)/(rc(3)-h/2-poso(3)))
  end
  
  nAnglesAzimutal = 10;  # TODO Optimize
  nAnglesPolaire = 10;
  
  for nIterAzimutal = 1:nAnglesAzimutal
    # Calculer l'angle azimutal
    angleAzimutal = angleAzimutalInitial + (2*nIterAzimutal - 1)*(angleAzimutalFinal - angleAzimutalInitial)/(2*nAnglesAzimutal);
    
    for nIterPolaire = 1:nAnglesPolaire
      # Calculer l'angle polaire pour l'iteration
      anglePolaire = anglePolaireInitial + (2*nIterPolaire - 1)*(anglePolaireFinal - anglePolaireInitial)/(2*nAnglesPolaire);
      
      # Calculer le vecteur directeur initial
      dInit = [sin(anglePolaire)*cos(angleAzimutal), sin(anglePolaire)*sin(angleAzimutal), cos(anglePolaire)];
      dInit = dInit/norm(dInit);

      # TODO Put this in a function that returns the collision & what it collided with
      # Determiner si le rayon touche au cylindre

      s = resoudreRayonCylindre(constantes, poso', dInit);
      s(s<=0) = inf; # Eliminer les valeurs inferieures a zero
      s = min(s);
      pointIntersection = poso+dInit*s;  # Point de collision potentiel avec le cote du cylindre
      intersecteAvecCoteCyl = true;
      if (size(s) == 1 && pointIntersection(3) >= rc(3)-h/2 && pointIntersection(3) <= rc(3)+h/2)
        # Collision valide avec le rayon du cylindre
        hold on;
        plot3([poso(1);pointIntersection(1)], [poso(2);pointIntersection(2)], [poso(3);pointIntersection(3)]);
        axis square; 
        view(3);
      else
        # Verifier avec le haut et le bas du cylindre
        #s = resoudreHautBasCylindre(constantes, poso, dInit);
        s = resoudreHautBasCylindre(constantes, poso', dInit);
        if (s > 1000000)  # Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
          # Rejeter le rayon, ne devrait pas arriver si on choisit bien nos angles
          display("Ray discarded");
          display(dInit);
          continue
        else
          # Collision valide avec le haut ou le bas du cylindre
          pointIntersection = poso'+dInit*s;  # Point de collision avec le cote du cylindre
          intersecteAvecCoteCyl = false;
          hold on;
          plot3([poso(1);pointIntersection(1)], [poso(2);pointIntersection(2)], [poso(3);pointIntersection(3)]);
          axis square; 
          view(3);
        endif
      endif
      
      # Si le rayon touche au cylindre
      #posObservateur = poso;
      #pointIntersection = [zst(1), zst(2), zst(3)];  # TODO Just do transpose of the vertical vector instead?
      
      # Pas necessaire, s c'est deja la distance parcourue
      #distanceParcourue = norm(pointIntersection - posObservateur);
      
      if intersecteAvecCoteCyl
        # Intersection avec le cote du cylindre
        # Determiner la normale d'une surface tangante au cylindre au point d'intersection (i)
        centreDuCercle = [rc(1), rc(2), pointIntersection(3)];
        i = (pointIntersection - centreDuCercle);
        i = i/norm(i);
      else
        # Intersection avec le haut ou le bas du cylindre
        if (pointIntersection(3) > rc(3))
          # Intersection avec le haut
          i = [0, 0, 1];  # Normale du haut du cylindre
        else
          # Intersection avec le bas
          i = [0, 0, -1];  # Normale du bas du cylindre
        endif
      endif
      
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
        continue
      endif
      
      # Calculer la direction refracte du rayon
      # TODO Need to give better variable names
      # TODO Check if the new direction calculation works
      angleTransmis = asin((nLiquide/nCylindre)*sin(angleIncidence));
      dApres = -i*cos(angleTransmis) + k*sin(angleTransmis);
      dApres = dApres/norm(dApres);
      
      distanceTotale = s;
      
      
      # A l'interieur du cylindre
      for nReflectTotInterne = 1:100 # On se limite a 100 reflexions internes
        dRayonIncident = dApres;
        
        # Calculer le prochain point d'intersection
        #prochainPointIntersection = [0, 0, 0];  # TODO Apply magic courbe parametrique fuckery
        intersecteAvecCoteCyl = true;  # TODO Change to appropriate value when add intersection logic
        # TODO Change boolean for indicating what you collided with to an integer? (enum?)
        s = resoudreRayonCylindre(constantes, pointIntersection', dRayonIncident);
        s(s<=0) = inf; # Eliminer les valeurs inferieures a zero
        s = min(s);
        prochainPointIntersection = pointIntersection + s*dRayonIncident;  # Point de collision potentiel avec le cote du cylindre
        
        
        if (size(s) == 1 && prochainPointIntersection(3) >= rc(3)-h/2 && prochainPointIntersection(3) <= rc(3)+h/2)
        # Collision valide avec le rayon du cylindre
        hold on;
        plot3([pointIntersection(1);prochainPointIntersection(1)], [pointIntersection(2);prochainPointIntersection(2)], [pointIntersection(3);prochainPointIntersection(3)]);
      else
        # Verifier avec le haut et le bas du cylindre
        #s = resoudreHautBasCylindre(constantes, poso, dInit);
        s = resoudreHautBasCylindre(constantes, pointIntersection', dRayonIncident);
        if (s > 1000000)  # Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
          # Rejeter le rayon, ne devrait pas arriver si on choisit bien nos angles
          #display("Ray discarded");
          break;
        else
          # Collision valide avec le haut ou le bas du cylindre
          prochainPointIntersection = pointIntersection + s*dRayonIncident; # Point de collision avec le cote du cylindre
          intersecteAvecCoteCyl = false;
          hold on;
          plot3([pointIntersection(1);prochainPointIntersection(1)], [pointIntersection(2);prochainPointIntersection(2)], [pointIntersection(3);prochainPointIntersection(3)]);
        endif
      endif
%        intersecteAvecCoteCyl = true;
%
        # Calculer la distance parcourue
        distanceTotale += s;
        pointIntersection = prochainPointIntersection;
        
        # TODO Fonction to determine which side of the object it collided with
        # Si le rayon a touche a l'objet
        #if ()
          # TODO Mettre la couleur appropriee and go to the next rayon (push in the vector of points)
          # (the distance is already accurate & dInit has the initial direction)
          # break;
        
        # Si le rayon touche au cylindre il faut determiner l'angle d'incidence
        if intersecteAvecCoteCyl
          # Determiner la normale d'une surface tangante au cylindre au point d'intersection (i)
          centreDuCercle = [rc(1), rc(2), prochainPointIntersection(3)];
          i = (centreDuCercle - prochainPointIntersection);
          i = i/norm(i);
        else
          # Intersection avec le haut ou le bas du cylindre
          if (prochainPointIntersection(3) > rc(3))
            # Intersection avec le haut
            i = [0, 0, -1];  # Normale du haut du cylindre, inverse puisque le rayon est a l'interieur!!
          else
            # Intersection avec le bas
            i = [0, 0, 1];  # Normale du bas du cylindre, inverse puisque le rayon est a l'interieur!!
          endif
        endif
      
        # Calculer la normale du plan d'incidence (j)
        j = cross(dRayonIncident, i);
        j = j/norm(j);
      
        # Determiner l'angle d'incidence du rayon
        k = cross(i, j);
        k = k/norm(k);
        angleIncidence = asin(dot(dRayonIncident, k));
        
        if (estTransmise(nCylindre, nLiquide, angleIncidence))
          # Rejeter le rayon
          #display("Ray discarded");
          break
        endif
        
        # Si le rayon est reflechie dans le cylindre calculer le prochain vecteur directeur
        dApres = cos(angleIncidence)*i + sin(angleIncidence)*k;
        dApres = dApres/norm(dApres);
      end
    end
  end
endfunction

function estRefl = estReflechie(nInit, nFinal, angleInit)
  estRefl = (nInit > nFinal) && (angleInit >= -abs(asin(nFinal/nInit))) && (angleInit <= abs(asin(nFinal/nInit)));
endfunction

function estTrans = estTransmise(nInit, nFinal, angleInit)
  estTrans = not(estReflechie(nInit, nFinal, angleInit));
endfunction


function s = resoudreRayonCylindre(constantes, r0, u)
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  d = [r0(1:2)-rc(1:2)];
  # Si on part de r = r0 + su, on a X = r0(1) + su(1) et Y = r0(2) + su(2)
  # Ensuite, on cherche a trouver les intersections avec (x-h)^2+(y-k)^2=R^2
  # Si on remplace dans l'equation, on a : (r0(1)+su(1)-h)^2+(r0(2)+su(2)-h)^2=R^2
  # En developpant, on a : (r0(1)^2+(su(1))^2+h^2+2r0(1)su(1)-2r0(1)h-2su(1)h) + (r0(2)^2+(su(2))^2+k^2+2r0(2)su(2)-2r0(2)k-2su(2)k) = R^2
  # On peut regrouper certains termes : s^2*(u(1)^2+u(2)^2) -> s^2(u.u) [produit scalaire]
  # Aussi : r0(1)^2 + r0(2)^2 - 2r0(1)h - 2r0(2)k + h^2 + k^2 -> (r0(1)-h)^2 + (r0(2)-k)^2 -> (d.d) ou d = r0(1:2) - rc(1:2) [qui equivaut a (r0(1)-h, r0(2)-k)]
  # Finalement : 2r0(1)su(1)-2su(1)h + 2r0(2)su(2)-2su(2)k -> 2*(r0(1)su(1)-su(1)h+r0(2)su(2)-su(2)k) ->
  # 2*([r0(1)-h, r0(2)-k].[su(1), su(2)]) -> 2*(d.u)
  # On a finalement 0 = s^2*(u.u)+2s*(d.u)+((d.d)-R^2)
  s = roots([dot(u(1:2),u(1:2)), 2*dot(d,u(1:2)), dot(d,d)-R^2]);
  
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
