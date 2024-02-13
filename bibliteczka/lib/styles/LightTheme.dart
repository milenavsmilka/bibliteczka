import 'package:flutter/material.dart';

final Color colorAppBar = Color.fromRGBO(242, 224, 157, 1);
final Color backgroundScreenColor = Color.fromRGBO(253, 249, 240, 1);
final Color categoryButtonCyanColor = Color.fromRGBO(150, 218, 214, 1);
final Color textMainColor = Colors.black;
final Color borderColor = Colors.grey;

ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch()
        .copyWith(primary: Colors.white60, secondary: const Color(0xffdfeaf2)),
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color.fromRGBO(253, 249, 240, 1),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
              fontFamily: 'LobsterTwo',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              fontSize: 25),
          minimumSize: Size.square(50.0),
          backgroundColor: categoryButtonCyanColor,
          foregroundColor: textMainColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      errorStyle: TextStyle(fontSize: 18.0, color: Colors.red),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: categoryButtonCyanColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: categoryButtonCyanColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      textStyle: TextStyle(
          fontFamily: 'Lato',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      foregroundColor: categoryButtonCyanColor,
    )),
    buttonTheme: ButtonThemeData(buttonColor: colorAppBar),
    textTheme: TextTheme(
      headline6: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      headline5: TextStyle(
        color: textMainColor,
        fontFamily: 'Merienda',
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontSize: 18,
      ),
      headline4: TextStyle(
          color: textMainColor,
          fontFamily: 'Merienda',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 28),
      // headline2: TextStyle(
      //     color: textMainColor,
      //     fontFamily: 'Merienda',
      //     fontWeight: FontWeight.w800,
      //     fontStyle: FontStyle.italic,
      //     fontSize: 35),
      headline1: TextStyle(
          color: Colors.black,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 55),
      headline3: TextStyle(
        color: Colors.black,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontSize: 36,
      ),
    ),
    appBarTheme: AppBarTheme(
      titleTextStyle: TextStyle(
          color: textMainColor,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 35),
      centerTitle: true,
      foregroundColor: textMainColor,
      backgroundColor: colorAppBar,
    ));
