function [vaf vbf waf wbf] = resCollision(qai, qbi, wai, wbi, normale, pointCollision)
  constantes = defConstantes();
  a = constantes.autos.a;
  b = constantes.autos.b;
  rap = pointCollision-qai(3:4);
  rbp = pointCollision-qbi(3:4);
  vap = vai + cross(wai, rap);
  vbp = vbi + cross(wbi, rbp);
  vr = normale*(vap-vbp);
  j = -((1 + 0.8)*vr)/((1/a.masse) + (1/b.masse));
  Ia = (a.masse/12)*(a.long^2+a.larg^2);
  Ib = (b.masse/12)*(b.long^2+b.long^2);
  
  vaf = vai + normale*j / a.masse;
  vbf = vbi - normale*j / b.masse;
  waf = wai + j*(1/Ia)*(cross(rap, normale));
  wbf = wbi - j*(1/Ib)*(cross(rbp, normale));
endfunction