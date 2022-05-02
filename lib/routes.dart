import 'package:flutter/material.dart';

import 'historial_pokemon_seleccionado.dart';
import 'inicio.dart';
import 'login.dart';
import 'nuevo_pokemon.dart';
import 'pokemon_seleccionado.dart';

Route<dynamic> getRoutes(RouteSettings settings) {
  var argumentsSend = settings.arguments ?? {};
  switch (settings.name) {
    case "login":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Login();
      });
      break;
    case "inicio":
      return MaterialPageRoute(builder: (BuildContext context) {
        return Inicio();
      });
      break;
    case "updatepokemon":
      return MaterialPageRoute(builder: (BuildContext context) {
        Map myMap;
        try {
          myMap = argumentsSend as Map;
        } catch (e) {
          myMap = {};
        }
        return PokemonSeleccionado(
          pokedex: myMap["pokedex"] ?? "",
        );
      });
      break;
    case "createpokemon":
      return MaterialPageRoute(builder: (BuildContext context) {
        Map myMap;
        try {
          myMap = argumentsSend as Map;
        } catch (e) {
          myMap = {};
        }
        return NuevoPokemon(
          pokedex: myMap["pokedex"] ?? "",
        );
      });
      break;
    case "historial":
      return MaterialPageRoute(builder: (BuildContext context) {
        Map myMap;
        try {
          myMap = argumentsSend as Map;
        } catch (e) {
          myMap = {};
        }
        return HistorialPokemon(
          pokedex: myMap["pokedex"] ?? "",
        );
      });
      break;
    default:
      return MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    //child: InkWell(onTap: () {},child: Icon(Icons.arrow_back)),
                    ),
                Container(
                    margin: EdgeInsets.only(left: 10.0),
                    child: Text("No disponible.")),
              ],
            )),
          ),
        );
      });
  }
}
