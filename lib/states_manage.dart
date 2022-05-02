// ignore_for_file: unnecessary_null_comparison

import 'inicio.dart';

InicioState inicioState = InicioState();

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
    default:
  }
}
