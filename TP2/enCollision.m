function [collision coup posCollision] = enCollision(q0, qs)
  % Collision: Boolean qui determine si une collision a eu lieu
  % Coup : Le type de collision (1 2 3 4)
  % posCollision : Point de l'objet (table/filet/sol) ou a eu lieu la collision

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
  
  if (distance <= balle.r)
    % Determine la direction ou la balle vient
    if (qs(4) - q0(4) < 0)
      coup = 1; % rate
    else
      coup = 0; % reussi
    end;
    
    collision = true;
    posCollision = [cx cy cz];
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
  
  if (distance <= balle.r)
    
    % Determine la direction ou la balle vient a partir des x
    if (qs(4) - q0(4) < 0)
      coup = 0;
    else
      coup = 1;
    end;

    collision = true;
    posCollision = [cx cy cz];
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
  
  if (distance <= balle.r)
    coup = 2;
    collision = true;
    posCollision = [cx cy cz];
    return;
  end;

  % Cas 3: If ball touches the floor, z = 0
  if z <= 0
    collision = true;
    coup = 3;
    posCollision = [cx cy 0];
    return;
  end

