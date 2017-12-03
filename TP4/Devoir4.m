function [xi yi zi face] = Devoir4 (nout, nin, poso, name = "Rayons")
  format short g
  
  constantes = defConstantes();
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  h = constantes.cylindre.hauteur;
  
  figure('name', name);
  #set(gca, 'Projection', 'perspective'); 
  [cx, cy, cz] = cylinder();
  surf(2*cx+rc(1), 2*cy+rc(2), h*cz+rc(3)-h/2, 'FaceAlpha', 0)

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
  
  nAnglesAzimutal = 100;
  nAnglesPolaire = 100;
  xi = [];
  yi = [];
  zi = [];
  ci = [];
  face = [];
  
  for nIterAzimutal = 1:nAnglesAzimutal
    # Calculer l'angle azimutal
    angleAzimutal = angleAzimutalInitial + (2*nIterAzimutal - 1)*(angleAzimutalFinal - angleAzimutalInitial)/(2*nAnglesAzimutal);
    
    for nIterPolaire = 1:nAnglesPolaire
      # Calculer l'angle polaire pour l'iteration
      anglePolaire = anglePolaireInitial + (2*nIterPolaire - 1)*(anglePolaireFinal - anglePolaireInitial)/(2*nAnglesPolaire);
      
      # Calculer le vecteur directeur initial
      dInit = [sin(anglePolaire)*cos(angleAzimutal), sin(anglePolaire)*sin(angleAzimutal), cos(anglePolaire)];
      dInit = dInit/norm(dInit);
      #prisme = constantes.prisme;
      #dInit = prisme.centre' - poso;
      #dInit = dInit/norm(dInit);
      
      # Determiner si le rayon touche au cylindre
      s = resoudreRayonCylindre(constantes, poso', dInit);
      s(s<=0.01) = inf; # Eliminer les valeurs inferieures a zero, plus une erreur d'incertitude
      s = min(s);
      pointIntersection = poso+dInit*s;  # Point de collision potentiel avec le cote du cylindre
      intersecteAvecCoteCyl = true;
      if (size(s) == 1 && pointIntersection(3) >= rc(3)-h/2 && pointIntersection(3) <= rc(3)+h/2)
        # Collision valide avec le rayon du cylindre        
      else
        # Verifier avec le haut et le bas du cylindre
        s = resoudreHautBasCylindre(constantes, poso', dInit);
        if (s > 1000000)  # Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
          # Rejeter le rayon, ne devrait pas arriver si on choisit bien nos angles
          continue
        else
          # Collision valide avec le haut ou le bas du cylindre
          pointIntersection = poso+dInit*s;  # Point de collision avec le cote du cylindre
          intersecteAvecCoteCyl = false;
        endif
      endif
      
      if intersecteAvecCoteCyl
        # Intersection avec le cote du cylindre
        # Determiner la normale d'une surface tangente au cylindre au point d'intersection (i)
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
      angleTransmis = asin((nLiquide/nCylindre)*sin(angleIncidence));
      dApres = -i*cos(angleTransmis) + k*sin(angleTransmis);
      dApres = dApres/norm(dApres);
      #hold on;
      #plot3([poso(1);pointIntersection(1)],
          #  [poso(2);pointIntersection(2)],
           # [poso(3);pointIntersection(3)]);
     # hold on;
       # plot3([pointIntersection(1);pointIntersection(1)+i(1)],
        #    [pointIntersection(2);pointIntersection(2)+i(2)],
         #   [pointIntersection(3);pointIntersection(3)+i(3)]);
      #hold on;
      #  plot3([pointIntersection(1);pointIntersection(1)+j(1)],
        #    [pointIntersection(2);pointIntersection(2)+j(2)],
          #  [pointIntersection(3);pointIntersection(3)+j(3)]);
      #hold on;
       # plot3([pointIntersection(1);pointIntersection(1)+k(1)],
        #    [pointIntersection(2);pointIntersection(2)+k(2)],
        #    [pointIntersection(3);pointIntersection(3)+k(3)]);
      #hold on;
     # plot3([pointIntersection(1);pointIntersection(1)+dApres(1)],
          #  [pointIntersection(2);pointIntersection(2)+dApres(2)],
            #[pointIntersection(3);pointIntersection(3)+dApres(3)]);
      
      distanceTotale = s;
      
      
      # A l'interieur du cylindre
      for nReflectTotInterne = 1:100 # On se limite a 100 reflexions internes (ne pas rouler ca avec les lignes de debug!!)
        dRayonIncident = dApres;
        
        [s, couleur, numface] = resoudrePrisme(constantes, pointIntersection', dRayonIncident);
        if (s < 1000000)
          distanceTotale += s;
          pointDessin = poso + distanceTotale*dInit;
          xi = [xi; pointDessin(1)];
          yi = [yi; pointDessin(2)];
          zi = [zi; pointDessin(3)];
          ci = [ci; couleur];
          face = [face; numface];
          break;
        endif
        
        # Calculer le prochain point d'intersection
        intersecteAvecCoteCyl = true;
        s = resoudreRayonCylindre(constantes, pointIntersection', dRayonIncident);
        s(s<=0.01) = inf; # Eliminer les valeurs inferieures a zero, plus une erreur d'incertitude
        s = min(s);
        prochainPointIntersection = pointIntersection + s*dRayonIncident;  # Point de collision potentiel avec le cote du cylindre
        
        
        if (size(s) == 1 && prochainPointIntersection(3) >= rc(3)-h/2 && prochainPointIntersection(3) <= rc(3)+h/2)
        # Collision valide avec le rayon du cylindre
        else
          # Verifier avec le haut et le bas du cylindre
          s = resoudreHautBasCylindre(constantes, pointIntersection, dRayonIncident);
          if (s > 1000000)  # Valeur arbitraire pour dire que le rayon n'a pas frappe le cylindre
            # Rejeter le rayon, ne devrait pas arriver si on choisit bien nos angles
            break;
          else
            # Collision valide avec le haut ou le bas du cylindre
            prochainPointIntersection = pointIntersection + s*dRayonIncident; # Point de collision avec le cote du cylindre
            intersecteAvecCoteCyl = false;
          endif
        endif
        
        
        # Si le rayon touche au cylindre il faut determiner l'angle d'incidence
        if intersecteAvecCoteCyl
          # Determiner la normale d'une surface tangente au cylindre au point d'intersection (i)
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
          break;
        endif
        
        # Si le rayon est reflechie dans le cylindre calculer le prochain vecteur directeur
        dApres = cos(angleIncidence)*i + sin(angleIncidence)*k;
        dApres = dApres/norm(dApres);
        
        # Calculer la distance parcourue
        distanceTotale += s;
        pointIntersection = prochainPointIntersection;
        
      end
    end
  end
  
  hold on;
  scatter3(xi, yi, zi, 200, ci, '.');
  plot3(poso(1),poso(2),poso(3), 'o', 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 20);
  
  #set(gca, 'CameraViewAngle', 30);
  #set(gca, 'CameraPosition', poso);
  #set(gca, 'CameraTarget', [constantes.cylindre.centre(1:2)' poso(3)]);
  axis equal;
  axis([0 6 0 6 0 20]);
  set(gca,'color','none');
  view(3);
  grid on;
  
  
  
endfunction

function estRefl = estReflechie(nInit, nFinal, angleInit)
  angleCritique = abs(asin(nFinal/nInit));
  estRefl = (nInit > nFinal) && ((angleInit < -angleCritique) || (angleInit > angleCritique));
endfunction

function estTrans = estTransmise(nInit, nFinal, angleInit)
  estTrans = not(estReflechie(nInit, nFinal, angleInit));
endfunction


function s = resoudreRayonCylindre(constantes, r0, u)
  R = constantes.cylindre.rayon;
  rc = constantes.cylindre.centre;
  d = [r0(1:2)-rc(1:2)];
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
    dist = norm((r0+shaut*u)-(rc+[0;0;h/2])');
    if (shaut >= 0 && dist <= R)
      % Collision valide avec le haut du cylindre
      s = min(s, shaut);
    endif
    dist = norm((r0+sbas*u)-(rc-[0;0;h/2])');
    if (sbas >= 0 && dist <= R)
      % Collision valide avec le bas du cylindre
      s = min(s, sbas);
    endif
  endif
  
endfunction

function [sm, color, numface] = resoudrePrisme(constantes, r0, u)
  prisme = constantes.prisme;
  faces = fieldnames(constantes.faces);
  color = [0 0 0];
  sm = inf;
  numface = 0;
  for i = 1:numel(faces)
    face = constantes.faces.(faces{i});
    rc = face.centre;
    n = face.normale;
    r = rc - r0;
    s = dot(n,r)/dot(n,u);
    pointIntersection = r0' + s*u;
    if ((s > 0) && (s < sm) &&
        (pointIntersection(1) >= prisme.centre(1)-prisme.dimensions(1)/2) &&
        (pointIntersection(1) <= prisme.centre(1)+prisme.dimensions(1)/2) &&
        (pointIntersection(2) >= prisme.centre(2)-prisme.dimensions(2)/2) &&
        (pointIntersection(2) <= prisme.centre(2)+prisme.dimensions(2)/2) &&
        (pointIntersection(3) >= prisme.centre(3)-prisme.dimensions(3)/2) &&
        (pointIntersection(3) <= prisme.centre(3)+prisme.dimensions(3)/2))
        color = face.couleur;
        sm = s;
        numface = i;
     endif
  end
endfunction
