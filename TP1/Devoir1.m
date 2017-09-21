function [pcmNL INL alphaNL]=Devoir1(AngRot, vangulaire, forces, posNL)
  % Load les valeurs
  main();
  % Centre de masse
  pcmNL = CentreDeMasse(AngRot, posNL);
  display(pcmNL);
  % display(pcmNL);
  % Moment inertie
  INL = MomentInertie(AngRot, posNL);
  display(INL);
  
  alphaNL = AccelerationAngulaire(AngRot, vangulaire, forces, posNL);
endfunction