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
  
  pente = [xf yf zf] - [xi yi zi]
  
  % Table 
  % V�rifie que la balle passe par l'hauteur de la table
  if ((zi >= table.h - (epsilon(3) + balle.r)) && (zf <= table.h + epsilon + balle.r))
    % Trouver l'�quation param�trique de la ligne pour trouver le point o� la balle passe � la hauteur de la table 
    % [x y z] = [xi yi zi] + t*[pente_x pente_y pente_z]
    t = (table.h - zi)/pente(3);
    [x_table y_table z_table] = [xi yi zi] + t * pente;
    % V�rifie si ce point fait partie de la table
    if ((x_table > -(epsilon(1) + balle.r)) && (x_table < table.long + epsilon(1) + balle.r) 
      && (y_table > -(epsilon(2) + balle.r)) && (y_table < table.larg + epsilon(2) + balle.r))
      aTraverse = true;
      return;
    end
  end
  
  
  % Filet 
  % V�rifie si la balle a passe par le x du filet 
  % Balle dans la direction de x0 � x+
  if ((xf - xi) > 0 && (xi <= table.larg/2 + epsilon(1) + balle.r) && (xf >= table.larg/2 - (epsilon(1) + balle.r)))
    xpasse = true;
  % Balle dans la direction de x+ � x0  
  elseif ((xf - xi) < 0 && (xf <= table.larg/2 + epsilon(1) + balle.r) && (xi >= table.larg/2 - (epsilon(1) + balle.r)))
    xpasse = true;
  else
    xpasse = false;
  end
    
  if (xpasse)  
    % Trouver l'�quation param�trique de la ligne pour trouver le point o� la balle passe � x = position du filet 
    % [x y z] = [xi yi zi] + t*[pente_x pente_y pente_z]
    t = (filet.x - xi)/pente(1);
    [x_filet y_filet z_filet] = [xi yi zi] + t * pente;
    
    if ((z_filet > table.h - (epsilon(3) + balle.r)) && (z_filet < filet.h + table.h + epsilon(3) + balle.r) 
      && (y_table > -(filet.deborde + epsilon(2) + balle.r) && (y_table < filet.deborde + table.larg + epsilon(2) + balle.r))
      aTraverse = true;
      return;
    end
  end 
   
  
  % Sol 
  if (zi >= 0 && zf <= 0)
    aTraverse = true;
    return;
  end