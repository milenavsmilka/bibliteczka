import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Account/ChangePassword.dart';
import 'Login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

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
  String messageCanChange = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.library),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_sharp),
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
                      style: Theme.of(context).textTheme.titleMedium,
                      cursorColor: Theme.of(context).textTheme.titleMedium?.color,
                      autocorrect: false,
                      controller: usernameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: MultiValidator([
                        UsernameMustContainValidator(
                            AppLocalizations.of(context)!.validateUsernameError,
                            usernameController.text),
                        RequiredValidator(
                            errorText: AppLocalizations.of(context)!.validateUsernameError)
                      ]).call,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.giveMeUserName,
                          errorMaxLines: 3,
                          prefixIcon: const Icon(Icons.account_circle_rounded),
                          prefixIconColor: Theme.of(context).textTheme.titleMedium?.color),
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      cursorColor: Theme.of(context).textTheme.titleMedium?.color,
                      autocorrect: false,
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.giveMeEmail,
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: Theme.of(context).textTheme.titleMedium?.color,
                      ),
                      validator: MultiValidator([
                        RequiredValidator(
                            errorText: AppLocalizations.of(context)!.giveMeEmailError),
                        EmailValidator(errorText: AppLocalizations.of(context)!.wrongEmailError),
                      ]).call,
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      cursorColor: Theme.of(context).textTheme.titleMedium?.color,
                      autocorrect: false,
                      controller: passwordController,
                      obscureText: !passVisible,
                      validator: MultiValidator([
                        PasswordMustContainValidator(
                            AppLocalizations.of(context)!.validatePasswordError,
                            passwordController.text),
                        RequiredValidator(
                            errorText: AppLocalizations.of(context)!.giveMePasswordError)
                      ]).call,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.giveMePassword,
                          errorMaxLines: 3,
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: Theme.of(context).textTheme.titleMedium?.color,
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                passVisible = !passVisible;
                              });
                            },
                            child: Icon(
                              passVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                          )),
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Row(children: [
                  Flexible(
                    child: TextFormField(
                      style: Theme.of(context).textTheme.titleMedium,
                      cursorColor: Theme.of(context).textTheme.titleMedium?.color,
                      autocorrect: false,
                      controller: repeatPasswordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: !passRepVisible,
                      validator: (repeat) {
                        if (repeat != passwordController.text) {
                          return AppLocalizations.of(context)!.passwordIsDifferentError;
                        } else if (repeat!.isEmpty) {
                          return AppLocalizations.of(context)!.giveMePasswordError;
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.giveMeRepeatPassword,
                          prefixIcon: const Icon(Icons.lock),
                          prefixIconColor: Theme.of(context).textTheme.titleMedium?.color,
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                passRepVisible = !passRepVisible;
                              });
                            },
                            child: Icon(
                              passRepVisible ? Icons.visibility : Icons.visibility_off,
                            ),
                          )),
                    ),
                  ),
                ]),
                SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                Center(
                  child: ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.clickToRegisterButton),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await signUp(usernameController.text, passwordController.text,
                            repeatPasswordController.text, emailController.text);
                      }
                    },
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
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
                    Text(AppLocalizations.of(context)!.haveAccountQuestion1,
                        style: Theme.of(context).textTheme.titleLarge),
                    Flexible(
                      child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(AppLocalizations.of(context)!.haveOrNotAccountQuestion2)),
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      );

  Future<void> signUp(String username, String password, String repeatPassword, String email) async {
    if (password != repeatPassword) {
      return;
    }
    print("Próba mikrofonu");
    const String apiUrl = apiURLRegister;
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
    Map<String, dynamic> data = jsonDecode(response.body);
    var message = data['message'];
    changeText(message);
    if (message == 'register_successful') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      print("Okej :D");
    } else {
      print('Nie okej $message');
    }
  }

  void changeText(String receivedMessageFromAPI) {
    setState(() {
      if (receivedMessageFromAPI == "register_successful") {
        messageCanChange = AppLocalizations.of(context)!.registerSuccessful;
      } else if (receivedMessageFromAPI == 'username_wrong_format') {
        messageCanChange = AppLocalizations.of(context)!.validateUsernameError;
      } else if (receivedMessageFromAPI == 'password_wrong_format') {
        messageCanChange = AppLocalizations.of(context)!.validatePasswordError;
      } else if (receivedMessageFromAPI == 'email_wrong_format') {
        messageCanChange = AppLocalizations.of(context)!.loginEmailError;
      } else if (receivedMessageFromAPI == 'user_already_exists') {
        messageCanChange = AppLocalizations.of(context)!.userAlreadyExists;
      } else {
        messageCanChange = AppLocalizations.of(context)!.sorryForError;
      }
    });
  }
}
