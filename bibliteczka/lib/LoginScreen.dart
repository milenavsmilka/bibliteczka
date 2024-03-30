import 'dart:convert';

import 'package:biblioteczka/MainPanelScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
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
  String messageCanChange = '';

  @override
  Widget build(BuildContext context) {
    return PopScope(
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
          automaticallyImplyLeading: false,
        ),
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
                          //co łapiemy?
                        }
                      },
                    ),
                  ),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [Flexible(child: Text(messageCanChange))],
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
  }

  void changeText(String receivedMessageFromAPI) {
    setState(() {
      if (receivedMessageFromAPI == "login_successful") {
        messageCanChange = "Zalogowano poprawnie";
      } else if (receivedMessageFromAPI == 'user_already_logged_in') {
        messageCanChange = 'Użytkownik już zalogowany';
      } else if (receivedMessageFromAPI == 'authentication_failed') {
        messageCanChange = "Nieudana próba logowania - brak danych w bazie";
      } else if (receivedMessageFromAPI == 'email_wrong_format') {
        messageCanChange = "Niepoprawny adres email";
      } else if (receivedMessageFromAPI == 'password_wrong_format') {
        messageCanChange =
            "Hasło musi zawierać min 10 znaków, w tym małe i duże litery, cyfry oraz znaki specjalne";
      } else {
        messageCanChange = "Przepraszamy, wystąpił błąd";
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    const String apiUrl =
        'https://192.168.1.102:5000/api/account/login'; //'https://192.168.0.2:5000/api/account/login';
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
    changeText(message);
    if (message == "login_successful") {
      print("Okej :D");
      token = data['token'];
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(MyHomePageState.TOKEN, token);
      sharedPreferences.setBool('isLogged', true);
      var isLoggedIn = sharedPreferences.getBool('isLogged');
      print("Wypiszę podczas ustawiania boola logowania $isLoggedIn");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MainPanelScreen()));
    } else if (message == 'user_already_logged_in') {
      print("Nie okej :(");
      throw Exception('Użytkownik już zalogowany');
    } else if (message == 'authentication_failed') {
      print("Nie okej :(");
      throw Exception('Failed to load data');
    } else {
      print("Nie okej :(");
    }
  }
}
