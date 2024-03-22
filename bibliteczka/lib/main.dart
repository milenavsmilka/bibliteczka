import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:biblioteczka/LoginScreen.dart';
import 'package:biblioteczka/styles/DarkTheme.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomPageRoute.dart';
import 'MainPanelScreen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const MyHomePage(title: 'HejApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String TOKEN = "login";
  static const bool isLogged = false;

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //  title: Text(widget.title),
      // ),
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/tlo_start_page2.png"),
                  fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              const Spacer(
                flex: 3,
              ),
              Text("Biblioteczka",
                  style: Theme.of(context).textTheme.headline1),
              const Spacer(
                flex: 4,
              ),
            ],
          )),
    );
  }

 void whereToGo() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(TOKEN);
    // String? isLoggedIn = sharedPreferences.getString(isLogged);
    var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

    print("Wypiszę $isLoggedIn $actualToken");

    Timer(Duration(seconds: 2),() async {
      if (actualToken != null) {
        //pobranie ważności tokena
        const String apiUrl = 'https://192.168.0.2:5000/api/account/check_if_logged_in';
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $actualToken'
          }
        );
        Map<String, dynamic> data = jsonDecode(response.body);
        String tokenValid = data['msg'];
        print('Czy token valid? $tokenValid');
        if (tokenValid == 'Token valid') { //jeżeli token jest ważny
          Navigator.push(context,
              CustomPageRoute(child: MainPanelScreen()));
        } else {
          Navigator.push(
              context, CustomPageRoute(child: LoginScreen()));
        }
      } else {
        Navigator.push(
            context, CustomPageRoute(child: LoginScreen()));
      }
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
