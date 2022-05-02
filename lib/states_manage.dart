// ignore_for_file: unnecessary_null_comparison

import 'historial_pokemon_seleccionado.dart';
import 'inicio.dart';

InicioState inicioState = InicioState();
HistorialPokemonState historialPokemonState = HistorialPokemonState();

void updateState(String vista) {
  switch (vista) {
    case "inicio":
      if (inicioState != null) {
        if (inicioState.mounted == true) {
          inicioState.setState(() {
            //update inicio
          });
        }
      }
      break;
    case "historial":
      if (historialPokemonState != null) {
        if (historialPokemonState.mounted == true) {
          historialPokemonState.setState(() {
            //update historial
          });
        }
      }
      break;
    default:
  }
}
