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
  wb0 = wbi(3);
  rota = atan2(vai(2), vai(1));
  rotb = atan2(vbi(2), vbi(1));
  
  
  collision = false;
  
  deltaT = 0.1;
  curT = 0.0;
  
  while (norm(qas(1:2)) > 0.01 or norm(qbs(1:2) > 0.01)) and not(collision)
    qa0 = qas;
    qb0 = qbs;
    
    if tb > 0.0 and curT < tb
      [deltaT qas] = SERKt40E(qa0, curT, curT + deltaT, wa0, epsilon, gfrt);
      rota = rota + wa0*tb;
      qbs = gcst(qb0, tb);
      # L'auto b ne tourne pas encore sur elle-même.
      curT = tb;
      # Vérifier s'il y a eu potentielle collision, sinon la boucle va continuer normalement.
    else
      [dta qas] = SERKt40E(qa0, curT, curT + deltaT, wa0, epsilon, gfrt);
      [dtb qas] = SERKt40E(qb0, curT, curT + deltaT, wb0, epsilon, gfrt);
      deltaT = min(dta, dtb);
      rota = rota + wa0*deltaT;
      rotb = rotb + wb0*deltaT;
  endwhile
  
endfunction
