function [Coll tf raf vaf rbf vbf] = Devoir3(rai, vai, rbi, vbi, tb)
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
  rota = atan2(vai(2), vai(1));
  rotb = atan2(vbi(2), vbi(1));
  
  
  collision = false;
  
  deltaT = 0.1;
  curT = 0.0;
  
  while (norm(qas(1:2)) > 0.01 || norm(qbs(1:2) > 0.01)) && not(collision)
    qa0 = qas;
    qb0 = qbs;
    
    if tb > 0.0 && curT < tb
      [deltaT qas] = SEDRK4t0E(qa0, curT, curT + deltaT, wa0, epsilon, @gfrt, a.masse);
      rota = rota + wa0*tb;
      qbs = gcst(qb0, tb);
      # L'auto b ne tourne pas encore sur elle-même.
      curT = tb;
      # Vérifier s'il y a eu potentielle collision, sinon la boucle va continuer normalement.
    else
      [dta qas] = SEDRK4t0E(qa0, curT, curT + deltaT, wa0, epsilon, @gfrt, a.masse);
      [dtb qas] = SEDRK4t0E(qb0, curT, curT + deltaT, wb0, epsilon, @gfrt, b.masse);
      deltaT = min(dta, dtb);
      rota = rota + wa0*deltaT;
      rotb = rotb + wb0*deltaT;
    endif
  endwhile
  
  #[vaf vbf waf wbf] = resCollision(qai, qbi, wai, wbi, normale, pointCollision);
  
endfunction

function dessinerGraphique(constantes, positions, name)
  voitureA = constantes.autos.a;
  voitureB = constantes.autos.b;
  
  c = [["blue" "red"]];
  figure('name', name);
  line = plot(10,20,"-b",20,30,"-r")
  set (line(1), "linewidth", 2); 
  verticesA = [0 0; 1 0; 1 1; 0 1];
  faceA = [1 2 3 4]
  patch('Faces',faceA,'Vertices',verticesA,'FaceColor', "blue");
  verticesB = [4 5; 5 5; 5 4; 4 4];
  faceB = [1 2 3 4]
  patch('Faces',faceB,'Vertices',verticesB,'FaceColor', "red");
  axis([0,100,0,100])
  view(2)
  grid on
endfunction