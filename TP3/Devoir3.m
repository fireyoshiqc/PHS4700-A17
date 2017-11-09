function [Coll tf raf vaf rbf vbf] = Devoir3(rai, vai, rbi, vbi, tb, name = "Graphique de la trajectoire")
  format short g
  
  constantes = defConstantes();
  
  epsilon = 0.01; # 1 cm
  a = constantes.autos.a;
  b = constantes.autos.b;
  
  t0 = 0.0;
  qa0 = [vai(1:2) rai];
  qb0 = [vbi(1:2) rbi];
  qas = qa0;
  qbs = qb0;
  wa0 = vai(3);
  wb0 = vbi(3);
  rota0 = atan2(vai(2), vai(1));
  rotb0 = atan2(vbi(2), vbi(1));
  rota = rota0;
  rotb = rotb0;
  
  
  collision = false;
  
  deltaT = 0.1;
  curT = 0.0;
  
  while ((norm(qas(1:2)) >= 0.01 || norm(qbs(1:2)) >= 0.01) && not(collision))
  #while ((curT < tb) && not(collision))
    # Pas de collision déterminée expérimentalement dans cette section
    if tb > 0.0 && curT < tb
      [deltaT qas] = SEDRK4t0E(qas, curT, curT + deltaT, wa0, epsilon, @gfrt, a.masse);
      rota = rota + wa0*tb;
      qbs = qbs+gcst(qbs)*tb;
      # L'auto b ne tourne pas encore sur elle-même.
      curT = tb;      
    else
      [dta qas] = SEDRK4t0E(qas, curT, curT + deltaT, wa0, epsilon, @gfrt, a.masse);
      [dtb qbs] = SEDRK4t0E(qbs, curT, curT + deltaT, wb0, epsilon, @gfrt, b.masse);
      curT = curT + deltaT;
      deltaT = min(dta, dtb);
      rota = rota + wa0*deltaT;
      rotb = rotb + wb0*deltaT;
      # Vérifier s'il y a eu potentielle collision, sinon la boucle va continuer normalement.
      if risqueCollision(qas(3:4), qbs(3:4))
        [collision pointCollision normale] = enCollision(qas(3:4)', rota, qbs(3:4)', rotb);
      endif
    endif
    
    if norm(qas(1:2)) < 0.01
      qas(1) = 0;
      qas(2) = 0;
    endif
    
    if norm(qbs(1:2)) < 0.01
      qbs(1) = 0;
      qbs(2) = 0;
    endif
  endwhile
  
  if collision
    [vaf vbf waf wbf] = resCollision(qas, qbs, wa0, wb0, normale, pointCollision);
  else
    vaf = [qas(1:2) wa0];
    vbf = [qbs(1:2) wb0];
  endif 
  
  raf = [qas(3:4) rota];
  rbf = [qbs(3:4) rotb];
  Coll = not(collision);
  tf = curT;
  dessinerGraphique(constantes, [rai; raf(1:2); rbi; rbf(1:2)], [rota0 rota rotb0 rotb], 'MASTRING');
  
endfunction

function dessinerGraphique(constantes, positions, rotations, name)
  a = constantes.autos.a;
  b = constantes.autos.b;
  
  figure('name', name);
  line = plot(positions(1:2,1), positions(1:2,2),"-b",positions(3:4,1), positions(3:4,2),"-r");
  set (line(1:2), "linewidth", 3);
  recA = [-a.long/2 -a.larg/2; a.long/2 -a.larg/2; a.long/2 a.larg/2; -a.long/2 a.larg/2];
  recB = [-b.long/2 -b.larg/2; b.long/2 -b.larg/2; b.long/2 b.larg/2; -b.long/2 b.larg/2];
  pointsA0 = R(recA, rotations(1)) + positions(1,:);
  pointsAF = R(recA, rotations(2)) + positions(2,:);
  pointsB0 = R(recB, rotations(3)) + positions(3,:);
  pointsBF = R(recB, rotations(4)) + positions(4,:);

  faceA = [1 2 3 4];
  patch('Faces',faceA,'Vertices',pointsA0,'EdgeColor',"blue",'FaceColor',"none",'LineWidth',2);
  patch('Faces',faceA,'Vertices',pointsAF,'EdgeColor',"blue",'FaceColor',"none",'LineWidth',2);

  faceB = [1 2 3 4];
  patch('Faces',faceB,'Vertices',pointsB0,'EdgeColor',"red",'FaceColor',"none",'LineWidth',2);
  patch('Faces',faceB,'Vertices',pointsBF,'EdgeColor',"red",'FaceColor',"none",'LineWidth',2);
  axis([0,100,0,100]);
  view(2);
  grid on;
endfunction

function R = R(points, angle)
  rot = [cos(angle), -sin(angle); sin(angle), cos(angle)];
  R = (rot*points')';
endfunction