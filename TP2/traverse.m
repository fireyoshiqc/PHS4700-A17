function aTraverse = traverse(q0, qs)
  % Determine si la balle a traverse le filet, la table, ou le sol
  aTraverse = false;
  
  constantes = defConstantes();
  xi = q0(4);
  yi = q0(5);
  zi = q0(6);
  
  xf = qs(4);
  yf = qs(5);
  zf = qs(6);
  
  table = constantes.table;
  filet = constantes.filet;
  balle = constantes.balle;
  epsilon = constantes.epsilon;
  
  pente = [xf yf zf] - [xi yi zi]; 
  
  % Table 
  % Vérifie que la balle passe par l'hauteur de la table
  if ((zi >= table.h - (epsilon(3) + balle.r)) && (zf <= table.h + epsilon + balle.r))
    % Trouver l'équation paramétrique de la ligne pour trouver le point où la balle passe à la hauteur de la table 
    % [x y z] = [xi yi zi] + t*[pente_x pente_y pente_z]
    t = (table.h - zi)/pente(3);
    pos_table = [xi yi zi] + t * pente;
    x_table = pos_table(1);
    y_table = pos_table(2);
    % Vérifie si ce point fait partie de la table
    if ((x_table > -(epsilon(1) + balle.r)) && (x_table < table.long + epsilon(1) + balle.r) 
      && (y_table > -(epsilon(2) + balle.r)) && (y_table < table.larg + epsilon(2) + balle.r))
      aTraverse = true;
      return;
    end
  end
  
  
  % Filet 
  % Vérifie si la balle a passe par le x du filet 
  % Balle dans la direction de x0 à x+ et au dessus de la table
  if ((zi >= table.h - epsilon(3) - balle.r) && (zf >= table.h - epsilon(3) - balle.r) && (xf - xi) > 0 && (xi <= table.long/2 + epsilon(1) + balle.r) && (xf >= table.long/2 - (epsilon(1) + balle.r)))
    xpasse = true;
  % Balle dans la direction de x+ à x0  
  elseif ((zi >= table.h - epsilon(3) - balle.r) && (zf >= table.h - epsilon(3) - balle.r) && (xf - xi) < 0 && (xf <= table.long/2 + epsilon(1) + balle.r) && (xi >= table.long/2 - (epsilon(1) + balle.r)))
    xpasse = true;
  else
    xpasse = false;
  end
    
  if (xpasse)  
    % Trouver l'équation paramétrique de la ligne pour trouver le point où la balle passe à x = position du filet 
    % [x y z] = [xi yi zi] + t*[pente_x pente_y pente_z]
    t = (table.long/2 - xi)/pente(1);

    pos_filet = [xi yi zi] + t * pente;
    y_filet = pos_filet(2);
    z_filet = pos_filet(3);
    
    if ((z_filet > table.h - (epsilon(3) + balle.r)) && (z_filet < filet.h + table.h + epsilon(3) + balle.r) 
      && (y_filet > -(filet.deborde + epsilon(2) + balle.r) && (y_filet < filet.deborde + table.larg + epsilon(2) + balle.r)))
      aTraverse = true;
      return;
    end
  end 
   
  
  % Sol 
  if (zi >= 0 && zf <= 0)
    aTraverse = true;
    return;
  end