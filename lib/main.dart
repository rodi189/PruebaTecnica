import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'api.dart';
import 'auth.dart';
import 'data_manage.dart';
import 'firestore_db.dart';
import 'routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  getUser();
  if (user != null) {
    await getPokemons();
    await getPokemonsFirestore();
    await getPokemonsHistorial();
    conbinarDatos();
    initListeners();
    print("pokemons listed: ${listPokemons.length}");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prueba S2Next',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: user != null ? "inicio" : "login",
      onGenerateRoute: getRoutes,
    );
  }
}
