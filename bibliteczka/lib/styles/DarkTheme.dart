import 'package:flutter/material.dart';

const Color colorAppDarkBar = Color.fromRGBO(0, 0, 0, 1.0);
const Color backgroundScreenDarkColor = Color.fromRGBO(64, 63, 82, 1.0);
const Color categoryButtonDarkColor = Color.fromRGBO(101, 100, 131, 1.0);
const Color textMainColor = Color.fromRGBO(211, 207, 207, 1.0);
const Color borderColor = Colors.grey;
const Color greyContainerOpinion = Colors.black12;
const Color errorColor = Colors.redAccent;

ThemeData darkTheme = ThemeData(
  primaryColor: colorAppDarkBar,
  secondaryHeaderColor: greyContainerOpinion,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: colorAppDarkBar,
    secondary: const Color(0xffdfeaf2),
    brightness: Brightness.dark),
  cardColor: const Color.fromRGBO(209, 71, 28, 1.0),
  scaffoldBackgroundColor: backgroundScreenDarkColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
            fontFamily: 'LobsterTwo',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            fontSize: 25),
        minimumSize: const Size.square(50.0),
        backgroundColor: categoryButtonDarkColor,
        foregroundColor: textMainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(
        color: borderColor,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 18),
    labelStyle: TextStyle(
        color: borderColor,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 18),
    errorStyle: TextStyle(fontSize: 14.0, color: errorColor),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor, width: 1.0)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor, width: 1.5)),
    focusedBorder:
    OutlineInputBorder(borderSide: BorderSide(color: categoryButtonDarkColor, width: 2.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: categoryButtonDarkColor),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: const TextStyle(
            fontFamily: 'Lato', fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 18),
        foregroundColor: textMainColor,
      )),
  buttonTheme: ButtonThemeData(
    buttonColor: const Color.fromRGBO(209, 71, 28, 1.0),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: const BorderSide(color: backgroundScreenDarkColor, width: 2),
    ),
  ),
  textTheme: const TextTheme(
      displayLarge: TextStyle(
          color: Colors.grey,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 55),
      displaySmall: TextStyle(
        color: Colors.grey,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        fontSize: 36,
      ),
      headlineMedium: TextStyle(
          color: Colors.grey,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.normal,
          fontSize: 28),
      headlineSmall: TextStyle(
        color: textMainColor,
        fontFamily: 'LobsterTwo',
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal,
        fontSize: 23,
      ),
      titleLarge: TextStyle(
          color: borderColor,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 18),
      titleMedium: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          fontSize: 17),
      titleSmall: TextStyle(
          color: Colors.grey,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 16)),
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
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(fontSize: 20),
  ),
  iconTheme: const IconThemeData(color: textMainColor),
  popupMenuTheme: const PopupMenuThemeData(
    color: Color.fromRGBO(92, 90, 117, 1.0),
    textStyle: TextStyle(color: textMainColor),
  ),
);