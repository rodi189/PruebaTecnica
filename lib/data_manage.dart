import 'api.dart';
import 'firestore_db.dart';

List listPokemons = [];
Map mapPokemons = {};

List listPokemonsHistorial = [];
Map mapPokemonsHistorial = {};

void conbinarDatos() {
  listPokemons = [];
  mapPokemons = {};
  mapPokemonsFirestore.forEach((key, value) {
    if (mapPokemonsAPI.containsKey(key) == true) {
      Map auxDataPokemonFirestore = mapPokemonsFirestore[key];
      mapPokemons[key] = auxDataPokemonFirestore;
      listPokemons.add(auxDataPokemonFirestore);
    } else {
      mapPokemons[key] = value;
      listPokemons.add(value);
    }
  });
  try {
    listPokemons.sort((a, b) {
      String pokedexA = a["pokedex"];
      String pokedexB = b["pokedex"];
      int valueA = int.tryParse(pokedexA) ?? 0;
      int valueB = int.tryParse(pokedexB) ?? 0;
      return valueA.compareTo(valueB);
    });
  } catch (e) {
    print("error sort pokemons $e");
  }
}
