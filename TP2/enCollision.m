function [collision coup] = enCollision(q0, qs)
  % Determine si la balle a touche un obstacle a 1mm de precision sur x, y et z
  % Collision: Boolean qui determine si une collision a eu lieu
  % Coup : Le type de collision (0 1 2 3)

  constantes = defConstantes();
  table = constantes.table;
  filet = constantes.filet;
  balle = constantes.balle;
  
  x = qs(4); 
  y = qs(5);
  z = qs(6);  
  
  collision = false;
  coup = -1;
  
  %Cas 0 or 1: If ball touches the table on the right side, z = table.h, 0 < y < table.larg, table.long/2 < x < table.long
  if (x < table.long/2)
    cx = table.long/2;
  elseif (x > table.long)
    cx = table.long;
  else
    cx = x;
  end
  
  if (y < 0)
    cy = 0;
  elseif (y > table.larg)
    cy = table.larg;
  else
    cy = y;
  end
    
  cz = table.h;
  
  distance = pdist([x, y, z; cx, cy, cz],'euclidean');
  
  if (abs(distance - balle.r) <= constantes.epsilon(1))
    % Determine la direction ou la balle vient
    if (qs(4) - q0(4) < 0)
      coup = 1; % rate
    else
      coup = 0; % reussi
    end;
    
    collision = true;
    return;
  end;
  
  % Cas 0 or 1: If ball touches the table on the left side, z = table.h, 0 < y < table.larg, 0 < x < table.long/2
  if (x < 0)
    cx = 0;
  elseif (x > table.long/2)
    cx = table.long/2;
  else
    cx = x;
  end
  
  if (y < 0)
    cy = 0;
  elseif (y > table.larg)
    cy = table.larg;
  else
    cy = y;
  end
    
  cz = table.h;
  
  distance = pdist([x, y, z; cx, cy, cz],'euclidean');
  
  if abs(distance - balle.r) <= constantes.epsilon(1)
    
    % Determine la direction ou la balle vient a partir des x
    if (qs(4) - q0(4) < 0)
      coup = 0;
    else
      coup = 1;
    end;

    collision = true;
    return;
  end;
 
 
  % Cas 2: If ball touches filet, x = table.long/2, - filet.deborde < y < table.larg + filet.deborde , table.h < z < table.h + filet.h 

  cx = table.long/2;
  
  if (y < -filet.deborde)
    cy = -filet.deborde;
  elseif (y > table.larg + filet.deborde)
    cy = table.larg + filet.deborde;
  else
    cy = y;
  end
    
  if (z < table.h)
    cz = table.h;
  elseif (z > table.h + filet.h)
    cz = table.h + filet.h;
  else
    cz = z;
  end
  
  distance = pdist([x, y, z; cx, cy, cz],'euclidean');
  
  if abs(distance - balle.r) <= constantes.epsilon(1)
    coup = 2;
    collision = true;
    return;
  end;

  % Cas 3: If ball touches the floor, z = 0
  if abs(z - balle.r) <= constantes.epsilon(1)
    collision = true;
    coup = 3;
    return;
  end

