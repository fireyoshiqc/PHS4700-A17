function constantes = defConstantes()
% ** Toutes les dimensions sont en mètres et les masses en kilogrammes **
constantes = struct(
  'cylindre',
  struct(
    'rayon', 2,
    'hauteur', 18,
    'centre', [4;4;11]
  ),
  'faces',
  struct(
    'rouge',
    struct(
      'centre', [3;4;14.5],
      'hauteur', 5,
      'largeur', 2,
      'couleur', [1;1;0]
    ),
    'cyan',
    struct(
      'centre', [4;4;14.5],
      'hauteur', 5,
      'largeur', 2,
      'couleur', [0;1;1]
    ),
    'verte',
    struct(
      'centre', [3.5;3;14.5],
      'hauteur', 5,
      'largeur', 1,
      'couleur', [0;1;0]
    ),
    'jaune',
    struct(
      'centre', [3.5;5;14.5],
      'hauteur', 5,
      'largeur', 1,
      'couleur', [1;1;0]
    ),
    'bleue',
    struct(
      'centre', [3.5;4;12],
      'longueur', 2,
      'largeur', 1,
      'couleur', [0;0;1]
    ),
    'rouge',
    struct(
      'centre', [3.5;4;17],
      'longueur', 2,
      'largeur', 1,
      'couleur', [1;0;1]
    )
  )
);
endfunction