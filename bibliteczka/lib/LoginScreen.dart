import 'dart:convert';

import 'package:biblioteczka/MainPanelScreen.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'RegisterScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool passVisible = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Biblioteczka'),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_sharp),
          ),
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
                        child: Icon(Icons.account_circle_rounded, size: 120,color: Colors.black,),
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
                              errorText: "Podano niepoprawny adres email"),
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
                        int loginResult = await signIn(
                            emailController.text, passwordController.text);
                        if (loginResult == 0) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPanelScreen()),
                          );
                        }
                      },
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
      );

  Future<int> signIn(String email, String password) async {
    print("Próba mikrofonu");
    const String apiUrl = 'https://192.168.0.2:5000/api/account/login';
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
    if (response.statusCode == 200) {
      print("Okej :D");
      return 0;
    } else {
      print("Nie okej :(");
      throw Exception('Failed to load data');
    }
  }
}
