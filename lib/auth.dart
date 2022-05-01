import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'helpers.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user;

Future<String> login(String email, String password) async {
  UserCredential credential;
  String error = "";
  if (noVoid(email) == true && noVoid(password) == true) {
    try {
      credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (noVoid(credential) == true) {
        user = credential.user;
      }
    } catch (e) {
      error = "Usuario o contraseña incorrectos";
    }
  } else {
    error = "Campos requeridos";
  }
  return error;
}

Future<void> cerrarSesion() async {
  await auth.signOut();
  if (auth.currentUser == null) {
    getUser();
  }
}

void getUser() {
  user = auth.currentUser;
}

String md5String(String value) {
  List<int> bytes = utf8.encode(value);
  Digest digest = md5.convert(bytes);
  return "$digest";
}
