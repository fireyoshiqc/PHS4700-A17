function moment_inertie = MomentInertie(AngRot, posNL, constantes, masses, cm)
  
  navette = constantes.navette;
  reservoir = constantes.reservoir;
  booster = constantes.booster;
  
  % Moment inertie locale
  %reservoir (local)
  reservoir_cone_oxygene_I = MomentInertieCone(masses.reservoir.cone_oxygene , reservoir.cone.r, reservoir.cone.h);
  reservoir_cyl_oxygene_I = MomentInertieCyl(masses.reservoir.cyl_oxygene , reservoir.cyl.r, reservoir.cyl.h_oxygene);
  reservoir_cyl_hydrogene_I = MomentInertieCyl(reservoir.masse_kg_hydrogene , reservoir.cyl.r, reservoir.cyl.h_hydrogene);
  
  %navette(local)
  navette_cone_I = MomentInertieCone(masses.navette.cone , navette.cone.r, navette.cone.h);
  navette_cyl_I = MomentInertieCyl(masses.navette.cyl , navette.cyl.r, navette.cyl.h);
  
  %propulseurs(local)
  booster_cone_I = MomentInertieCone(masses.booster.cone , booster.cone.r, booster.cone.h);
  booster_cyl_I = MomentInertieCyl(masses.booster.cyl , booster.cyl.r, booster.cyl.h);
  
  %distance entre les centres de masses des parties et le centre de masse fusee
  d_reservoir_cone = cm.reservoir.cone - cm.local;
  d_reservoir_cyl_oxygene = cm.reservoir.cyl_oxygene - cm.local;
  d_reservoir_cyl_hydrogene = cm.reservoir.cyl_hydrogene - cm.local;
  d_navette_cone = cm.navette.cone - cm.local;
  d_navette_cyl = cm.navette.cyl - cm.local;
  d_booster_cyl_gauche = cm.booster.cyl_gauche - cm.local;
  d_booster_cyl_droite = cm.booster.cyl_droite - cm.local;
  d_booster_cone_gauche = cm.booster.cone_droite - cm.local;
  d_booster_cone_droite = cm.booster.cone_gauche - cm.local;
  
  % Moment inertie par rapport au centre de masse de la fusee
  % reservoir
  reservoir_cone_I_G = reservoir_cone_oxygene_I +  masses.reservoir.cone_oxygene  * MatriceTranslation(d_reservoir_cone);  
  reservoir_cyl_oxygene_I_G = reservoir_cyl_oxygene_I + masses.reservoir.cyl_oxygene  * MatriceTranslation(d_reservoir_cyl_oxygene);
  reservoir_cyl_hydrogene_I_G = reservoir_cyl_hydrogene_I + reservoir.masse_kg_hydrogene  * MatriceTranslation(d_reservoir_cyl_hydrogene);
  
  %navette
  navette_cone_I_G = navette_cone_I + masses.navette.cone  * MatriceTranslation(d_navette_cone);
  navette_cyl_I_G = navette_cyl_I + masses.navette.cyl  * MatriceTranslation(d_navette_cyl);
  
  %propulseur 
  booster_cone_gauche_I_G = booster_cone_I + masses.booster.cone  * MatriceTranslation(d_booster_cone_gauche);
  booster_cyl_gauche_I_G = booster_cyl_I + masses.booster.cyl  * MatriceTranslation(d_booster_cyl_gauche);
  booster_cone_droite_I_G = booster_cone_I + masses.booster.cone  * MatriceTranslation(d_booster_cone_droite);
  booster_cyl_droite_I_G = booster_cyl_I + masses.booster.cyl  * MatriceTranslation(d_booster_cyl_droite);
  
  % Somme des moments d'inertie
  fusee_I = (reservoir_cone_I_G + reservoir_cyl_oxygene_I_G + reservoir_cyl_hydrogene_I_G + navette_cone_I_G + navette_cyl_I_G + booster_cone_gauche_I_G + booster_cone_droite_I_G + booster_cyl_gauche_I_G + booster_cyl_droite_I_G);

  % Ramener dans le système d'axes du laboratoire en appliquant la rotation du système local
  % Matrice de rotation autour de x
  R_x = [1, 0, 0; 0, cos(AngRot), -sin(AngRot); 0, sin(AngRot), cos(AngRot)];
  R_x_inverse = inv(R_x);

  % Appliquer la rotation
  moment_inertie = R_x * fusee_I * R_x_inverse;
    
endfunction

function momentinertiecone = MomentInertieCone(m, r, h)
  momentinertiecone = m * [(12*r^2 + 3*h^2)/80, 0, 0; 0, (12*r^2 + 3*h^2)/80, 0; 0, 0, (3*r^2)/10];
endfunction

function momentinertiecyl = MomentInertieCyl(m, r, h)
  momentinertiecyl = m * [(r^2)/4 + (h^2)/12, 0, 0; 0, (r^2)/4 + (h^2)/12, 0; 0, 0, (r^2)/2];
endfunction

function matricetranslation = MatriceTranslation(d)
  matricetranslation = [(d(2)^2 + d(3)^2), -d(1)*d(2), -d(1)*d(3);
                        -d(2)*d(1), (d(1)^2 + d(3)^2), -d(2)*d(3);
                        -d(3)*d(1), -d(3)*d(2), (d(1)^2 + d(2)^2)];
endfunction