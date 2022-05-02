import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'api.dart';
import 'auth.dart';
import 'data_manage.dart';
import 'firestore_db.dart';
import 'helpers.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  EdgeInsets marginSeparacion = const EdgeInsets.only(bottom: 5.0);
  bool workInProgress = false;
  String username = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    Color colorBorderInputs = noVoid(error) == true ? Colors.red : Colors.grey;
    OutlineInputBorder borderInputs =
        OutlineInputBorder(borderSide: BorderSide(color: colorBorderInputs));

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: marginSeparacion,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "S2Next",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: noVoid(error),
                child: Container(
                  margin: marginSeparacion,
                  child: Text(
                    // ignore: unnecessary_string_interpolations
                    "$error",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ),
              Container(
                margin: marginSeparacion,
                child: TextField(
                  onChanged: (value) {
                    username = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Username",
                      enabledBorder: borderInputs,
                      focusedBorder: borderInputs),
                ),
              ),
              Container(
                margin: marginSeparacion,
                child: TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: InputDecoration(
                      hintText: "Password",
                      enabledBorder: borderInputs,
                      focusedBorder: borderInputs),
                ),
              ),
              buttonLoader()
            ],
          ),
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
              child: TextButton(
                onPressed: () async {
                  setState(() {
                    workInProgress = true;
                    error = "";
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                  String email = await getEmailForLogin(username);
                  print(email);
                  if (noVoid(email) == true) {
                    username = email;
                  }
                  error = await login(username, md5String(password));
                  if (noVoid(user) == true) {
                    await getPokemons();
                    await getPokemonsFirestore();
                    conbinarDatos();
                    initListeners();
                    print("pokemons listed: ${listPokemons.length}");
                    setState(() {
                      workInProgress = false;
                      Navigator.popAndPushNamed(context, "inicio");
                    });
                  } else {
                    setState(() {
                      workInProgress = false;
                    });
                  }
                },
                child: const Text(
                  "Iniciar sesión",
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
