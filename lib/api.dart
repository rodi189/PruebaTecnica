// ignore_for_file: unnecessary_string_interpolations

import 'package:dio/dio.dart';

import 'helpers.dart';

String urlAPI = "https://pokeapi.co/api/v2/pokemon/";
List listPokemons = [];
Map mapPokemons = {};

Future<void> getPokemons() async {
  Dio dio = Dio();
  //String resultado = "fail";

  print("getPokemons");
  for (var i = 0; i < 10; i++) {
    await dio.get("$urlAPI${i + 1}").then((value) {
      if (noVoid(value)) {
        if (value.statusCode == 200) {
          Map auxData = value.data;
          Map customData = {
            "pokedex": "${i + 1}",
            "name": auxData["name"],
            "height": auxData["height"],
            "weight": auxData["weight"],
          };
          listPokemons.add(customData);
          mapPokemons["${i + 1}"] = customData;
        }
      }
    });
  }
}
