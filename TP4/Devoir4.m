function [xi yi zi face] = Devoir4 (nout, nin, poso, name = "Graphique de la trajectoire")
  format short g
  
  constantes = defConstantes();
  
 
endfunction


function dessinerGraphique(constantes, positions, rotations, name)
  figure('name', name);
  view(2);
  grid on;
endfunction
