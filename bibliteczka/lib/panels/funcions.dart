import 'dart:convert';


import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomPageRoute.dart';
import 'LoginScreen.dart';
import 'main.dart';

void checkIsTokenValid(BuildContext context, Widget widgetToRoute) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print(
      "W pliku funcions.dart wypisuję ważność tokenu i jego zawartość $isLoggedIn $actualToken");

  if (actualToken != null) {
    //pobranie ważności tokena
    const String apiUrl = apiURLIsTokenValidWybrany; //apiURLIsTokenValid;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken'
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    String tokenValid = data['message'];
    print('Czy token valid? $tokenValid');
    if (tokenValid == tokenIsValid) {
      //jeżeli token jest ważny
      Navigator.push(context, CustomPageRoute(child: widgetToRoute));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Twoja sesja wygasła. Zaloguj się ponownie."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, CustomPageRoute(child: LoginScreen()));
                      },
                      child: Text("OK")),
                ],
              ));
    }
  } else {
    Navigator.push(context, CustomPageRoute(child: LoginScreen()));
  }
}
