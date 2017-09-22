function [pcmNL INL alphaNL]=Devoir1(AngRot, vangulaire, forces, posNL)
  format short g
  % Load les valeurs
  main();
  % Centre de masse
  pcmNL = CentreDeMasse(AngRot, posNL);
  display(pcmNL);

  % Moment inertie
  INL = MomentInertie(AngRot, posNL);
  display(INL);
  
  % Accélération angulaire
  alphaNL = AccelerationAngulaire(AngRot, vangulaire, forces);
endfunction