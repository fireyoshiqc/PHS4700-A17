function [pcmNL INL alphaNL]=Devoir1(AngRot, vangulaire, forces, posNL)
  % Load les valeurs
  main();
  % Centre de masse
  pcmNL = CentreDeMasse(AngRot, posNL);

  % Moment inertie
  INL = MomentInertie(AngRot, posNL);
  
  % Acc�l�ration angulaire
  alphaNL = AccelerationAngulaire(AngRot, vangulaire, forces);
endfunction