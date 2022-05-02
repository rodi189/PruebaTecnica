// ignore_for_file: unnecessary_string_interpolations, avoid_print, prefer_is_empty

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pokemon_object_historial.dart';

import 'api.dart';
import 'data_manage.dart';
import 'pokemon_object.dart';
import 'helpers.dart';
import 'states_manage.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
String urlFirebase =
    "https://us-central1-pruebastecnicas-d953b.cloudfunctions.net";
CollectionReference referencePokemons =
    firestore.collection("pokemons").withConverter<Pokemon>(
        fromFirestore: (snapshot, _) {
          Map<String, dynamic>? auxData = snapshot.data();
          auxData!["pokedex"] = snapshot.id;
          return Pokemon.fromJson(auxData);
        },
        toFirestore: (movi, _) => movi.toJson());

CollectionReference referencePokemonsHistorial =
    firestore.collection("pokemons_historial").withConverter<PokemonHistorial>(
        fromFirestore: (snapshot, _) {
          Map<String, dynamic>? auxData = snapshot.data();
          auxData!["pokedex"] = snapshot.id;
          return PokemonHistorial.fromJson(auxData);
        },
        toFirestore: (movi, _) => movi.toJson());

StreamSubscription? listenerPokemones;
StreamSubscription? listenerPokemonesHistorial;

List listPokemonsFirestore = [];
Map mapPokemonsFirestore = {};
bool actualizadoPokemonSeleccionado = false;

Future<void> getPokemonsFirestore() async {
  listPokemonsFirestore = [];
  mapPokemonsFirestore = {};

  await referencePokemons.get().then((value) {
    if (noVoid(value)) {
      List auxPokemons = value.docs;

      if (noVoid(auxPokemons) == true) {
        for (var i = 0; i < auxPokemons.length; i++) {
          QueryDocumentSnapshot<Pokemon> auxPokemon = auxPokemons[i];
          if (noVoid(auxPokemon) == true) {
            Map auxDataPokemon = auxPokemon.data().toJson();
            String pokedex = auxDataPokemon["pokedex"];
            listPokemonsFirestore.add(auxDataPokemon);
            mapPokemonsFirestore[pokedex] = auxDataPokemon;
          }
        }
      }
    }
  }).onError((error, stackTrace) {
    print("Error get pokemons from firestore: $error");
  });
}

Future<void> getPokemonsHistorial() async {
  listPokemonsHistorial = [];
  mapPokemonsHistorial = {};

  await referencePokemonsHistorial.get().then((value) {
    if (noVoid(value)) {
      List auxPokemons = value.docs;

      if (noVoid(auxPokemons) == true) {
        for (var i = 0; i < auxPokemons.length; i++) {
          QueryDocumentSnapshot<PokemonHistorial> auxPokemon = auxPokemons[i];
          if (noVoid(auxPokemon) == true) {
            Map auxDataPokemon = auxPokemon.data().toJson();
            String pokedex = auxDataPokemon["pokedex"];
            listPokemonsHistorial.add(auxDataPokemon);
            mapPokemonsHistorial[pokedex] = auxDataPokemon;
          }
        }
      }
    }
  }).onError((error, stackTrace) {
    print("Error get historial pokemons from firestore: $error");
  });
}

Future<String> updatePokemon(
    String pokedex, Map<String, Object> pokemonData) async {
  String errorUpdate = "fail";
  await referencePokemons.doc(pokedex).update(pokemonData).then((value) {
    errorUpdate = "";
  }).onError((error, stackTrace) {
    errorUpdate = "error";
    print("Error actualizando pokemon: $error");
  });

  return errorUpdate;
}

Future<String> createPokemon(Object pokemonData) async {
  String result = "fail";
  try {
    await referencePokemons
        .doc("${listPokemonsFirestore.length + 1}")
        .set(pokemonData)
        .then((value) {
      result = "";
    }).onError((error, stackTrace) {
      print("Error creando pokemon: $error");
    }).catchError((error) {
      print("Error creando pokemon: $error");
    });
  } catch (error) {
    print("Error creando pokemon: $error");
  }

  return result;
}

Future<String> deletePokemon(String pokedex) async {
  String result = "fail";

  try {
    await referencePokemons.doc("$pokedex").delete().then((value) {
      result = "";
    }).onError((error, stackTrace) {
      print("Error elimnando pokemon: $error");
    }).catchError((error) {
      print("Error eliminando pokemon: $error");
    });
  } catch (error) {
    print("Error eliminando pokemon: $error");
  }

  return result;
}

