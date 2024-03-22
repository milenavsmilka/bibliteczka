import 'dart:convert';

import 'package:biblioteczka/MainPanelScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'RegisterScreen.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String token = '';
  bool passVisible = false;
  String messageCanChange = 'who cares bejbe?';

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Exit'),
                content: const Text('Czy chcesz wyjść z aplikacji'),
                actions: [
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text('Tak')),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('Nie'),
                  ),
                ],
              );
            },
          );
          return Future.value(shouldPop);
        },
        child: Scaffold(
          appBar: AppBar(
              title: const Text('Biblioteczka'),
              automaticallyImplyLeading: false),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                  bottom: MediaQuery.of(context).size.height * 0.1,
                  top: MediaQuery.of(context).size.height * 0.1,
                  start: MediaQuery.of(context).size.width * 0.1,
                  end: MediaQuery.of(context).size.width * 0.1),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.5,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Center(
                      child: Icon(
                        Icons.account_circle_rounded,
                        size: 120,
                        color: Colors.black,
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          labelText: "Wpisz email",
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: MultiValidator([
                          RequiredValidator(errorText: "Podaj adres email"),
                          EmailValidator(
                              errorText: 'Podano niepoprawny adres email'),
                        ]),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !passVisible,
                        validator: validatePassword,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                            labelText: "Podaj hasło",
                            errorMaxLines: 3,
                            prefixIcon: Icon(Icons.lock),
                            suffix: InkWell(
                              onTap: () {
                                setState(() {
                                  passVisible = !passVisible;
                                });
                              },
                              child: Icon(
                                passVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Center(
                      child: ElevatedButton(
                        child: Text("Zaloguj"),
                        onPressed: () async {
                          _formKey.currentState!.validate();
                          try {
                            await signIn(
                                emailController.text, passwordController.text);
                          } catch (_) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Błąd"),
                                    content: Text(messageCanChange),
                                    actions: [
                                      TextButton(
                                        child: Text("Ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
                          }
                        },
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Text(messageCanChange)],
                      ),
                    ),
                    Center(
                        child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Lub zarejestruj się ",
                            style: Theme.of(context).textTheme.headline6),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegisterScreen()),
                              );
                            },
                            child: Text("tutaj"))
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> signIn(String email, String password) async {
    print("Próba mikrofonu");
    const String apiUrl =
        'https://192.168.0.2:5000/api/account/login'; //https://192.168.1.102:5000/api/account/login
    final Map<String, dynamic> requestBody = {
      'email': email,
      'password': password,
    };
    String requestBodyJson = jsonEncode(requestBody);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBodyJson,
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    var message = data['message'];
    if (message == "login_successful") {
      print("Okej :D");
      token = data['token'];
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(MyHomePageState.TOKEN, token);
      sharedPreferences.setBool('isLogged', true);
      var isLoggedIn = sharedPreferences.getBool('isLogged');
      print("Wypiszę podczas ustawiania boola logowania $isLoggedIn");
      Get.to(() => MainPanelScreen());
    } else if (message == 'user_already_logged_in') {
      print("Nie okej :(");
      messageCanChange = 'Użytkownik już zalogowany';
      throw Exception('Użytkownik już zalogowany');
    } else if (message == 'authentication_failed') {
      print("Nie okej :(");
      messageCanChange = 'Nieudana próba logowania - brak danych w bazie';
      throw Exception('Failed to load data');
    } else {
      print("Nie okej :(");
    }
  }
}
