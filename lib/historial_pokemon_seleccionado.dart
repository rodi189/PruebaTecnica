// ignore_for_file: unnecessary_string_interpolations, avoid_unnecessary_containers

import 'package:flutter/material.dart';

import 'data_manage.dart';
import 'firestore_db.dart';
import 'helpers.dart';
import 'states_manage.dart';

class HistorialPokemon extends StatefulWidget {
  final String pokedex;
  const HistorialPokemon({Key? key, required this.pokedex}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<HistorialPokemon> createState() {
    historialPokemonState = HistorialPokemonState();
    return historialPokemonState;
  }
}

class HistorialPokemonState extends State<HistorialPokemon> {
  Map<String, dynamic> mapVersion = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial"),
      ),
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
    Map auxPokemonData = mapPokemonsHistorial[widget.pokedex] ?? {};
    if (noVoid(auxPokemonData) == true) {
      List versiones = auxPokemonData["versiones"] ?? [];
      for (var i = 0; i < versiones.length; i++) {
        Map auxPokemonVersion = versiones[i];
        if (noVoid(auxPokemonVersion) == true) {
          String pokedex = auxPokemonVersion["pokedex"] as String;
          String nombre = auxPokemonVersion["name"] as String;
          if (noVoid(nombre) == false) {
            nombre = "---";
          }
          int altura = auxPokemonVersion["height"] as int;
          int peso = auxPokemonVersion["weight"] as int;
          String date = auxPokemonVersion["date"] as String;
          mapVersion[date] = auxPokemonVersion;
          auxList.add(widgetPokemon(pokedex, nombre, altura, peso, date));
        }
      }
    }

    return auxList.reversed.toList();
  }

  Widget widgetPokemon(
      String pokedex, String nombre, int altura, int peso, String date) {
    int? millliseconds = int.parse(date);
    DateTime fecha;
    int dia = 0;
    int mes = 0;
    int ano = 0;
    int hora = 0;
    int minuto = 0;
    int segundo = 0;
    if (noVoid(millliseconds) == true) {
      fecha = DateTime.fromMillisecondsSinceEpoch(millliseconds);
      dia = fecha.day;
      mes = fecha.month;
      ano = fecha.year;
      hora = fecha.hour;
      minuto = fecha.minute;
      segundo = fecha.second;
    }
    return InkWell(
      onTap: () {
        //
        _showMyDialog(context, pokedex, date);
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Row(
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
                ),
                Container(
                  child: Text("Fecha: $dia/$mes/$ano $hora:$minuto:$segundo"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertDialog(String pokedex, String date) {
    return AlertDialog(
      title: const Text('Confirmar'),
      content: const Text("¿Restaurar version?"),
      actions: <Widget>[
        TextButton(
            child: const Text("Aceptar"),
            onPressed: () async {
              Map<String, dynamic> a = mapVersion[date];
              Map<String, Object> auxData = {};
              a.forEach((key, value) {
                auxData[key] = value;
              });
              String resultUpdate = await updatePokemon(pokedex, auxData);
              if (noVoid(resultUpdate) == false) {
                actualizadoPokemonSeleccionado = true;
                await rollBackHistorial(pokedex, auxData);
              }
              Navigator.of(context).pop();
            }),
        TextButton(
            child: const Text("Cancelar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Future<void> _showMyDialog(
      BuildContext context, String pokedex, String date) async {
    return showDialog<void>(
      context: context,
      builder: (_) => _buildAlertDialog(pokedex, date),
    );
  }
}