Future<String> saveLastDataPokemon(
    String pokedex, Map<String, dynamic> pokemonData) async {
  String result = "fail";

  Map<String, dynamic> dataToUpdate = {};
  dataToUpdate['versiones'] = FieldValue.arrayUnion([pokemonData]);

  try {
    await firestore
        .collection("pokemons_historial")
        .doc("$pokedex")
        .set(dataToUpdate, SetOptions(merge: true))
        .then((value) {
      result = "";
    }).onError((error, stackTrace) {
      print("Error guardando historial pokemon: $error");
    }).catchError((error) {
      print("Error guardando historial pokemon: $error");
    });
  } catch (error) {
    print("Error guardando historial pokemon: $error");
  }

  return result;
}

Future<String> rollBackHistorial(
    String pokedex, Map<String, dynamic> pokemonData) async {
  String result = "fail";

  List newList = [];
  List auxListRollback = [];

  String date = pokemonData["date"] ?? "0";

  await firestore
      .collection("pokemons_historial")
      .doc("$pokedex")
      .get()
      .then((value) {
    if (noVoid(value) == true) {
      Map<String, dynamic>? auxMapRoolback = value.data() ?? {};
      if (noVoid(auxMapRoolback) == true) {
        auxListRollback = auxMapRoolback["versiones"] ?? [];
      }
    }
  }).onError((error, stackTrace) {
    print("Error rollback historial pokemon: $error");
  }).catchError((error) {
    print("Error rollback historial pokemon: $error");
  });

  for (var i = 0; i < auxListRollback.length; i++) {
    Map auxVersionRollback = auxListRollback[i];
    if (noVoid(auxVersionRollback) == true) {
      String auxDateRollback = auxVersionRollback["date"];
      int? millis = int.tryParse(auxDateRollback) ?? 0;
      int? millisRestored = int.tryParse(date) ?? 0;
      if (noVoid(millis) == true && noVoid(millisRestored)) {
        if (millisRestored != 0) {
          if (millis < millisRestored) {
            newList.add(auxVersionRollback);
          }
        }
      }
    }
  }

  Map<String, dynamic> dataToUpdate = {};
  dataToUpdate['versiones'] = newList;

  try {
    await firestore
        .collection("pokemons_historial")
        .doc("$pokedex")
        .set(dataToUpdate, SetOptions(merge: true))
        .then((value) {
      result = "";
    }).onError((error, stackTrace) {
      print("Error guardando historial pokemon: $error");
    }).catchError((error) {
      print("Error guardando historial pokemon: $error");
    });
  } catch (error) {
    print("Error guardando historial pokemon: $error");
  }

  return result;
}

Future<void> resetDataFirestore() async {
  await getPokemons();
  for (var i = 0; i < listPokemonsAPI.length; i++) {
    Map auxDataPokemonAPI = listPokemonsAPI[i];
    String pokedex = auxDataPokemonAPI["pokedex"];
    Pokemon auxPokemon = Pokemon.fromJson(auxDataPokemonAPI);
    await referencePokemons.doc("$pokedex").set(auxPokemon).then((value) {
      print("Reset $pokedex OK");
    }).onError((error, stackTrace) {
      print("Error reset pokemon: $error");
    });
  }
}

void initListeners() {
  listenerPokemones = referencePokemons.snapshots().listen((event) async {
    await getPokemonsFirestore();
    updateState("inicio");
  });

  listenerPokemonesHistorial =
      referencePokemonsHistorial.snapshots().listen((event) async {
    await getPokemonsHistorial();
    updateState("historial");
  });
}

void cancelListeners() {
  if (listenerPokemones != null) {
    listenerPokemones!.cancel();
  }

  if (listenerPokemonesHistorial != null) {
    listenerPokemonesHistorial!.cancel();
  }
}

Future<String> getEmailForLogin(String username) async {
  String auxEmail = "";
  Dio dio = Dio();

  Map dataToSearch = {"username": username};

  await dio
      .post("$urlFirebase/getEmailForLogin", data: dataToSearch)
      .then((value) {
    if (noVoid(value)) {
      if (value.statusCode == 200) {
        Map auxData = value.data;
        String emailUsuario = auxData["correo"] ?? "";
        if (noVoid(emailUsuario) == true) {
          auxEmail = emailUsuario;
        }
      }
    }
  });

  return auxEmail;
}
