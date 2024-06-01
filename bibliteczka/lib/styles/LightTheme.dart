import 'package:flutter/material.dart';

const Color colorAppBar = Color.fromRGBO(242, 224, 157, 1);
const Color backgroundScreenColor = Color.fromRGBO(253, 249, 240, 1);
const Color categoryButtonCyanColor = Color.fromRGBO(150, 218, 214, 1);
const Color textMainColor = Colors.black;
const Color borderColor = Colors.grey;
const Color greyContainerOpinion = Colors.black12;
const Color errorColor = Colors.redAccent;

ThemeData lightTheme = ThemeData(
  primaryColor: colorAppBar,
  secondaryHeaderColor: greyContainerOpinion,
  colorScheme:
      ColorScheme.fromSwatch().copyWith(primary: colorAppBar, secondary: const Color(0xffdfeaf2)),
  brightness: Brightness.light,
  cardColor: Colors.orange,
  scaffoldBackgroundColor: const Color.fromRGBO(253, 249, 240, 1),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(
            fontFamily: 'LobsterTwo',
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
            fontSize: 25),
        minimumSize: const Size.square(50.0),
        backgroundColor: categoryButtonCyanColor,
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
        OutlineInputBorder(borderSide: BorderSide(color: categoryButtonCyanColor, width: 2.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: categoryButtonCyanColor),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    textStyle: const TextStyle(
        fontFamily: 'Lato', fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 18),
    foregroundColor: textMainColor,
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.orange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: const BorderSide(color: backgroundScreenColor, width: 2),
    ),
  ),
  textTheme: const TextTheme(
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
      headlineMedium: TextStyle(
          color: Colors.black,
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
          color: Colors.black,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.normal,
          fontSize: 17),
      titleSmall: TextStyle(
          color: Colors.black,
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
    backgroundColor: colorAppBar,
  ),
  dialogTheme: const DialogTheme(
      backgroundColor: backgroundScreenColor,
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
    color: Colors.white,
    textStyle: TextStyle(color: textMainColor),
  ),
);
