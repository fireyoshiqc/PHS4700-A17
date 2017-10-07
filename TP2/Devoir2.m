function [coup tf rbf vbf] = Devoir2(option, rbi, vbi, wbi, name)
  format short g
  
  % Load les valeurs
  constantes = defConstantes();
  
  q0 = [vbi(1) vbi(2) vbi(3) rbi(1) rbi(2) rbi(3)];
  
  % Option
  if (option == 1)
    g = @g1;
  elseif (option == 2)
    g = @g2;
  elseif (option == 3)
    g = @g3;
  end
  
  % Resolution
  DeltaT = 0.1;
  t0 = 0;
  tf = t0 + DeltaT; 
  [DeltaT qs] = SEDRK4t0E(q0, t0, tf, wbi, constantes.epsilon, g);
  %display(qs); 
  aTraverse = traverse(q0, qs);
  
  % Determiner l'intervalle de temps où la balle a traverse le filet ou la table
  while not(aTraverse) 
    q0 = qs;
    t0 = tf;
    tf = t0 + DeltaT;
    [DeltaT qs] = SEDRK4t0E(q0, t0, tf, wbi, constantes.epsilon, g);
    aTraverse = traverse(q0, qs);
  end
  
  % Determiner le temps de la collision exact
  m = 1;
  q_avantcollision = q0;
  t_avantcollision = t0;
  
  % Verifier si la collision a lieu à t(i-1)  
  [collision coup] = enCollision(q0, qs);
  % Sinon, Vérifier si la collision a lieu à t(i)
  if not(collision)
    [collision coup] = enCollision([rbi(1) rbi(2) rbi(3)], q0);
  end
  
  % Sinon, subdiviser en sous-intervalles et fait la même vérification à chaque sous-intervalle    
  while not(collision)
    m = 10 * m;
    q0 = q_avantcollision;
    t0 = t_avantcollision;
    DeltaT = DeltaT/m;
    for i=1:m 
      qs = SEDRK4t0(q0, t0, wbi, DeltaT, g);
      [collision coup] = enCollision(q0, qs);
      if (collision)
        break;
      else
        tf = t0 + DeltaT;
        q0 = qs;
      endif
    end
  end 
  
  display("Collision detecte a: ");
  display(tf);
  display(" position: ");
  display(qs(4:6));
  display("vitesse: ");
  display(qs(1:3));
  
  % Faire le graphe
  nbi = floor(tf/DeltaT);
  qsol = zeros(nbi+2, 6);
  qsol(1, :) = [vbi(1) vbi(2) vbi(3) rbi(1) rbi(2) rbi(3)];
  qsol(nbi+2, :) =[qs];
  positions = [rbi(1) rbi(2) rbi(3)];
  t0 = 0;
  for i = 1:nbi
    qsol(i+1, :) = SEDRK4t0(qsol(i, :), t0, wbi, DeltaT, g);
    t0 = t0 + DeltaT;
  end 
  
  rbf = qsol(nbi+1, 4:6);
  vbf = qsol(nbi+1, 1:3);
  
  display("Devoir2 ");
  display(qsol(:, 4:6));
  
  dessinerTable(constantes, qsol(:, 4:6), name);
  
endfunction



function dessinerTable(constantes, positions, name)
  table = constantes.table;
  filet = constantes.filet;
  x = [0 table.long/2; table.long table.long/2;  table.long table.long/2; 0 table.long/2];
  y = [0 -filet.h; 0 (filet.larg-filet.h); table.larg (filet.larg-filet.h); table.larg -filet.h];
  z = [table.h table.h; table.h table.h; table.h (table.h+filet.h); table.h (table.h+filet.h)];
  c = [[0.5 0.8 1]];
  figure('name', name);
  line = plot3(positions(:,1), positions(:,2), positions(:,3), 'Color', [1 0.6 0]);
  set (line(1), "linewidth", 2); 
  patch(x, y, z, c);
  axis([-1 table.long+1 -1 table.larg+1 0 table.h+1]);
  view(3)
  grid on
endfunction
