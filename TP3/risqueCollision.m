function estEnCollision = risqueCollision(posCentreA, posCentreB)
  constantes = defConstantes();
  A = constantes.autos.a;
  B = constantes.autos.b;
  # |r1 - r2|
  dist = norm(posCentreA - posCentreB);
  
  # R min,1 + R min,2
  Ra = sqrt((A.long/2)^2 + (A.larg/2)^2);
  Rb = sqrt((B.long/2)^2 + (B.larg/2)^2);
  
  estEnCollision =  (dist <= Ra + Rb);  
endfunction