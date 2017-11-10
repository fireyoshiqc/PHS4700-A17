function [vaf vbf] = resCollision(qai, qbi, wai, wbi, normale, pointCollision)
  constantes = defConstantes();
  a = constantes.autos.a;
  b = constantes.autos.b;
  rap = [pointCollision; 0]-[qai(3); qai(4); 0];
  rbp = [pointCollision; 0]-[qbi(3); qbi(4); 0];
  vap = [qai(1); qai(2); 0] + cross([0; 0; wai], rap);
  vbp = [qbi(1); qbi(2); 0] + cross([0; 0; wbi], rbp);
  vr = dot([normale; 0], (vap-vbp));
  j = -((1 + 0.8)*vr)/((1/a.masse) + (1/b.masse));
  Ia = (a.masse/12)*(a.long^2+a.larg^2);
  Ib = (b.masse/12)*(b.long^2+b.long^2);
  
  waf = wai + j*(1/Ia)*(cross(rap, [normale; 0]))(3);
  wbf = wbi - j*(1/Ib)*(cross(rbp, [normale; 0]))(3);
  vaf = [qai(1:2)' + normale*j / a.masse; waf];
  vbf = [qbi(1:2)' - normale*j / b.masse; wbf];
endfunction