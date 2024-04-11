import 'dart:convert';

import 'package:biblioteczka/panels/CustomPageRoute.dart';
import 'package:biblioteczka/panels/AllCategoryBooksScreen.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'ChangeThemeScreen.dart';
import 'ChooseCategoryScreen.dart';
import 'LoginScreen.dart';
import 'SettingsScreen.dart';
import 'apiRequests.dart';
import 'main.dart';

class MainPanelScreen extends StatefulWidget {
  const MainPanelScreen({Key? key}) : super(key: key);

  @override
  _MainPanelScreen createState() => _MainPanelScreen();
}

class _MainPanelScreen extends State<MainPanelScreen> {
  @override
  Widget build(BuildContext context) => PopScope(
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
              title: Text(titleOnAppBar),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                PopupMenuButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 35,
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Text('Wyświetl profil'),
                      onTap: () {
                        // checkIsTokenValid(context, );
                      },
                    ),
                    PopupMenuItem(
                      child: Text(changeTheme),
                      onTap: () {
                        checkIsTokenValid(context, ChangeThemeScreen());
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Ustawienia'),
                      onTap: () {
                        checkIsTokenValid(context, SettingsScreen());
                      },
                    ),
                    PopupMenuItem(
                        child: Text(clickToLogOutButton),
                        onTap: () async {
                          checkIsTokenValid(context);
                          await logOut();//podwójnie jadą ekrany logowania
                        })
                  ],
                )
              ],
            ),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Kategoria",
                      widgetToRoute: ChooseCategoryScreen()),
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Nowości",
                      widgetToRoute: ChooseCategoryScreen()),
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Top 100",
                      widgetToRoute: ChooseCategoryScreen()),
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Autorzy",
                      widgetToRoute: ChooseCategoryScreen()),
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Społeczność",
                      widgetToRoute: ChooseCategoryScreen()),
                ],
              ),
            )),
      );

  Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    const String apiUrl = apiURLLogOut; //apiURLLogOut;
    final Map<String, dynamic> requestBody = {
      'language': 'pl'
    };
    String requestBodyJson = jsonEncode(requestBody);

    final response = await http.post(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken'
    }, body: requestBodyJson);
    Map<String, dynamic> data = jsonDecode(response.body);
    String message = data['message'];
    print('Otrzymana wiadomość po wylogowaniu: $message $actualToken');
    if (response.statusCode == 200) {
      sharedPreferences.clear();
      print("Poprawnie wylogowano użytkownika");
      Navigator.push(
          context, CustomPageRoute(child: LoginScreen()));
    } else {
      print("Pojawił się błąd, użytkownik nie został wylogowany");
    }
  }
}

class ChooseOptionFromMenuButton extends StatelessWidget {
  final String nameOfOptionFromMenu;
  final Widget widgetToRoute;

  const ChooseOptionFromMenuButton({
    Key? key,
    required this.nameOfOptionFromMenu,
    required this.widgetToRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(95),
        ),
        child: Text(
          nameOfOptionFromMenu,
        ),
        onPressed: () {
          checkIsTokenValid(context, widgetToRoute);
        },
      ),
    );
  }
}
