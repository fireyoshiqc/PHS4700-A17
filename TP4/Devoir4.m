function [xi yi zi face] = Devoir4 (nout, nin, poso, name = "Graphique de la trajectoire")
  format short g
  
  constantes = defConstantes();
  
  # Angles en radians (put into the constants file)
  anglePolaireInitial = 0
  anglePolaireFinal = pi/2
  angleAzimutalInitial = 
  angleAzimutalFinal = 
  
  nAnglesPolaire = 
  nAnglesAzimutal = 
  
  for nIterPolaire = 1:nAnglesPolaire
    # Calculer l'angle polaire
    anglePolaire = anglePolaireInitial + (2*nIterPolaire - 1)(anglePolaireFinal - anglePolaireInitial)/2*nIterPolaire
    
    for nIterAzimutal = 1:nAnglesAzimutal
      # Calculer l'angle azimutal pour l'iteration
      angleAzimutal = angleAzimutalInitial + (2*nIterAzimutal - 1)(angleAzimutalFinal - angleAzimutalInitial)/2*nIterAzimutal
      
      # Calculer le vecteur directeur initial
      dInit = [sin(anglePolaire)*cos(angleAzimutal), sin(anglePolaire)cos(angleAzimutal), cos(anglePolaire)]
      
      # Determiner si le rayon entre dans le cylindre
      (x - constantes.cylindre.centre(1))^2 + (y - constantes.cylindre.centre(2))^2 - (constantes.cylindre.rayon)^2 = 0
      
      
      for ()
      
      
endfunction


function dessinerGraphique(constantes, positions, rotations, name)
  figure('name', name);
  view(2);
  grid on;
endfunction
