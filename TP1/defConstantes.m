function constantes = defConstantes()
  constantes = struct(
    'navette',
    struct(
      'cone',
        struct(
          'h', 9.31,
          'r', 3.5
        ),
      'cyl',
        struct(
          'h', 27.93,
          'r', 3.5
        ),
      'masse_kg', 109*1000
    ),
    'reservoir',
    struct(
      'cone',
        struct(
          'h', 7.8,
          'r', 4.2
        ),
      'cyl',
        struct(
          'h', 39.1,
          'r', 4.2,
          'h_hydrogene', 46.9*(2/3),
          'h_oxygene', 39.1-(46.9*(2/3))
        ),
      'masse_kg_hydrogene', 108*1000,
      'masse_kg_oxygene', 631*1000
    ),
    'booster',
    struct(
      'cone',
        struct(
          'h', 5.6,
          'r', 1.855
        ),
      'cyl',
        struct(
          'h', 39.9,
          'r', 1.855
        ),
      'masse_kg', 469*1000
    )
  );
endfunction