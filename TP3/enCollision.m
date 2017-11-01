function estEnCollision = enCollision(posCentreAutoA, orientationXYAutoA, posCentreAutoB, orientationXYAutoB)
  constantes = defConstantes();
  
  # Determiner la position des coins de chaque auto en fonction de la position et l'orientation de l'auto  
  longueurA = constantes.autos.a.long;
  largeurA = constantes.autos.a.larg;
  coinsSansRotA = [posCentreAutoA.x-longueurA/2, posCentreAutoA.x+longueurA/2, posCentreAutoA.x+longueurA/2, posCentreAutoA.x-longueurA/2;
                   posCentreAutoA.y-largeurA/2, posCentreAutoA.y-largeurA/2, posCentreAutoA.y+largeurA/2, posCentreAutoA.y+largeurA/2];
  matriceRotA = [cos(orientationXYAutoA), -sin(orientationXYAutoA); sin(orientationXYAutoA), cos(orientationXYAutoA)];
  coinsAvecRotA = [matriceRotA*coinsSansRotA[:1], matriceRotA*coinsSansRotA[:2], matriceRotA*coinsSansRotA[:3], matriceRotA*coinsSansRotA[:4]];
    
  longueurB = constantes.autos.b.long;
  largeurB = constantes.autos.b.larg;
  coinsSansRotB = [posCentreAutoB.x-longueurB/2, posCentreAutoB.x+longueurB/2, posCentreAutoB.x+longueurB/2, posCentreAutoB.x-longueurB/2;
                   posCentreAutoB.y-largeurB/2, posCentreAutoB.y-largeurB/2, posCentreAutoB.y+largeurB/2, posCentreAutoB.y+largeurB/2];
  matriceRotB = [cos(orientationXYAutoB), -sin(orientationXYAutoB); sin(orientationXYAutoB), cos(orientationXYAutoB)];
  coinsAvecRotB = [matriceRotB*coinsSansRotB[:1], matriceRotB*coinsSansRotB[:2], matriceRotB*coinsSansRotB[:3], matriceRotB*coinsSansRotB[:4]]; 

  # 
endfunction