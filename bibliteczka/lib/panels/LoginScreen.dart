import 'dart:convert';

import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPanelScreen.dart';
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
          title: const Text(titleOfApp),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.account_circle_rounded,
                  size: 120,
                  color: Colors.black,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    labelText: giveMeEmail,
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: giveMeEmailError),
                    EmailValidator(errorText: wrongEmailError),
                  ]),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  autocorrect: false,
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
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text(clickToLoginButton),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      try{
                        await signIn(
                            emailController.text, passwordController.text);
                      } on Exception catch (e){
                        showSnackBar(context, 'Błąd logowania - niepoprawny email lub hasło', Colors.redAccent);
                    }
                    };
                  },
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Flexible(child: Text(messageCanChange))],
                ),
                Row(
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signIn(String email, String password) async {
    const String apiUrl = apiURLLogin; //apiURLLogin;
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
    print(message);
    if (message == "login_successful") {
      print("Okej :D");
      token = data['token'];
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString(MyHomePageState.TOKEN, token);
      sharedPreferences.setString(
          MyHomePageState.password, passwordController.toString());
      sharedPreferences.setBool('isLogged', true);
      var isLoggedIn = sharedPreferences.getBool('isLogged');
      print("Wypiszę podczas ustawiania boola logowania $isLoggedIn");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MainPanelScreen()));
    } else if (message == 'already_logged_in') {
      print("Nie okej :(");
      throw Exception(userAlreadyLoggedIn);
    } else if (message == 'authentication_failed') {
      print("Nie okej :(");
      throw Exception('Failed to load data');
    } else {
      print("Nie okej :(");
    }
  }

  void changeText(String receivedMessageFromAPI) {
    setState(() {
      if (receivedMessageFromAPI == "login_successful") {
        messageCanChange = loginSuccessful;
      } else if (receivedMessageFromAPI == 'already_logged_in') {
        messageCanChange = userAlreadyLoggedIn;
      } else if (receivedMessageFromAPI == 'authentication_failed') {
        messageCanChange = loginNoDataError;
      } else if (receivedMessageFromAPI == 'email_wrong_format') {
        messageCanChange = loginEmailError;
      } else if (receivedMessageFromAPI == 'password_wrong_format') {
        messageCanChange = validatePasswordError;
      } else if (receivedMessageFromAPI == 'locked_user_login_attempts') {
        messageCanChange = tooMuchLoginAttemptsError;
      } else {
        messageCanChange = sorryForError;
      }
    });
  }
}
