// ignore_for_file: unnecessary_string_interpolations, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'auth.dart';
import 'data_manage.dart';
import 'firestore_db.dart';
import 'helpers.dart';
import 'states_manage.dart';

class Inicio extends StatefulWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<Inicio> createState() {
    inicioState = InicioState();
    return inicioState;
  }
}

class InicioState extends State<Inicio> {
  @override
  Widget build(BuildContext context) {
    conbinarDatos();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inicio"),
      ),
      drawer: getDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ListView(
          children: widgetsPokemons(),
        ),
      ),
    );
  }

  List<Widget> widgetsPokemons() {
    List<Widget> auxList = [];

    for (var i = 0; i < listPokemons.length; i++) {
      Map auxPokemon = listPokemons[i];
      if (noVoid(auxPokemon) == true) {
        String pokedex = auxPokemon["pokedex"];
        String nombre = auxPokemon["name"] ?? "----";
        if (noVoid(nombre) == false) {
          nombre = "---";
        }
        int altura = auxPokemon["height"] ?? 0;
        int peso = auxPokemon["weight"] ?? 0;
        auxList.add(widgetPokemon(pokedex, nombre, altura, peso));
      }
    }

    return auxList;
  }

  Widget widgetPokemon(String pokedex, String nombre, int altura, int peso) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "updatepokemon",
            arguments: {"pokedex": pokedex});
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: const Border.fromBorderSide(BorderSide(color: Colors.grey)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 2.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Text("Nombre: $nombre"),
                  ),
                  Container(
                    child: Text("Pokedex: $pokedex"),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 4.0),
                  child: Text("Altura: $altura"),
                ),
                Container(
                  child: Text("Peso: $peso"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getDrawer() {
    return Drawer(
      child: ListView(
        children: [
          /*ListTile(
            onTap: () async {
              Navigator.pop(context);
              await resetDataFirestore();
              await getPokemonsFirestore();
              setState(() {
                conbinarDatos();
              });
            },
            title: const Text("Reset data"),
          ),*/
          ListTile(
            onTap: () async {
              Navigator.pop(context);
              Navigator.pushNamed(context, "createpokemon");
            },
            title: const Text("Nuevo pokemon"),
          ),
          ListTile(
            onTap: () async {
              await cerrarSesion();
              cancelListeners();
              if (user == null) {
                Navigator.pushNamedAndRemoveUntil(
                    context, "login", (route) => false);
              }
            },
            title: const Text("Cerrar sesión"),
          )
        ],
      ),
    );
  }
}
