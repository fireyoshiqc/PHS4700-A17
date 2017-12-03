function constantes = defConstantes()
% ** Toutes les dimensions sont en mètres et les masses en kilogrammes **
constantes = struct(
  'cylindre',
  struct(
    'rayon', 2,
    'hauteur', 18,
    'centre', [4;4;11]
  ),
  'prisme',
  struct(
    'centre', [3.5;4;14.5],
    'dimensions', [1;2;5]
  ),
  'faces',
  struct(
    'rouge',
    struct(
      'centre', [3;4;14.5],
      'couleur', [1 0 0],
      'normale', [-1;0;0]
    ),
    'cyan',
    struct(
      'centre', [4;4;14.5],
      'couleur', [0 1 1],
      'normale', [1;0;0]
    ),
    'verte',
    struct(
      'centre', [3.5;3;14.5],
      'couleur', [0 1 0],
      'normale', [0;-1;0]
    ),
    'jaune',
    struct(
      'centre', [3.5;5;14.5],
      'couleur', [1 1 0],
      'normale', [0;1;0]
    ),
    'bleue',
    struct(
      'centre', [3.5;4;12],
      'couleur', [0 0 1],
      'normale', [0;0;-1]
    ),
    'magenta',
    struct(
      'centre', [3.5;4;17],
      'couleur', [1 0 1],
      'normale', [0;0;1]
    )
  )
);
endfunction