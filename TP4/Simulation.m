function Simulation()
  pkg load statistics
    
  nout = [1; 1; 1; 1.2];
  
  nin = [1; 1.5; 1.5; 1];

  poso = [
  0 0 5;
  0 0 5;
  0 0 0;
  0 0 5];
 
  
  for sim = 1:4
    name = strcat(" Sim ", num2str(sim));
    [xi yi zi face] = Devoir4 (nout(sim), nin(sim), poso(sim,:), name);
    display(xi);
    display(yi);
    display(zi);
    display(face);
  end
  
endfunction