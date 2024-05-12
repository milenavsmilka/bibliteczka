import 'package:flutter/material.dart';

const Color colorAppDarkBar = Color.fromRGBO(0, 0, 0, 1.0);
const Color backgroundScreenDarkColor = Color.fromRGBO(64, 63, 82, 1.0);
const Color categoryButtonDarkColor = Color.fromRGBO(101, 100, 131, 1.0);
const Color textMainColor = Color.fromRGBO(211, 207, 207, 1.0);
const Color borderColor = Colors.grey;
const Color greyContainerOpinion = Colors.black12;

ThemeData darkTheme = ThemeData(
  primaryColor: colorAppDarkBar,
    secondaryHeaderColor: greyContainerOpinion,
    colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: colorAppDarkBar,
        secondary: const Color(0xffdfeaf2),
        brightness: Brightness.dark),
    scaffoldBackgroundColor: backgroundScreenDarkColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: const TextStyle(
              fontFamily: 'LobsterTwo',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 25),
          minimumSize: const Size.square(50.0),
          backgroundColor: categoryButtonDarkColor,
          foregroundColor: textMainColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      errorStyle: TextStyle(fontSize: 18.0, color: Colors.red),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: categoryButtonDarkColor, width: 2.0),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: categoryButtonDarkColor),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.normal,
              fontSize: 15),
          foregroundColor: categoryButtonDarkColor,
        )),
    buttonTheme: const ButtonThemeData(buttonColor: colorAppDarkBar),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      headlineSmall: TextStyle(
        color: textMainColor,
        fontFamily: 'Merienda',
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontSize: 18,
      ),
      // headline4: TextStyle(
      //     color: textMainColor,
      //     fontFamily: 'LobsterTwo',
      //     fontWeight: FontWeight.w800,
      //     fontStyle: FontStyle.italic,
      //     fontSize: 28),
      // headline2: TextStyle(
      //     color: textMainColor,
      //     fontFamily: 'Merienda',
      //     fontWeight: FontWeight.w800,
      //     fontStyle: FontStyle.italic,
      //     fontSize: 35),
      displayLarge: TextStyle(
          color: Colors.black,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 55),
      displaySmall: TextStyle(
        color: Colors.black,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontSize: 36,
      ),
    ),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
          color: textMainColor,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 35),
      centerTitle: true,
      foregroundColor: textMainColor,
      backgroundColor: colorAppDarkBar,
    ),
  dialogTheme: const DialogTheme(
      backgroundColor: backgroundScreenDarkColor,
      titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 20),
      contentTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      surfaceTintColor: Colors.transparent),
  iconTheme: const IconThemeData(color: textMainColor),
);
