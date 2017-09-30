function [coup tf rbf vbf] = Devoir2(option, rbi, vbi, wbi)
  format short g
  % Load les valeurs
  constantes = defConstantes();
  force_g = forceGravitationnelle(constantes);  
  
endfunction

function [force_g] = forceGravitationnelle(constantes)
  force_g = [0; 0; constantes.balle.g * -9.81] 
endfunction