function moment_inertie = MomentInertie(AngRot, posNL)
  global navette_cyl_h;
  global navette_cone_h;
  global navette_cyl_r;
  global navette_cone_r;
  global reservoir_cyl_h;
  global reservoir_cone_h;
  global reservoir_cyl_r;
  global reservoir_cone_r;
  global reservoir_cyl_h_hydrogene;
  global reservoir_cyl_h_oxygene;
  global booster_cyl_r;
  global booster_cone_r;
  global booster_cyl_h;
  global booster_cone_h;
  
  global reservoir_cyl_oxygene_masse_kg;
  global reservoir_cone_oxygene_masse_kg;
  global reservoir_masse_kg_hydrogene;
  global navette_cone_masse_kg;
  global navette_cyl_masse_kg;
  global booster_cyl_masse_kg;
  global booster_cone_masse_kg;
  global masse_totale;
  % centre de masses
  global navette_cyl_c;
  global navette_cone_c;
  global reservoir_cyl_hydrogene_c;
  global reservoir_cyl_oxygene_c;
  global reservoir_cone_c;
  global booster_cyl_gauche_c;
  global booster_cyl_droite_c;
  global booster_cone_droite_c;
  global booster_cone_gauche_c;
  global c_de_masse;
  
  % Moment inertie locale
  %reservoir (local)
  reservoir_cone_oxygene_I = MomentInertieCone(reservoir_cone_oxygene_masse_kg , reservoir_cone_r, reservoir_cone_h);
  reservoir_cyl_oxygene_I = MomentInertieCyl(reservoir_cyl_oxygene_masse_kg , reservoir_cyl_r, reservoir_cyl_h_oxygene);
  reservoir_cyl_hydrogene_I = MomentInertieCyl(reservoir_masse_kg_hydrogene , reservoir_cyl_r, reservoir_cyl_h_hydrogene);
  
  %navette(local)
  navette_cone_I = MomentInertieCone(navette_cone_masse_kg , navette_cone_r, navette_cone_h);
  navette_cyl_I = MomentInertieCyl(navette_cyl_masse_kg , navette_cyl_r, navette_cyl_h);
  
  %propulseurs(local)
  booster_cone_I = MomentInertieCone(booster_cone_masse_kg , booster_cone_r, booster_cone_h);
  booster_cyl_I = MomentInertieCyl(booster_cyl_masse_kg , booster_cyl_r, booster_cyl_h);
  
  %distance entre les centres de masses des parties et le centre de masse fusee
  d_reservoir_cone = reservoir_cone_c - c_de_masse;
  d_reservoir_cyl_oxygene = reservoir_cyl_oxygene_c - c_de_masse;
  d_reservoir_cyl_hydrogene = reservoir_cyl_hydrogene_c - c_de_masse;
  d_navette_cone = navette_cone_c - c_de_masse;
  d_navette_cyl = navette_cyl_c - c_de_masse;
  d_booster_cyl_gauche = booster_cyl_gauche_c - c_de_masse;
  d_booster_cyl_droite = booster_cyl_droite_c - c_de_masse;
  d_booster_cone_gauche = booster_cone_droite_c - c_de_masse;
  d_booster_cone_droite = booster_cone_gauche_c - c_de_masse;
  
  % Moment inertie par rapport au centre de masse de la fusee
  % reservoir
  reservoir_cone_I_G = reservoir_cone_oxygene_I +  reservoir_cone_oxygene_masse_kg  * MatriceTranslation(d_reservoir_cone);  
  reservoir_cyl_oxygene_I_G = reservoir_cyl_oxygene_I + reservoir_cyl_oxygene_masse_kg  * MatriceTranslation(d_reservoir_cyl_oxygene);
  reservoir_cyl_hydrogene_I_G = reservoir_cyl_hydrogene_I + reservoir_masse_kg_hydrogene  * MatriceTranslation(d_reservoir_cyl_hydrogene);
  
  %navette
  navette_cone_I_G = navette_cone_I + navette_cone_masse_kg  * MatriceTranslation(d_navette_cone);
  navette_cyl_I_G = navette_cyl_I + navette_cyl_masse_kg  * MatriceTranslation(d_navette_cyl);
  
  %propulseur 
  booster_cone_gauche_I_G = booster_cone_I + booster_cone_masse_kg  * MatriceTranslation(d_booster_cone_gauche);
  booster_cyl_gauche_I_G = booster_cyl_I + booster_cyl_masse_kg  * MatriceTranslation(d_booster_cyl_gauche);
  booster_cone_droite_I_G = booster_cone_I + booster_cone_masse_kg  * MatriceTranslation(d_booster_cone_droite);
  booster_cyl_droite_I_G = booster_cyl_I + booster_cyl_masse_kg  * MatriceTranslation(d_booster_cyl_droite);
  
  % Somme des moments d'inertie
  fusee_I = (reservoir_cone_I_G + reservoir_cyl_oxygene_I_G + reservoir_cyl_hydrogene_I_G + navette_cone_I_G + navette_cyl_I_G + booster_cone_gauche_I_G + booster_cone_droite_I_G + booster_cyl_gauche_I_G + booster_cyl_droite_I_G);

  % Ramener dans le système d'axes du laboratoire en appliquant la rotation du système local
  % Matrice de rotation autour de x
  R_x = [1, 0, 0; 0, cos(AngRot), -sin(AngRot); 0, sin(AngRot), cos(AngRot)];
  R_x_inverse = inv(R_x);
  
  display(R_x);
  display(R_x_inverse);

  % Appliquer la rotation
  global moment_inertie = R_x * fusee_I * R_x_inverse;
  
  display(moment_inertie);
    
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