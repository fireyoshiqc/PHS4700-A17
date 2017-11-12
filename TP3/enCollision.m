function [estEnCollision coinEnCollision surfaceEnCollision aRecalculer] = enCollision(posCentreAutoA, orientationXYAutoA, posCentreAutoB, orientationXYAutoB)
  constantes = defConstantes();
  coinEnCollision = -1;
  surfaceEnCollision = -1;
  aRecalculer = true;
    
  #     4____(3)__3
  #     |         | 
  # (4) |         | (2)
  #     |         |
  #     -----------
  #     1    (1)   2
  # Determiner la position des coins de chaque auto en fonction de la position et l'orientation de l'auto  
  longueurA = constantes.autos.a.long;
  largeurA = constantes.autos.a.larg;
  
  coinsSansRotA = [-longueurA/2, longueurA/2, longueurA/2, -longueurA/2;
                   -largeurA/2, -largeurA/2,  largeurA/2,   largeurA/2];
                   
  
  coinsAvecRotA = R(coinsSansRotA, orientationXYAutoA);
  coinsTransA = [coinsAvecRotA(:,1) + posCentreAutoA(1:2), coinsAvecRotA(:,2) + posCentreAutoA(1:2), coinsAvecRotA(:,3) + posCentreAutoA(1:2), coinsAvecRotA(:,4) + posCentreAutoA(1:2) ];
  
  longueurB = constantes.autos.b.long;
  largeurB = constantes.autos.b.larg;
  coinsSansRotB = [-longueurB/2, longueurB/2, longueurB/2, -longueurB/2;
                   -largeurB/2, -largeurB/2,  largeurB/2,   largeurB/2];
  coinsAvecRotB = R(coinsSansRotB, orientationXYAutoB);
  coinsTransB = [coinsAvecRotB(:,1) + posCentreAutoB(1:2), coinsAvecRotB(:,2) + posCentreAutoB(1:2), coinsAvecRotB(:,3) + posCentreAutoB(1:2), coinsAvecRotB(:,4) + posCentreAutoB(1:2) ];
  
  # Déterminer les normales des 4 surfaces
  normalesA = [normale(coinsTransA(:,1), coinsTransA(:,2)), normale(coinsTransA(:,2), coinsTransA(:,3)), normale(coinsTransA(:,3), coinsTransA(:,4)), normale(coinsAvecRotA(:,4), coinsAvecRotA(:,1))];
  normalesB = [normale(coinsTransB(:,1), coinsTransB(:,2)), normale(coinsTransB(:,2), coinsTransB(:,3)), normale(coinsTransB(:,3), coinsTransB(:,4)), normale(coinsAvecRotB(:,4), coinsAvecRotB(:,1))];
  
  # Evaluer d = n * (r - q) pour tous les coins r de autoA sur les coins q de autoB avec les normales de autoB
  coinsASurfaceB = SurfaceCoins(coinsTransA, coinsTransB, normalesB);
  
  # S'il y a une surface de B dont tous les coins de A sont au dessus (d > 0), il y a un plan de division, donc pas de collision
  # i.e un col dont tous les d(i,j,k) > 0
  if any(all(coinsASurfaceB > 0, 1) > 0)
    estEnCollision = false;
    return;
  endif
  
  # Verifier s'il y a un coin de A en dessous de tous les plans de B (d <0)
  for row=1:size(coinsASurfaceB, 1)
    if all(coinsASurfaceB(row,:) < 0)
      estEnCollision = true;
      autoEnCollision = 1; # 1 pour A
      coinEnCollision = coinsTransA(:,row); # le numéro du coin de auto A
      # Determiner la surface de collision
      for col = 1:size(coinsASurfaceB, 2)
        if nnz(coinsASurfaceB(:, col) > 0) == 3 # les 3 autres coins de A sont au-dessus de surface col de B
          surfaceEnCollision = -normalesB(:,col);
          aRecalculer = abs(coinsASurfaceB(row, col)) > 0.01;
          return;
        endif      
      endfor 
    endif
  endfor
  
  coinsBSurfaceA = SurfaceCoins(coinsTransB, coinsTransA, normalesA);
  
  # S'il y a une surface de A dont tous les coins de B sont au dessus (d > 0), il y a un plan de division, donc pas de collision
  # i.e un col dont tous les d(i,j,k) > 0
  if any(all(coinsBSurfaceA > 0, 1) > 0)
    estEnCollision = false;
    return;
  endif
  
  # Verifier s'il y a un coin de B en dessous de tous les plans de A (d < 0)
  for row=1:size(coinsBSurfaceA, 1)
    if all(coinsBSurfaceA(row,:) < 0)
      estEnCollision = true;
      autoEnCollision = 2; # 1 pour A
      coinEnCollision = coinsTransB(:,row); # le numéro du coin de auto B
      # Determiner la surface de collision
      for col = 1:size(coinsBSurfaceA, 2)
        if nnz(coinsBSurfaceA(:, col) > 0) == 3 # les 3 autres coins de B sont au-dessus de surface col de A
          surfaceEnCollision = -normalesA(:,col);
          aRecalculer = abs(coinsBSurfaceA(row, col)) > 0.01;
          return;
        endif      
      endfor 
    endif
  endfor
  
  
   
endfunction

# sens antihoraire
function n = normale(coin1, coin2)
  z = -1;
  p = coin1 - coin2;
  n = transpose(z * [p(2), -p(1)] / norm(z*[p(2), -p(1)]));
endfunction 

# rotation
function R = R(points, angle, position)
  rot = [cos(angle), -sin(angle); sin(angle), cos(angle)];
  R = [rot*points(:,1), rot*points(:,2), rot*points(:,3), rot*points(:,4)]; 
endfunction 

# coins1surface2
function surfaceCoins = SurfaceCoins(coinsTrans1, coinsTrans2, normales2)
  surfaceCoins = magic(4);
  
  for row=1:size(surfaceCoins,1)
    for col=1:size(surfaceCoins,2)
          diff = coinsTrans1(:,row) - coinsTrans2(:,col);
          prod = dot(normales2(:,col), diff);      
          surfaceCoins(row, col) = prod;
      endfor
  endfor
endfunction