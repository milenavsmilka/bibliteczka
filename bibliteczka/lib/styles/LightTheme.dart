import 'package:flutter/material.dart';

final Color colorAppBar = Color.fromRGBO(242, 224, 157, 1);
final Color backgroundScreenColor = Color.fromRGBO(253, 249, 240, 1);
final Color categoryButtonCyanColor = Color.fromRGBO(150, 218, 214, 1);
const Color textMainColor = Colors.black;
final Color borderColor = Colors.grey;
final Color greyContainerOpinion = Colors.black12;
final Color errorColor = Colors.redAccent;

ThemeData lightTheme = ThemeData(
  primaryColor: colorAppBar,
  secondaryHeaderColor: greyContainerOpinion,
  colorScheme:
      ColorScheme.fromSwatch().copyWith(primary: colorAppBar, secondary: const Color(0xffdfeaf2)),
  brightness: Brightness.light,
  cardColor: Colors.orange,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  ),
  inputDecorationTheme: InputDecorationTheme(
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
    errorStyle: TextStyle(fontSize: 14.0, color: Colors.red),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.0)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 1.5)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: categoryButtonCyanColor, width: 2.0)),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: categoryButtonCyanColor),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    textStyle: TextStyle(
        fontFamily: 'Lato', fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 18),
    foregroundColor: textMainColor,
  )),
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.orange,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(0.0),
      side: BorderSide(color: backgroundScreenColor, width: 2),
    ),
  ),
  textTheme: TextTheme(
      displayLarge: TextStyle(
          color: Colors.black,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.italic,
          fontSize: 55),
      // displayMedium: TextStyle(
      //     color: textMainColor,
      //     fontFamily: 'Merienda',
      //     fontWeight: FontWeight.w800,
      //     fontStyle: FontStyle.italic,
      //     fontSize: 35),
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
  ),
  dialogTheme: DialogTheme(
      backgroundColor: backgroundScreenColor,
      titleTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 20),
      contentTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Lato',
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15),
      surfaceTintColor: Colors.transparent),
  snackBarTheme: const SnackBarThemeData(
    contentTextStyle: TextStyle(fontSize: 20),
  ),
  iconTheme: IconThemeData(color: textMainColor),
);
