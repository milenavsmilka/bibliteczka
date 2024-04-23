import 'dart:async';
import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Tools/CustomPageRoute.dart';
import 'LoginScreen.dart';
import 'MainPanelScreen.dart';
import 'main.dart';

Future<Map<String, dynamic>> getSthById(String url, String token, String key, String value) async {
  final params = {key: value};
  final response = await http
      .get(Uri.parse(url).replace(queryParameters: params), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $token',
  });
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print('good');
  } else {
    print("Nie good");
  }
  return data;
}

Future<void> logOut(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  const String apiUrl = apiURLLogOut;
  final Map<String, dynamic> requestBody = {
  };
  String requestBodyJson = jsonEncode(requestBody);

  final response = await http.post(Uri.parse(apiUrl), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $actualToken'
  }, body: requestBodyJson);
  Map<String, dynamic> data = jsonDecode(response.body);
  String message = data['message'];
  print('Otrzymana wiadomość po wylogowaniu: $message $actualToken');
  if (response.statusCode == 200) {
    sharedPreferences.clear();
    print("Poprawnie wylogowano użytkownika");
    Navigator.push(
        context, CustomPageRoute(child: LoginScreen()));
  } else {
    print("Pojawił się błąd, użytkownik nie został wylogowany");
  }
}

void checkIsTokenValid(BuildContext context, [Widget? widgetToRoute]) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print(
      "W pliku apiRequests.dart wypisuję ważność tokenu i jego zawartość $isLoggedIn $actualToken");

  if (actualToken != null) {
    //pobranie ważności tokena
    const String apiUrl = apiURLIsTokenValid;
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
    if (actualToken != null) {
      //pobranie ważności tokena
      final apiUrl = Uri.parse(apiURLIsTokenValid); //apiURLIsTokenValid;
      final response = await http.get(apiUrl, headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $actualToken',
      });
      Map<String, dynamic> data = jsonDecode(response.body);
      String tokenValid = data['message'];
      print('Czy token valid? $tokenValid');
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
