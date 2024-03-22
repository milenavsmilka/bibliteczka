import 'dart:convert';

import 'package:biblioteczka/LoginScreen.dart';
import 'package:biblioteczka/main.dart';
import 'package:biblioteczka/styles/DarkTheme.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'TestScreen.dart';

class SignUpNav extends StatelessWidget {
  const SignUpNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: MainPanelScreen(),
    );
  }
}

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
            title: const Text('Exit'),
            content: const Text('Czy chcesz wyjść z aplikacji'),
            actions: [
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Tak')),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Nie'),
              ),
            ],
          );
        },
      );
      return Future.value(shouldPop);
    },
    child: Scaffold(
        appBar: AppBar(
          title: Text('Biblioteczka'),
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
                  child: Text("Iton 1"),
                ),
                PopupMenuItem(child: Text("Iton 2")),
                PopupMenuItem(
                  child: Text("Wyloguj"),
                  onTap: logOut
                )
              ],
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ChooseCategoryButton(nameOfCategory: "Kategoria"),
              ChooseCategoryButton(nameOfCategory: "Zapowiedzi"),
              ChooseCategoryButton(nameOfCategory: "Top 100"),
              ChooseCategoryButton(nameOfCategory: "Autorzy"),
              ChooseCategoryButton(nameOfCategory: "Społeczność"),
            ],
          ),
        )),
  );

 Future<void> logOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    const String apiUrl = 'https://192.168.0.2:5000/api/account/logout';

    final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $actualToken'
        }
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    String message = data['message'];
    print('Otrzymana wiadomość po wylogowaniu: $message $actualToken');
    if (response.statusCode == 200) {
      sharedPreferences.clear();
      print("Poprawnie wylogowano użytkownika");
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      print("Pojawił się błąd, użytkownik nie został wylogowany");
    }
 }
}

class ChooseCategoryButton extends StatelessWidget {
  final String nameOfCategory;

  const ChooseCategoryButton({
    Key? key,
    required this.nameOfCategory,
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
          nameOfCategory,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TestScreen()),
          );
        },
      ),
    );
  }
}
