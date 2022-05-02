import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'data_manage.dart';

import 'firestore_db.dart';
import 'helpers.dart';

class PokemonSeleccionado extends StatefulWidget {
  final String pokedex;
  const PokemonSeleccionado({Key? key, required this.pokedex})
      : super(key: key);

  @override
  State<PokemonSeleccionado> createState() => _PokemonSeleccionadoState();
}

class _PokemonSeleccionadoState extends State<PokemonSeleccionado> {
  bool workInProgress = false;
  Map<String, dynamic> currentData = {};
  String error = "";
  String nombre = "";
  TextEditingController controllerNombre = TextEditingController();
  int altura = 0;
  TextEditingController controllerAltura = TextEditingController();
  int peso = 0;
  TextEditingController controllerPeso = TextEditingController();

  @override
  void initState() {
    currentData = mapPokemons[widget.pokedex] ?? {};
    nombre = currentData["name"] ?? "";
    controllerNombre.text = nombre;
    altura = currentData["height"] ?? 0;
    controllerAltura.text = "$altura";
    peso = currentData["weight"] ?? 0;
    controllerPeso.text = "$peso";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: ListView(
          children: [
            Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                child: const Text("Nombre:")),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: TextField(
                controller: controllerNombre,
                onChanged: (value) {
                  nombre = value;
                },
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                child: const Text("Altura:")),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: TextField(
                controller: controllerAltura,
                onChanged: (value) {
                  altura = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                child: const Text("Peso:")),
            Container(
              margin: const EdgeInsets.only(bottom: 5.0),
              child: TextField(
                controller: controllerPeso,
                onChanged: (value) {
                  peso = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.phone,
              ),
            ),
            buttonLoader()
          ],
        ),
      ),
    );
  }

  Widget buttonLoader() {
    if (workInProgress == true) {
      return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: const TextButton(
          onPressed: null,
          child: SpinKitWave(
            color: Colors.blue,
            type: SpinKitWaveType.end,
            size: 40,
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 2.0),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      workInProgress = true;
                      error = "";
                      FocusScope.of(context).requestFocus(FocusNode());
                    });
                    Map<String, Object> dataToUpdate = {
                      "name": nombre,
                      "height": altura,
                      "weight": peso
                    };
                    error = await deletePokemon(widget.pokedex);
                    if (noVoid(error) == false) {
                      setState(() {
                        workInProgress = false;
                        Navigator.pop(context);
                      });
                    } else {
                      setState(() {
                        workInProgress = false;
                      });
                    }
                  },
                  child: const Text(
                    "Eliminar",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.only(top: 20, bottom: 20)),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    workInProgress = true;
                    error = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  Map<String, Object> dataToUpdate = {
                    "name": nombre,
                    "height": altura,
                    "weight": peso,
                    "date": "${DateTime.now().millisecondsSinceEpoch}"
                  };
                  await saveLastDataPokemon(
                      widget.pokedex, mapPokemons[widget.pokedex] ?? {});
                  error = await updatePokemon(widget.pokedex, dataToUpdate);
                  if (noVoid(error) == false) {
                    setState(() {
                      workInProgress = false;
                      //alert
                    });
                  } else {
                    setState(() {
                      workInProgress = false;
                    });
                  }
                },
                child: const Text(
                  "Actualizar",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.only(top: 20, bottom: 20)),
              ),
            ),
          ],
        ),
      );
    }
  }
}
