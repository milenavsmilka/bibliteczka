import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/ThemeProvider.dart';
import '../Login.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/functions.dart';
import '../main.dart';
import 'ChangePassword.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final deleteCodeController = TextEditingController();
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    final themeState = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(settings),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Zmień motyw',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = light;
                      });
                      await tryChangeTheme(context, light);
                    },
                    child: Text(changeToLightTheme)),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = dark;
                      });
                      await tryChangeTheme(context, dark);
                    },
                    child: Text(changeToDarkTheme)),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = special;
                      });
                      await tryChangeTheme(context, special);
                    },
                    child: Text(changeToSpecialTheme)),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = daltonism;
                      });
                      await tryChangeTheme(context, daltonism);
                    },
                    child: Text(changeToDaltonismTheme)),
                Text(
                  'Konto',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                ElevatedButton(
                    onPressed: () {
                      checkIsTokenValid(
                          context,
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
                          ));
                    },
                    child: Text('Zmień hasło')),
                ElevatedButton(
                    onPressed: () {
                      String deleteCode = '';
                      showDialogToDeleteAccount(context, deleteCode);
                    },
                    child: Text('Usuń konto')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDialogToDeleteAccount(BuildContext context, String deleteCode) {
    return showDialog(
        context: context,
        builder: (context) => SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 5),
              child: AlertDialog(
                title: Text('Czy na pewno chcesz usunąć swoje konto?'),
                content: Text('Aplikacja wyśle na twój email kod weryfikacyjny, '
                    'który pozwoli na usunięcie Twoich danych.'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Cofnij')),
                  TextButton(
                      onPressed: () async {
                        deleteCode = await sendMail();
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Kod został wysłany'),
                                content: Text('Wpisz go poniżej:'),
                                actions: [
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                    controller: deleteCodeController,
                                  ),
                                  Wrap(children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('Cofnij')),
                                    TextButton(
                                        onPressed: () {
                                          deleteAccount(deleteCode);
                                        },
                                        child: Text("OK"))
                                  ]),
                                ],
                              );
                            });
                      },
                      child: Text('Wyślij')),
                ],
              ),
            ));
  }

  Future<void> tryChangeTheme(BuildContext context, String theme) async {
    try {
      await changeSthInMyAccount(context, apiURLChangeTheme, Map.of({"theme": theme}));
    } on http.ClientException {
      showSnackBar(context, 'Wybrano obecny motyw', Theme.of(context).cardColor);
    }
  }

  Future<String> sendMail() async {
    const emailFrom = 'spozywczaksmiesznewarzywko@gmail.com';
    const emailTo = 'milena.milena16@onet.pl';
    String password = 'fxqf stoo kvpu hebg';
    final deleteCode = UniqueKey().hashCode;
    final smtpServer = gmail(emailFrom, password);
    final message = Message()
      ..from = Address(emailFrom, 'Biblioteczka')
      ..recipients.add(emailTo)
      ..subject = 'Usuwanie konta'
      ..text =
          'Ten email został wysłany, ponieważ została uruchomiona akcja usuwania konta. Wpisz poniższy kod'
              ' w oknie aplikacji, który potwierdzi usunięcie Twoich danych: $deleteCode';
    try {
      await send(message, smtpServer);
      showSnackBar(context, 'Poprawnie wysłano email', Colors.greenAccent);
      return deleteCode.toString();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    return 'error';
  }

  Future<void> deleteAccount(String deleteCode) async {
    final passwordController = TextEditingController();
    if (deleteCodeController.text == deleteCode) {
      print('Kody są zgodne. Konto zostanie usunięte');

      var sharedPreferences = await SharedPreferences.getInstance();
      String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Wprowadź hasło'),
                actions: [
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                  ),
                  TextButton(
                      onPressed: () async {
                        const String apiUrl = apiURLDeleteAccount;
                        final Map<String, dynamic> requestBody = {
                          'password': passwordController.text,
                        };
                        String requestBodyJson = jsonEncode(requestBody);

                        final response = await http.delete(
                          Uri.parse(apiUrl),
                          headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                            'Authorization': 'Bearer $actualToken'
                          },
                          body: requestBodyJson,
                        );
                        if (response.statusCode == 200) {
                          print("Okej :D");
                          Map<String, dynamic> data = jsonDecode(response.body);
                          print(data);
                          checkIsTokenValid(
                              context,
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      chooseAnimation: CustomPageRoute.SLIDE,
                                      child: LoginScreen())));
                        } else {
                          print("Nie okej :(");
                          throw Exception('Failed to load data');
                        }
                      },
                      child: Text("OK"))
                ],
              ));
    } else {
      print('Kody nie są zgodne. Konto nie zostanie usunięte');
    }
  }
}
