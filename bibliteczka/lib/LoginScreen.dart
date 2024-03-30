import 'dart:convert';

import 'package:biblioteczka/MainPanelScreen.dart';
import 'package:biblioteczka/styles/strings.dart';
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
              title: const Text(exitFromAppTitle),
              content: const Text(exitFromAppQuestion),
              actions: [
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: const Text(yes)),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text(no),
                ),
              ],
            );
          },
        );
        return Future.value(shouldPop);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(titleOnAppBar),
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
                  const SizedBox(height: 2),
                  Center(
                    child: ElevatedButton(
                      child: Text(clickToLoginButton),
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
                      Text(notHaveAccountYetQuestion1,
                          style: Theme.of(context).textTheme.headline6),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterScreen()),
                            );
                          },
                          child: Text(haveOrNotAccountQuestion2))
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
        messageCanChange = loginSuccessful;
      } else if (receivedMessageFromAPI == 'user_already_logged_in') {
        messageCanChange = userAlreadyLoggedIn;
      } else if (receivedMessageFromAPI == 'authentication_failed') {
        messageCanChange = loginNoDataError;
      } else if (receivedMessageFromAPI == 'email_wrong_format') {
        messageCanChange = loginEmailError;
      } else if (receivedMessageFromAPI == 'password_wrong_format') {
        messageCanChange = validatePasswordError;
      } else {
        messageCanChange = sorryForError;
      }
    });
  }

  Future<void> signIn(String email, String password) async {
    const String apiUrl = apiURLLoginWybrany; //apiURLLogin;
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
      throw Exception(userAlreadyLoggedIn);
    } else if (message == 'authentication_failed') {
      print("Nie okej :(");
      throw Exception('Failed to load data');
    } else {
      print("Nie okej :(");
    }
  }
}
