class Pokemon {
  Pokemon(
      {required this.name,
      required this.height,
      required this.weight,
      required this.pokedex,
      required this.date});

  final String name;
  final int height;
  final int weight;
  final String pokedex;
  final String date;

  Pokemon.fromJson(Map json)
      : this(
            name: json["name"] ?? "",
            pokedex: json["pokedex"] ?? "",
            height: json["height"] as int,
            weight: json["weight"] as int,
            date: json["date"] ?? "");

  Map<String, dynamic> toJson() {
    return {
      "pokedex": pokedex,
      'height': height,
      'name': name,
      'weight': weight,
      "date": date,
    };
  }
}
