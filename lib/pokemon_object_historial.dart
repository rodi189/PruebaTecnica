class PokemonHistorial {
  PokemonHistorial({
    required this.versiones,
    required this.pokedex,
  });

  final List versiones;
  final String pokedex;

  PokemonHistorial.fromJson(Map json)
      : this(versiones: json["versiones"] ?? [], pokedex: json["pokedex"]);

  Map<String, dynamic> toJson() {
    return {'versiones': versiones, "pokedex": pokedex};
  }
}
