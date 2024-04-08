import 'dart:async';
import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomPageRoute.dart';
import 'LoginScreen.dart';
import 'MainPanelScreen.dart';
import 'main.dart';

void checkIsTokenValid(BuildContext context, [Widget? widgetToRoute]) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print(
      "W pliku apiRequests.dart wypisuję ważność tokenu i jego zawartość $isLoggedIn $actualToken");

  if (actualToken != null) {
    //pobranie ważności tokena
    const String apiUrl = apiURLIsTokenValid; //apiURLIsTokenValid;
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken'
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    String tokenValid = data['message'];
    print('Czy token valid? $tokenValid');
    if (tokenValid == tokenIsValid) {
      if (widgetToRoute != null) {
        //jeżeli token jest ważny
        Navigator.push(context, CustomPageRoute(child: widgetToRoute));
      }
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

void whereToGo(BuildContext context) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  // String? isLoggedIn = sharedPreferences.getString(isLogged);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print("Wypiszę $isLoggedIn $actualToken");

  Timer(const Duration(seconds: 2), () async {
    final params = {'language': "pl"};
    if (actualToken != null) {
      //pobranie ważności tokena
      final apiUrl = Uri.parse(apiURLIsTokenValid)
          .replace(queryParameters: params); //apiURLIsTokenValid;
      final response = await http.get(apiUrl, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $actualToken',
      });
      Map<String, dynamic> data = jsonDecode(response.body);
      String tokenValid = data['message'];
      // String details = data['details'];
      print('Czy token valid? $tokenValid');
      // print('details $details');
      if (tokenValid == tokenIsValid) {
        //jeżeli token jest ważny
        Navigator.push(context, CustomPageRoute(child: MainPanelScreen()));
      } else {
        Navigator.push(context, CustomPageRoute(child: LoginScreen()));
      }
    } else {
      Navigator.push(context, CustomPageRoute(child: LoginScreen()));
    }
  });
}
