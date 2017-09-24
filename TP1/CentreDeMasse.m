function [cm masses] = CentreDeMasse(AngRot, posNL, constantes)
  %Navette
  navette = constantes.navette;
  reservoir = constantes.reservoir;
  booster = constantes.booster;
  
  cm = struct;
  masses = struct;
  
  %Cylindre de la navette
  cm.navette.cyl = [0; 0; navette.cyl.h/2];
  
  %Cône de la navette
  cm.navette.cone = [0; 0; navette.cyl.h + navette.cone.h/4];
  
  %Cylindre de la réservoir (2/3 en bas)
  cm.reservoir.cyl_hydrogene = [0; navette.cyl.r + reservoir.cyl.r; reservoir.cyl.h_hydrogene * 1/2];

  %Cylindre de la réservoir (1/3 en haut)
  cm.reservoir.cyl_oxygene = [0; navette.cyl.r + reservoir.cyl.r; reservoir.cyl.h - reservoir.cyl.h_oxygene /2];
  
  %Cône de la réservoir
  cm.reservoir.cone = [0; navette.cone.r +  reservoir.cone.r; reservoir.cyl.h + reservoir.cone.h/4];

  % Propulseur gauche
  cm.booster.cyl_gauche = [
    -(reservoir.cyl.r + booster.cyl.r);
    (navette.cyl.r + reservoir.cyl.r);
    booster.cyl.h/2];

  cm.booster.cone_gauche = [
    -(reservoir.cyl.r + booster.cyl.r);
    (navette.cyl.r + reservoir.cyl.r);
    (booster.cyl.h + booster.cone.h/4)];

  % Propulseur droite
  cm.booster.cyl_droite = [
    -cm.booster.cyl_gauche(1);
    cm.booster.cyl_gauche(2);
    cm.booster.cyl_gauche(3)];

  cm.booster.cone_droite = [
    -cm.booster.cone_gauche(1);
    cm.booster.cone_gauche(2);
    cm.booster.cone_gauche(3)];
    
  % Volume des parties de la navette 
  navette_cyl_volume = navette.cyl.r^2 * pi * navette.cyl.h;
  navette_cone_volume = (navette.cone.r^2 * pi * navette.cone.h) / 3;
  navette_total_volume = navette_cyl_volume + navette_cone_volume;
  
  % Masse des parties de la navette
  masses.navette.cyl = navette_cyl_volume / navette_total_volume * navette.masse_kg;
  masses.navette.cone = navette_cone_volume / navette_total_volume * navette.masse_kg;
  
  % Volume des parties des propulseurs
  booster_cyl_volume = (pi*booster.cyl.r^2) * booster.cyl.h;
  booster_cone_volume = (pi*booster.cone.h*booster.cone.r^2) / 3;
  booster_total_volume = booster_cyl_volume + booster_cone_volume;        
  
  % Masse des parties des propulseurs
  masses.booster.cyl = booster_cyl_volume / booster_total_volume * booster.masse_kg;
  masses.booster.cone = booster_cone_volume / booster_total_volume * booster.masse_kg;
  
  % Volume des parties du réservoir
  reservoir_cyl_oxygene_volume = (pi*reservoir.cyl.r^2) * reservoir.cyl.h_oxygene;
  reservoir_cone_volume = (pi*reservoir.cone.h*reservoir.cone.r^2) / 3;
  reservoir_oxygene_total_volume = reservoir_cyl_oxygene_volume + reservoir_cone_volume;
  
  % Masse des parties du réservoir
  masses.reservoir.cyl_oxygene = reservoir_cyl_oxygene_volume / reservoir_oxygene_total_volume * reservoir.masse_kg_oxygene; 
  masses.reservoir.cone_oxygene = reservoir_cone_volume / reservoir_oxygene_total_volume * reservoir.masse_kg_oxygene;
  
  % Masse totale de la fusée
  masse_totale = reservoir.masse_kg_hydrogene + reservoir.masse_kg_oxygene + navette.masse_kg + booster.masse_kg * 2;
  
  % Somme pondérée
  cm.local = (cm.navette.cone * masses.navette.cone + cm.navette.cyl * masses.navette.cyl +
                     cm.reservoir.cone * masses.reservoir.cone_oxygene + cm.reservoir.cyl_hydrogene * reservoir.masse_kg_hydrogene + 
                     cm.reservoir.cyl_oxygene * masses.reservoir.cyl_oxygene +
                     (cm.booster.cone_droite + cm.booster.cone_gauche)* masses.booster.cone +
                     (cm.booster.cyl_droite + cm.booster.cyl_gauche) * masses.booster.cyl) / masse_totale;
  
  % Matrice de rotation autour de x
  R_x = [1, 0, 0; 0, cos(AngRot), -sin(AngRot); 0, sin(AngRot), cos(AngRot)];
  % Appliquer la rotation
  %c_rot = R_x * (cm.local + posNL);
  
  c_rot = R_x * cm.local;
  %Appliquer la translation
  cm.laboratoire = c_rot + posNL;
  
endfunction 