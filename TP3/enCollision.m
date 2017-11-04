function estEnCollision = enCollision(posCentreAutoA, orientationXYAutoA, posCentreAutoB, orientationXYAutoB)
  constantes = defConstantes();
    
  #     4____(3)__3
  #     |         | 
  # (4) |         | (2)
  #     |         |
  #     -----------
  #     1    (1)   2
  # Determiner la position des coins de chaque auto en fonction de la position et l'orientation de l'auto  
  longueurA = constantes.autos.a.long;
  largeurA = constantes.autos.a.larg;
  
  coinsSansRotA = [posCentreAutoA(1)-longueurA/2, posCentreAutoA(1)+longueurA/2, posCentreAutoA(1)+longueurA/2, posCentreAutoA(1)-longueurA/2;
                   posCentreAutoA(2)-largeurA/2, posCentreAutoA(2)-largeurA/2, posCentreAutoA(2)+largeurA/2, posCentreAutoA(2)+largeurA/2];
  matriceRotA = [cos(orientationXYAutoA), -sin(orientationXYAutoA); sin(orientationXYAutoA), cos(orientationXYAutoA)];
  coinsAvecRotA = [matriceRotA*coinsSansRotA(:,1), matriceRotA*coinsSansRotA(:,2), matriceRotA*coinsSansRotA(:,3), matriceRotA*coinsSansRotA(:,4)];
 
  display(coinsAvecRotA);  
    
  longueurB = constantes.autos.b.long;
  largeurB = constantes.autos.b.larg;
  coinsSansRotB = [posCentreAutoB(1)-longueurB/2, posCentreAutoB(1)+longueurB/2, posCentreAutoB(1)+longueurB/2, posCentreAutoB(1)-longueurB/2;
                   posCentreAutoB(2)-largeurB/2, posCentreAutoB(2)-largeurB/2, posCentreAutoB(2)+largeurB/2, posCentreAutoB(2)+largeurB/2];
  matriceRotB = [cos(orientationXYAutoB), -sin(orientationXYAutoB); sin(orientationXYAutoB), cos(orientationXYAutoB)];
  coinsAvecRotB = [matriceRotB*coinsSansRotB(:,1), matriceRotB*coinsSansRotB(:,2), matriceRotB*coinsSansRotB(:,3), matriceRotB*coinsSansRotB(:,4)]; 
  
  display(coinsAvecRotB);
  
  # Déterminer les normales des 4 surfaces
  normalesA = [normale(coinsAvecRotA(:,1), coinsAvecRotA(:,2)), normale(coinsAvecRotA(:,2), coinsAvecRotA(:,3)), normale(coinsAvecRotA(:,3), coinsAvecRotA(:,4)), normale(coinsAvecRotA(:,4), coinsAvecRotA(:,1))];
               
  normalesB = [normale(coinsAvecRotB(:,1), coinsAvecRotB(:,2)), normale(coinsAvecRotB(:,2), coinsAvecRotB(:,3)), normale(coinsAvecRotB(:,3), coinsAvecRotB(:,4)), normale(coinsAvecRotB(:,4), coinsAvecRotB(:,1))];
               
  display(normalesA);
  display(normalesB);
  
  
endfunction

# sens antihoraire
function n = normale(coin1, coin2)
  z = -1;
  p = coin1 - coin2;
  n = transpose(z * [p(2), -p(1)] / norm(z*[p(2), -p(1)]));
endfunction  