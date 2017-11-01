function constantes = defConstantes()
% ** Toutes les dimensions sont en mètres et les masses en kilogrammes **
constantes = struct(
  'autos',
  struct(
    'a',
    struct(
      'masse', 1540,
      'long', 4.78,
      'larg', 1.82,
      'h', 1.8
    ),
    'b',
    struct(
      'masse', 1010,
      'long', 4.23,
      'larg', 1.6,
      'h', 1.8
    )
  )
);
endfunction