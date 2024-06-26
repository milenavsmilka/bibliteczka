import 'dart:io';

import 'package:biblioteczka/l10n/l10n.dart';
import 'package:biblioteczka/styles/ThemeManager.dart';
import 'package:biblioteczka/styles/ThemeProvider.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'Tools/functions.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = ThemeProvider();
  Locale _locale = const Locale('pl');

  void getCurrentTheme() async {
    themeChangeProvider.setAnotherTheme =
        await themeChangeProvider.themePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  void setLocale(Locale value) {
    setState(() {
      _locale = value;
    });
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
            supportedLocales: L10n.all,
            locale: _locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            title: library,
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
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static const String TOKEN = "login";
  static const String password = "password";
  static const String email = "email";
  static const bool isLogged = false;

  @override
  void initState() {
    super.initState();
    whereToGo(context);
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
              Text(AppLocalizations.of(context)!.library, style: Theme.of(context).textTheme.displayLarge),
              const Spacer(
                flex: 4,
              ),
            ],
          )),
    );
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
