import 'package:flutter/material.dart';

final Color colorAppDarkBar = Color.fromRGBO(34, 0, 107, 1.0);
final Color backgroundScreenDarkColor = Color.fromRGBO(216, 235, 240, 1.0);
final Color categoryButtonDarkColor = Color.fromRGBO(8, 69, 129, 1.0);
final Color textMainColor = Colors.black;
final Color borderColor = Colors.grey;

ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(primary: Colors.white60, secondary: const Color(0xffdfeaf2), brightness: Brightness.dark),

    scaffoldBackgroundColor: backgroundScreenDarkColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
              fontFamily: 'LobsterTwo',
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.italic,
              fontSize: 28),
          minimumSize: Size.square(50.0),
          backgroundColor: categoryButtonDarkColor,
          foregroundColor: textMainColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 15),
          foregroundColor: categoryButtonDarkColor,
        )),
    buttonTheme: ButtonThemeData(buttonColor: colorAppDarkBar),
    textTheme: TextTheme(
      headline6: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      headline5: TextStyle(
        color: Colors.black,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 18,
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
      backgroundColor: colorAppDarkBar,
    ));
