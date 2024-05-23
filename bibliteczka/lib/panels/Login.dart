import 'dart:convert';

import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Account/ChangePassword.dart';
import 'MainPanel.dart';
import 'Register.dart';
import 'main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
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
          title: const Text(library),
          automaticallyImplyLeading: false,
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
                bottom: MediaQuery.of(context).size.height * 0.1,
                top: MediaQuery.of(context).size.height * 0.1,
                start: MediaQuery.of(context).size.width * 0.1,
                end: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(
                  Icons.account_circle_rounded,
                  size: 120,
                  color: Colors.black,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  cursorColor: Theme.of(context).textTheme.titleLarge?.color,
                  controller: emailController,
                  autocorrect: false,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: giveMeEmail,
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: giveMeEmailError),
                    EmailValidator(errorText: wrongEmailError),
                  ]).call,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  cursorColor: Theme.of(context).textTheme.titleLarge?.color,
                  controller: passwordController,
                  autocorrect: false,
                  obscureText: !passVisible,
                  validator: PasswordMustContainValidator(validatePasswordError, passwordController.text).call,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                      labelText: giveMePassword,
                      errorMaxLines: 3,
                      prefixIcon: const Icon(Icons.lock),
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
                const SizedBox(height: 30),
                ElevatedButton(
                  child: const Text(clickToLoginButton),
                  onPressed: () async {
                    if(formKey.currentState!.validate()){
                      try{
                        await signIn(
                            emailController.text, passwordController.text);
                      } on Exception {
                        showSnackBar(context, 'Błąd logowania - niepoprawny email lub hasło', Theme.of(context).inputDecorationTheme.errorBorder!.borderSide.color);
                    }
                    }
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Flexible(child: Text(messageCanChange))],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(notHaveAccountYetQuestion1,
                        style: Theme.of(context).textTheme.titleLarge),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: const Text(haveOrNotAccountQuestion2))
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
    const String apiUrl = apiURLLogin;
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
      sharedPreferences.setString(MyHomePageState.email, email);
      sharedPreferences.setString(
          MyHomePageState.password, passwordController.toString());
      sharedPreferences.setBool('isLogged', true);
      var isLoggedIn = sharedPreferences.getBool('isLogged');
      print("Wypiszę podczas ustawiania boola logowania $isLoggedIn");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MainPanelScreen()));
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
