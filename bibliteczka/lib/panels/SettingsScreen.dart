import 'dart:convert';

import 'package:biblioteczka/styles/ThemeProvider.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Tools/CustomPageRoute.dart';
import 'LoginScreen.dart';
import 'main.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final deleteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //TODO zmiana hasła
                    });
                  },
                  child: Text('Zmień hasło')),
              ElevatedButton(
                  onPressed: () {
                    String deleteCode = '';
                    showDialog(
                        context: context,
                        builder: (context) => SingleChildScrollView(
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height / 5),
                              child: AlertDialog(
                                title: Text(
                                    'Czy na pewno chcesz usunąć swoje konto?'),
                                content: Text(
                                    'Aplikacja wyśle na twój email kod weryfikacyjny, '
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
                                                title:
                                                    Text('Kod został wysłany'),
                                                content:
                                                    Text('Wpisz go poniżej:'),
                                                actions: [
                                                  TextFormField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    obscureText: true,
                                                    controller:
                                                        deleteCodeController,
                                                  ),
                                                  Wrap(children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('Cofnij')),
                                                    TextButton(
                                                        onPressed: () {
                                                          deleteAccount(
                                                              deleteCode);
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
                  },
                  child: Text('Usuń konto')),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> sendMail() async {
    final emailFrom = 'spozywczaksmiesznewarzywko@gmail.com';
    final emailTo = 'milena.milena16@onet.pl';
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
      showSnackBar('Poprawnie wysłano email');
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
                          Navigator.push(
                              context, CustomPageRoute(child: LoginScreen()));
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

  void showSnackBar(String text) {
    final snackBar = SnackBar(
      content: Text(
        text,
        style: TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.greenAccent,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
