function centre_de_masse = CentreDeMasse(AngRot, posNL)
  %Navette
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
  
  global navette_masse_tonnes;
  global reservoir_masse_tonnes_hydrogene;
  global reservoir_masse_tonnes_oxygene;
  global booster_masse_tonnes;
  
  %Cylindre de la navette
  navette_cyl_c = [0; 0; navette_cyl_h/2];
  %Cône de la navette
  navette_cone_c = [0; 0; navette_cyl_h + navette_cone_h/4];
  
  %Cylindre de la réservoir (2/3 en bas)
  reservoir_cyl_hydrogene_c = [0; navette_cyl_r * 2 + reservoir_cyl_r; reservoir_cyl_h_hydrogene * 1/2];
  %Cylindre de la réservoir (1/3 en haut)
  reservoir_cyl_oxygene_c = [0; navette_cyl_r * 2 + reservoir_cyl_r; reservoir_cyl_h - reservoir_cyl_h_oxygene /2];
  %Cône de la réservoir
  reservoir_cone_c = [0; navette_cone_r +  reservoir_cone_r; reservoir_cyl_h + reservoir_cone_h/4];

  % Propulseur gauche
  booster_cyl_gauche_c = [
    -(reservoir_cyl_r + booster_cyl_r);
    (navette_cyl_r + reservoir_cyl_r);
    booster_cyl_h/2];

  booster_cone_gauche_c = [
    -(reservoir_cyl_r + booster_cyl_r);
    (navette_cyl_r + reservoir_cyl_r);
    (booster_cyl_h + booster_cone_h/4)];

  % Propulseur droite
  booster_cyl_droite_c = [
    -booster_cyl_gauche_c(1);
    booster_cyl_gauche_c(2);
    booster_cyl_gauche_c(3)];

  booster_cone_droite_c = [
    -booster_cone_gauche_c(1);
    booster_cone_gauche_c(2);
    booster_cone_gauche_c(3)];
    
  % Volume des parties de la navette 
  navette_cyl_volume = navette_cyl_r^2 * pi * navette_cyl_h;
  navette_cone_volume = navette_cone_r^2 * pi * navette_cone_h / 4;
  navette_total_volume = navette_cyl_volume + navette_cone_volume;
  
  % Masse des parties de la navette
  global navette_cyl_masse_tonnes = navette_cyl_volume / navette_total_volume * navette_masse_tonnes;
  global navette_cone_masse_tonnes = navette_cone_volume / navette_total_volume * navette_masse_tonnes;
  
  % Volume des parties des propulseurs
  booster_cyl_volume = (pi*booster_cyl_r^2) * booster_cyl_h;
  booster_cone_volume = (pi*booster_cone_h*booster_cone_r^2) / 3;
  booster_total_volume = booster_cyl_volume + booster_cone_volume;        
  
  % Masse des parties des propulseurs
  global booster_cyl_masse_tonnes = booster_cyl_volume * booster_masse_tonnes / booster_total_volume;
  global booster_cone_masse_tonnes = booster_cone_volume * booster_masse_tonnes / booster_total_volume;
  
  % Volume des parties du réservoir
  reservoir_cyl_oxygene_volume = (pi*reservoir_cyl_r^2) * reservoir_cyl_h_oxygene;
  reservoir_cone_volume = (pi*reservoir_cone_h*reservoir_cone_r^2) / 3;
  reservoir_oxygene_total_volume = reservoir_cyl_oxygene_volume + reservoir_cone_volume;
  
  % Masse des parties du réservoir
  global reservoir_cyl_oxygene_masse_tonnes = reservoir_cyl_oxygene_volume * reservoir_masse_tonnes_oxygene / reservoir_oxygene_total_volume; 
  global reservoir_cone_oxygene_masse_tonnes = reservoir_cone_volume * reservoir_masse_tonnes_oxygene / reservoir_oxygene_total_volume;
  
  % Masse totale de la fusée
  global masse_totale = reservoir_masse_tonnes_hydrogene + reservoir_masse_tonnes_oxygene + navette_masse_tonnes + booster_masse_tonnes * 2;
  
  % Somme pondérée
  c_de_masse = (navette_cone_c * navette_cone_masse_tonnes + navette_cyl_c * navette_cyl_masse_tonnes +
                     reservoir_cone_c * reservoir_cone_oxygene_masse_tonnes + reservoir_cyl_hydrogene_c * reservoir_masse_tonnes_hydrogene + 
                     reservoir_cyl_oxygene_c * reservoir_cyl_oxygene_masse_tonnes +
                     (booster_cone_droite_c + booster_cone_gauche_c)* booster_cone_masse_tonnes +
                     (booster_cyl_droite_c + booster_cyl_gauche_c) * booster_cyl_masse_tonnes) / masse_totale; 
  disp(c_de_masse);
  
  % Matrice de rotation autour de x
  R_x = [1, 0, 0; 0, cos(AngRot), -sin(AngRot); 0, sin(AngRot), cos(AngRot)];
  display(R_x);
  % Appliquer la rotation
  %c_rot = R_x * (c_de_masse + posNL);
  
  c_rot = R_x * c_de_masse;
  display(c_rot);
  %Appliquer la translation
  centre_de_masse = c_rot + posNL;  
  
endfunction 