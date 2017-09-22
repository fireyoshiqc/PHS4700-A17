function main()
# **Toutes les dimensions sont en mètres**
# Dimensions de la navette
global navette_cyl_h = 27.93
global navette_cyl_r = 3.5
global navette_cone_h = 9.31
global navette_cone_r = navette_cyl_r

global navette_masse_kg = 109 * 1000

# Dimensions du réservoir
global reservoir_cyl_h = 39.1
global reservoir_cyl_r = 4.2
global reservoir_cone_h = 7.8
global reservoir_cone_r = reservoir_cyl_r

global reservoir_cyl_h_hydrogene = (reservoir_cyl_h + reservoir_cone_h)*(2/3)
global reservoir_cyl_h_oxygene = (reservoir_cyl_h - reservoir_cyl_h_hydrogene)

global reservoir_masse_kg_hydrogene = 108 * 1000
global reservoir_masse_kg_oxygene = 631 * 1000

# Dimensions des propulseurs d'appoint
global booster_cyl_h = 39.9
global booster_cyl_r = 1.855
global booster_cone_h = 5.6
global booster_cone_r = booster_cyl_r

global booster_masse_kg = 469 * 1000

 


