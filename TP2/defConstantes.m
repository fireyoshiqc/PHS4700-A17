function constantes = defConstantes()
% **Toutes les dimensions sont en mètres et les masses en kilogrammes**
constantes = struct(
  'table',
  struct(
    'h', 0.76,
    'long', 2.76,
    'larg', 1.525
  ),
  'filet',
  struct(
    'h', 0.1525,
    'larg', 1.83,
    'deborde', 0.1525
  ),
  'balle',
  struct(
    'm', 2.74 / 1000,
    'r', 1.99 / 100,
    'vmax', 35,
    'wmax', 940
  ),
  'physiques',
  struct(
    'rho', 1.2,
    'cv', 0.5,
    'cm', 0.29
  ),
  'epsilon', [0.001, 0.001, 0.001]
);
endfunction