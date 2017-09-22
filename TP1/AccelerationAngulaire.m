function a_ang = AccelerationAngulaire(AngRot, vangulaire, forces)
  global c_de_masse;
  global moment_inertie;
  
  global reservoir_cyl_r;
  global navette_cyl_r;
  global booster_cyl_r;
  
  moment_cinetique = moment_inertie * vangulaire;
  display(moment_cinetique);
  
  d_force_booster_gauche = [-reservoir_cyl_r-booster_cyl_r; navette_cyl_r+reservoir_cyl_r; 0] - c_de_masse;
  d_force_booster_droite = [reservoir_cyl_r+booster_cyl_r; navette_cyl_r+reservoir_cyl_r; 0] - c_de_masse;
  d_force_navette = [0;0;0] - c_de_masse;

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
  