function [pcmNL, INL, alphaNL]=Devoir1(AngRot, vangulaire, forces, posNL)
  format short g
  % Load les valeurs
  constantes = defConstantes();
  % Centre de masse
  [cm masses] = CentreDeMasse(AngRot, posNL, constantes);
  pcmNL = cm.laboratoire;
 
  % Moment inertie
  INL = MomentInertie(AngRot, posNL, constantes, masses, cm);
  
  % Accélération angulaire
  alphaNL = AccelerationAngulaire(AngRot, vangulaire, forces, constantes, cm, INL);
endfunction