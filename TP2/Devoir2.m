function [coup tf rbf vbf] = Devoir2(option, rbi, vbi, wbi)
  format short g
  % Load les valeurs
  constantes = defConstantes();
  
  q0 = [vbi(1) vbi(2) vbi(3) rbi(1) rbi(2) rbi(3)];
  
  % Resolution
  positions = [0 0 0];
  DeltaT = 0.1;
  t0 = 0;
  tf = t0 + DeltaT; 
  qs = SEDRK4t0ER(q0, t0, tf, constantes.epsilon, 'g2');
  display(qs); 
  [collision coup] = enCollision(qs);
  
  while not(collision) 
    % Add the position to the table for plotting
    positions = [positions; qs];
    q0 = qs;
    t0 = tf;
    tf = t0 + DeltaT;
    qs = SEDRK4t0ER(q0, t0, tf, constantes.epsilon, 'g2');
    display(qs);
    [collision coup] = enCollision(qs);
  end
  
  % Find out the exact tf where the collision happens
  % code here !!!!!! 
  
  % Just for testing ----
  %qs = q0 + feval(['g', num2str(option)], constantes, q0, wbi)*1;
  
  
  %rbf = qs(4:6);
  %vbf = qs(1:3);
  %tf = 1;
  %coup = 0;
  % ---
  
  %dessinerTable(constantes);
  
endfunction



function dessinerTable(constantes)
  table = constantes.table;
  filet = constantes.filet;
  x = [0 table.long/2; table.long table.long/2;  table.long table.long/2; 0 table.long/2];
  y = [0 -filet.h; 0 (filet.larg-filet.h); table.larg (filet.larg-filet.h); table.larg -filet.h];
  z = [table.h table.h; table.h table.h; table.h (table.h+filet.h); table.h (table.h+filet.h)];
  c = [[0.5 0.8 1]];
  figure
  patch(x, y, z, c);
  axis([-1 table.long+1 -1 table.larg+1 0 table.h+1]);
  view(3)
  grid on
endfunction
