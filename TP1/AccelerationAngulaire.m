function a_ang = AccelerationAngulaire(AngRot, vangulaire, forces, constantes, cm, moment_inertie)

  moment_cinetique = moment_inertie * vangulaire;
  
  d_force_booster_gauche = [-constantes.reservoir.cyl.r-constantes.booster.cyl.r; constantes.navette.cyl.r+constantes.reservoir.cyl.r; 0] - cm.local;
  d_force_booster_droite = [constantes.reservoir.cyl.r+constantes.booster.cyl.r; constantes.navette.cyl.r+constantes.reservoir.cyl.r; 0] - cm.local;
  d_force_navette = [0;0;0] - cm.local;

  moment_navette = cross(d_force_navette, [0; 0; forces(1)]);
  moment_booster_gauche = cross(d_force_booster_gauche, [0; 0; forces(2)]);
  moment_booster_droite = cross(d_force_booster_droite, [0; 0; forces(3)]);
  
  somme_moments = moment_navette + moment_booster_gauche + moment_booster_droite;
  
  % Matrice de rotation autour de x pour les moments de force
  R_x = [1, 0, 0; 0, cos(AngRot), -sin(AngRot); 0, sin(AngRot), cos(AngRot)];
  moments_rot = R_x * somme_moments;
  
  % alpha = I^-1 * (tau + L x omega)
  a_ang = inverse(moment_inertie)*(moments_rot+cross(moment_cinetique, vangulaire));
  
endfunction
  