import 'package:flutter/material.dart';

final Color colorAppBar = Color.fromRGBO(242, 224, 157, 1);
final Color backgroundScreenColor = Color.fromRGBO(253, 249, 240, 1);
final Color categoryButtonCyanColor = Color.fromRGBO(150, 218, 214, 1);
final Color textMainColor = Colors.black;

ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: Colors.white60, secondary: const Color(0xffdfeaf2)),
  brightness: Brightness.light,
  scaffoldBackgroundColor: Color.fromRGBO(253, 249, 240, 1),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: categoryButtonCyanColor,
    ),
  ),
  buttonTheme: ButtonThemeData(buttonColor: colorAppBar),
  textTheme: TextTheme(
    headline4: TextStyle(
        color: textMainColor,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        fontSize: 28
    ),
    headline2: TextStyle(
        color: textMainColor,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.italic,
        fontSize: 35),
    headline1: TextStyle(
        color: Colors.black,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontSize: 50),
    headline3: TextStyle(
      color: Colors.black,
      fontFamily: 'LobsterTwo',
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
      fontSize: 36,
    ),
  ),
  appBarTheme: AppBarTheme(
    centerTitle: true,
    foregroundColor: textMainColor,
    backgroundColor: colorAppBar,

  )
);

ThemeData darkTheme = ThemeData(brightness: Brightness.dark);
