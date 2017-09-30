function Simulation()
  rbi = [
  0.00 0.50 1.10;
  0.00 0.40 1.14;
  2.74 0.50 1.14;
  0.00 0.30 1.00];
  
  vbi = [
  4.00 0.00 0.80;
  10.00 1.00 0.20;
  -5.00 0.00 0.20;
  10.00 -2.00 0.20];

  wbi = [
  0.00 -70.00 0.00;
  0.00 100.00 -50.00;
  0.00 100.00 0.00;
  0.00 10.00 -100.00];
  
  for sim = 1:4
    for opt = 1:3
      [coup tf rbf vbf] = Devoir2(opt, rbi(sim,:), vbi(sim,:), wbi(sim,:));
      display(strcat("Sim ",num2str(sim)," Option ",num2str(opt)));
      display(coup);
      display(tf);
      display(rbf);
      display(vbf);
    end
  end
  
endfunction