import 'dart:convert';

import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/panels/Tools/CustomPageRoute.dart';
import 'package:biblioteczka/panels/News/NewBooksScreen.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CategoryBooks/ChooseCategoryScreen.dart';
import 'Account/ChangeThemeScreen.dart';
import 'LoginScreen.dart';
import 'Account/SettingsScreen.dart';
import 'Tools/functions.dart';
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
            appBar: DefaultAppBar(title: titleOfApp,automaticallyImplyLeading: false),
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Kategoria",
                      widgetToRoute: ChooseCategoryScreen()),
                  ChooseOptionFromMenuButton(
                      nameOfOptionFromMenu: "Nowości",
                      widgetToRoute: NewBooksScreen()),
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
