import 'dart:async';
import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'CustomPageRoute.dart';
import '../Login.dart';
import '../MainPanel.dart';
import '../main.dart';

Widget emptyBox(double widthScreen, double heightScreen) {
  return SizedBox(
    width: widthScreen / 5,
    height: heightScreen / 5,
    child: Center(child: const Text(nothingHere)),
  );
}

Future<void> deleteSth(String apiUrl, String key, String value) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  final Map<String, dynamic> requestBody = {
    key: value,
  };
  String requestBodyJson = jsonEncode(requestBody);

  final response = await http.delete(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken'
    },
    body: requestBodyJson,
  );
  print('Response: ${requestBody}');
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print("Okej :D");
  } else {
    print("Nie okej :(");
    throw http.ClientException(response.body);
  }
}

Future<Map<String, dynamic>> changeSthInMyAccount(
    String apiURL, Map<String, dynamic> requestBody) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  String requestBodyJson = jsonEncode(requestBody);

  final response = await http.patch(
    Uri.parse(apiURL),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken'
    },
    body: requestBodyJson,
  );

  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print("Okej :D");
  } else {
    print("Nie okej :(");
    throw http.ClientException(response.body);
  }
  return data;
}

Future<void> sendRequest(String apiUrl, Map<String, dynamic> requestBody,
    [BuildContext? context]) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  String requestBodyJson = jsonEncode(requestBody);

  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    },
    body: requestBodyJson,
  );

  print(requestBody);

  Map<String, dynamic> data = jsonDecode(response.body);
  var message = data['message'];
  print(message);
  if (message == 'logged_out') {
    sharedPreferences.clear();
    print("Poprawnie wylogowano użytkownika");
    Navigator.push(
        context!, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: LoginScreen()));
  } else if (response.statusCode == 200) {
    print("Okej :D");
  } else if (message == 'opinion_already_exists') {
    message = 'Możesz wystawić tylko jedną opinię dla danej książki';
    throw http.ClientException(message);
  } else if (message == 'length_validation_error') {
    message = 'Komentarz może mieć min 2 i max 1000 znaków';
    throw http.ClientException(message);
  } else {
    print("Nie okej :(");
    throw http.ClientException(message);
  }
}

Future<Map<String, dynamic>> getSthById(String url, Map<String, dynamic> params) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  final response = await http.get(Uri.parse(url).replace(queryParameters: params), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $actualToken',
  });
  Map<String, dynamic> data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print('good');
  } else {
    print("Nie good $params ${response.body}");
  }
  return data;
}

void checkIsTokenValid(BuildContext context, [Widget? widgetToRoute]) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print("Wypisuję ważność tokenu i jego zawartość $isLoggedIn $actualToken");

  if (actualToken != null) {
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
        Navigator.push(
            context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: widgetToRoute));
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
                            context,
                            CustomPageRoute(
                                chooseAnimation: CustomPageRoute.SLIDE, child: LoginScreen()));
                      },
                      child: Text("OK")),
                ],
              ));
    }
  } else {
    Navigator.push(
        context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: LoginScreen()));
  }
}

void whereToGo(BuildContext context) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print("Wypiszę $isLoggedIn $actualToken");

  Timer(const Duration(seconds: 2), () async {
    if (actualToken != null) {
      Map<String, dynamic> data = await getSthById(apiURLIsTokenValid, Map.of({}));
      String tokenValid = data['message'];
      print('Czy token valid? $tokenValid');
      if (tokenValid == tokenIsValid) {
        Navigator.push(context,
            CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: MainPanelScreen()));
      } else {
        Navigator.push(
            context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: LoginScreen()));
      }
    } else {
      Navigator.push(
          context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: LoginScreen()));
    }
  });
}

void showSnackBar(BuildContext context, String text, Color color) {
  final snackBar = SnackBar(
    content: Text(
      text,
    ),
    backgroundColor: color,
  );

  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(snackBar);
}

setProfilePicture(int profilePicture) {
  switch (profilePicture) {
    case 1:
      return 'assets/profile_icons/funny_turtle.png';
    case 2:
      return 'assets/profile_icons/aries.png';
    case 3:
      return 'assets/profile_icons/camel.png';
    case 4:
      return 'assets/profile_icons/cat.png';
    case 5:
      return 'assets/profile_icons/chicken.png';
    case 6:
      return 'assets/profile_icons/cow.png';
    case 7:
      return 'assets/profile_icons/deer.png';
    case 8:
      return 'assets/profile_icons/dog.png';
    case 9:
      return 'assets/profile_icons/fox.png';
    case 10:
      return 'assets/profile_icons/frog.png';
    case 11:
      return 'assets/profile_icons/horse.png';
    case 12:
      return 'assets/profile_icons/lama.png';
    case 13:
      return 'assets/profile_icons/pig.png';
    case 14:
      return 'assets/profile_icons/rabbit.png';
    case 15:
      return 'assets/profile_icons/sheep.png';
    case 16:
      return 'assets/profile_icons/snake.png';
    case 17:
      return 'assets/profile_icons/turtle.png';
    case 18:
      return 'assets/profile_icons/worm.png';
  }
}
