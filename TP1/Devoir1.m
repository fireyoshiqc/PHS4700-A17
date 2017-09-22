function [pcmNL INL alphaNL]=Devoir1(AngRot, vangulaire, forces, posNL)
  % Load les valeurs
  main();
  % Centre de masse
  pcmNL = CentreDeMasse(AngRot, posNL);

  % Moment inertie
  INL = MomentInertie(AngRot, posNL);
  
  % Accélération angulaire
  alphaNL = AccelerationAngulaire(AngRot, vangulaire, forces);
endfunction