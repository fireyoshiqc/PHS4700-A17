function Simulation()
  pkg load statistics
    
  rai = [
  0 0;
  0 0;
  0 0;
  0 0;
  0 0;
  0 0];
  
  vai = [
  20 0 2;
  30 0 2;
  20 0 2;
  10 10 1;
  20 0 2;
  20 2 2];

  rbi = [
  100 100;
  100 100;
  100 50;
  25 10;
  100 50;
  100 10];
  
  vbi = [
  0 -20 -1;
  0 -30 -1;
  0 -10 0;
  10 0 0;
  0 -10 0;
  10 0 5];
    
  tb = [
  0.0;
  0.0;
  1.6;
  0.0;
  0.0;
  1.0];
  
  for sim = 1:6
    name = strcat(" Sim ", num2str(sim));
    [Coll tf raf vaf rbf vbf] = Devoir3(rai(sim,:), vai(sim,:), rbi(sim,:), vbi(sim,:), tb(sim,:), name);
    display(Coll);
    display(tf);
    display(raf);
    display(vaf);
    display(rbf);
    display(vbf);
  end
  
endfunction