import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:biblioteczka/styles/ThemeManager.dart';
import 'package:biblioteczka/styles/ThemeProvider.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomPageRoute.dart';
import 'LoginScreen.dart';
import 'MainPanelScreen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();

  void getCurrentTheme() async {
    themeChangeProvider.setAnotherTheme =
        await themeChangeProvider.themePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) {
          return themeChangeProvider;
        })
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme:
                ThemeManager.themeData(themeProvider.getCurrentTheme, context),
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String TOKEN = "login";
  static const String password = "password";
  static const bool isLogged = false;

  @override
  void initState() {
    super.initState();
    whereToGo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text(titleOnAppBar, style: Theme.of(context).textTheme.headline1),
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

    Timer(Duration(seconds: 2), () async {
      final params = {'language': "pl"};
      if (actualToken != null) {
        //pobranie ważności tokena
        final apiUrl = Uri.parse(apiURLIsTokenValidWybrany).replace(queryParameters: params); //apiURLIsTokenValid;
        final response = await http.get(
            apiUrl,
            headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $actualToken',
        });
        Map<String, dynamic> data = jsonDecode(response.body);
        String tokenValid = data['message'];
        // String details = data['details'];
        print('Czy token valid? $tokenValid');
        // print('details $details');
        if (tokenValid == tokenIsValid) {
          //jeżeli token jest ważny
          Navigator.push(context, CustomPageRoute(child: MainPanelScreen()));
        } else {
          Navigator.push(context, CustomPageRoute(child: LoginScreen()));
        }
      } else {
        Navigator.push(context, CustomPageRoute(child: LoginScreen()));
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
