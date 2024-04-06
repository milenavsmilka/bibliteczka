import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final emailController = TextEditingController();
  bool passVisible = false;
  bool passRepVisible = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(titleOnAppBar),
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
                bottom: MediaQuery.of(context).size.height * 0.02,
                top: MediaQuery.of(context).size.height * 0.1,
                start: MediaQuery.of(context).size.width * 0.1,
                end: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      controller: usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: RequiredValidator(
                          errorText: giveMeUserNameError),
                      decoration: InputDecoration(
                          labelText: giveMeUserName,
                          prefixIcon: Icon(Icons.account_circle_rounded)),
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: giveMeEmail,
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: MultiValidator([
                        RequiredValidator(errorText: giveMeEmailError),
                        EmailValidator(
                            errorText: wrongEmailError),
                      ]),
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: !passVisible,
                      validator: validatePassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: giveMePassword,
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
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      controller: repeatPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !passRepVisible,
                      validator: (repeat) => repeat != passwordController.text
                          ? passwordIsDifferentError
                          : null, //repeatPassValidator,
                      decoration: InputDecoration(
                          labelText: giveMeRepeatPassword,
                          prefixIcon: Icon(Icons.lock),
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                passRepVisible = !passRepVisible;
                              });
                            },
                            child: Icon(
                              passRepVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          )),
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Center(
                  child: ElevatedButton(
                    child: Text(clickToRegisterButton),
                    onPressed: () async {
                      _formKey.currentState!.validate();
                      int loginResult = await signUp(
                          usernameController.text,
                          passwordController.text,
                          repeatPasswordController.text,
                          emailController.text);
                      if (loginResult == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Center(
                    child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(haveAccountQuestion1,
                        style: Theme.of(context).textTheme.headline6),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        child: Text(haveOrNotAccountQuestion2))
                  ],
                ))
              ],
            ),
          ),
        ),
      );

  Future<int> signUp(String username, String password, String repeatPassword,
      String email) async {
    if (password != repeatPassword) {
      return 1;
    }
    print("Próba mikrofonu");
    const String apiUrl = apiURLRegisterWybrany;
    final Map<String, dynamic> requestBody = {
      'username': username,
      'password': password,
      'email': email
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
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      return 0;
    } else {
      print("Nie okej :(");
      throw Exception('Failed to load data');
    }
  }
}

String? validatePassword(String? password) {
  RegExp passReg = RegExp(
  r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&_-])[A-Za-z\d@$!%*?&_-]{10,50}$');
  final isPassReg = passReg.hasMatch(password ?? '');
  if (!isPassReg) {
    return validatePasswordError;
  }
  return null;
}
