function momentintertie = MomentInertie()
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
  
  global reservoir_cyl_oxygene_masse_tonnes;
  global reservoir_cone_oxygene_masse_tonnes;
  global reservoir_masse_tonnes_hydrogene;
  global navette_cone_masse_tonnes;
  global navette_cyl_masse_tonnes;
  global booster_cyl_masse_tonnes;
  global booster_cone_masse_tonnes;
  global masse_totale;
  
  %reservoir
  reservoir_cone_oxygene_I = MomentInertieCone(reservoir_cone_oxygene_masse_tonnes, reservoir_cone_r, reservoir_cone_h);
  reservoir_cyl_oxygene_I = MomentInertieCyl(reservoir_cyl_oxygene_masse_tonnes, reservoir_cyl_r, reservoir_cyl_h_oxygene);
  reservoir_cyl_hydrogene_I = MomentInertieCyl(reservoir_masse_tonnes_hydrogene, reservoir_cyl_r, reservoir_cyl_h_hydrogene);
  
  %navette
  navette_cone_I = MomentInertieCone(navette_cone_masse_tonnes, navette_cone_r, navette_cone_h);
  navette_cyl_I = MomentInertieCyl(navette_cyl_masse_tonnes, navette_cyl_r, navette_cyl_h);
  
  %propulseurs
  booster_cone_I = MomentInertieCone(booster_cone_masse_tonnes, booster_cone_r, booster_cone_h);
  booster_cyl_I = MomentInertieCyl(booster_cyl_masse_tonnes, booster_cyl_r, booster_cyl_h);
  
  %moment inertie par rapport au centre de masse de la fusée
  reservoir_cone_oxygene_I_f =   
  
endfunction

function momentinertiecone = MomentInertieCone(m, r, h)
  momentinertiecone = m * [(12*r^2 + 3*h^2)/80, 0, 0; 0, (12*r^2 + 3*h^2)/80, 0; 0, 0, 3*r^2/10];
endfunction

function momentinertiecyl = MomentInertieCyl(m, r, h)
  momentinertiecyl = m * [r^2/4 + h^2/12, 0, 0; 0, r^2/4 + h^2/12, 0; 0, 0, r^2/2];
endfunction