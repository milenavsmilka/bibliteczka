import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/ThemeProvider.dart';
import '../Login.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/functions.dart';
import '../main.dart';
import 'ChangePassword.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final deleteCodeController = TextEditingController();
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.changeTheme,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = light;
                      });
                      await tryChangeTheme(context, light);
                    },
                    child: Text(AppLocalizations.of(context)!.changeToLightTheme)),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = special;
                      });
                      await tryChangeTheme(context, special);
                    },
                    child: Text(AppLocalizations.of(context)!.changeToSpecialTheme)),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = dark;
                      });
                      await tryChangeTheme(context, dark);
                    },
                    child: Text(AppLocalizations.of(context)!.changeToDarkTheme)),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        themeState.setAnotherTheme = daltonism;
                      });
                      await tryChangeTheme(context, daltonism);
                    },
                    child: Text(AppLocalizations.of(context)!.changeToDaltonismTheme)),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.account,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceAround,
              spacing: 20,
              direction: Axis.vertical,
              children: [
                ElevatedButton(
                    onPressed: () {
                      checkIsTokenValid(
                          context,
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                          ));
                    },
                    child: Text(AppLocalizations.of(context)!.changePassword)),
                ElevatedButton(
                    onPressed: () {
                      String deleteCode = '';
                      showDialogToDeleteAccount(context, deleteCode);
                    },
                    child: Text(AppLocalizations.of(context)!.deleteMyAccount)),
              ],
            ),
            Text(
              AppLocalizations.of(context)!.language,
              style: Theme
                  .of(context)
                  .textTheme
                  .headlineMedium,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      MyApp.of(context)?.setLocale(const Locale.fromSubtags(languageCode: 'pl'));
                    },
                    child: Text(AppLocalizations.of(context)!.polish)),
                ElevatedButton(
                    onPressed: () {
                      MyApp.of(context)?.setLocale(const Locale.fromSubtags(languageCode: 'en'));
                    },
                    child: Text(AppLocalizations.of(context)!.english)),
              ],
            )
            //AppLocalizations.of(context)!.title
          ],
        ),
      ),
    );
  }

  Future<dynamic> showDialogToDeleteAccount(BuildContext context, String deleteCode) {
    return showDialog(
        context: context,
        builder: (context) =>
            SingleChildScrollView(
              padding: EdgeInsets.only(top: MediaQuery
                  .of(context)
                  .size
                  .height / 5),
              child: AlertDialog(
                title: Text(AppLocalizations.of(context)!.areYouSureToDeleteAccount),
                content: Text(AppLocalizations.of(context)!.appSendDeleteCode),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.back)),
                  TextButton(
                      onPressed: () async {
                        deleteCode = await sendMail();
                        Navigator.of(context).pop();
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(AppLocalizations.of(context)!.appSentCode),
                                content: Text(AppLocalizations.of(context)!.writeCode),
                                actions: [
                                  TextFormField(
                                    cursorColor: Theme
                                        .of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.color,
                                    keyboardType: TextInputType.number,
                                    obscureText: true,
                                    controller: deleteCodeController,
                                  ),
                                  Wrap(children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.back)),
                                    TextButton(
                                        onPressed: () {
                                          deleteAccount(deleteCode);
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.ok))
                                  ]),
                                ],
                              );
                            });
                      },
                      child: Text(AppLocalizations.of(context)!.sendCode)),
                ],
              ),
            ));
  }

  Future<void> tryChangeTheme(BuildContext context, String theme) async {
    try {
      await changeSthInMyAccount(context, apiURLChangeTheme, Map.of({"theme": theme}));
    } on http.ClientException {
      showSnackBar(context, AppLocalizations.of(context)!.youHaveCurrentTheme, Theme
          .of(context)
          .cardColor);
    }
  }

  Future<String> sendMail() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualEmail = sharedPreferences.getString(MyHomePageState.email);

    const emailFrom = 'spozywczaksmiesznewarzywko@gmail.com';
    String emailTo = actualEmail.toString();
    String password = 'fxqf stoo kvpu hebg';
    final deleteCode = UniqueKey().hashCode;
    final smtpServer = gmail(emailFrom, password);
    final message = Message()
      ..from = const Address(emailFrom, library)
      ..recipients.add(emailTo)
      ..subject = deleteMyAccountEmailSubject
      ..text =
          '$mailSendBecauseYouWantDeleteAccount $deleteCode';
    try {
      await send(message, smtpServer);
      showSnackBar(context, mailSentCorrectly, Colors.greenAccent);
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
      var sharedPreferences = await SharedPreferences.getInstance();
      String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

      if (!mounted) return;
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(AppLocalizations.of(context)!.giveMePassword),
                actions: [
                  TextFormField(
                    cursorColor: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.color,
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
                              context,
                              CustomPageRoute(
                                  chooseAnimation: CustomPageRoute.SLIDE,
                                  child: const LoginScreen()));
                        } else {
                          print("Nie okej :(");
                          showSnackBar(context, AppLocalizations.of(context)!.passwordIsDifferentError, Theme
                              .of(context)
                              .inputDecorationTheme
                              .errorBorder!
                              .borderSide
                              .color);
                          throw Exception(failedToLoadData);
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.ok))
                ],
              ));
    } else {
      showSnackBar(context, codesDifferent, Theme
          .of(context)
          .inputDecorationTheme
          .errorBorder!
          .borderSide
          .color);
    }
  }
}
