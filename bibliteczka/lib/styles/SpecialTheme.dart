import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color colorAppBar = Color.fromRGBO(0, 191, 178, 1);
const Color backgroundScreenColor = Colors.white;
const Color categoryButtonCyanColor = Color.fromRGBO(0, 191, 178, 1);
const Color textMainColor = Colors.black;
const Color borderColor = Colors.grey;
const Color greyContainerOpinion = Colors.black12;
const Color errorColor = Colors.redAccent;

ThemeData specialTheme = ThemeData(
  primaryColor: colorAppBar,
  secondaryHeaderColor: greyContainerOpinion,
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(primary: colorAppBar, secondary: backgroundScreenColor),
  brightness: Brightness.light,
  scaffoldBackgroundColor: backgroundScreenColor,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
            fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 22),
        minimumSize: const Size.square(50.0),
        backgroundColor: categoryButtonCyanColor,
        foregroundColor: textMainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    labelStyle: TextStyle(
        color: Colors.grey,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.normal,
        fontSize: 18),
    errorStyle: TextStyle(fontSize: 14.0, color: Colors.red),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.0)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: categoryButtonCyanColor, width: 2.0)),
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
        fontSize: 18),
    foregroundColor: textMainColor,
  )),
  buttonTheme: ButtonThemeData(buttonColor: colorAppBar),
  textTheme: TextTheme(
      displayLarge: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.normal,
          fontSize: 55),
      // displayMedium: TextStyle(
      //     color: textMainColor,
      //     fontFamily: 'Merienda',
      //     fontWeight: FontWeight.w800,
      //     fontStyle: FontStyle.italic,
      //     fontSize: 35),
      displaySmall: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.normal,
        fontSize: 36,
      ),
      headlineMedium: TextStyle(
          color: textMainColor,
          fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily,
          fontWeight: FontWeight.w800,
          fontStyle: FontStyle.normal,
          fontSize: 28),
      headlineSmall: TextStyle(
        color: textMainColor,
        fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal,
        fontSize: 22,
      ),
      titleLarge: TextStyle(
          color: Colors.grey,
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
          fontSize: 20)),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
        color: textMainColor,
        fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily,
        fontWeight: FontWeight.w800,
        fontStyle: FontStyle.normal,
        fontSize: 33),
    centerTitle: true,
    foregroundColor: textMainColor,
    backgroundColor: colorAppBar,
  ),
  dialogTheme: DialogTheme(
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
  iconTheme: IconThemeData(color: textMainColor),
);
