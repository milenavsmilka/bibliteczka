import 'dart:async';
import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Tools/CustomPageRoute.dart';
import 'LoginScreen.dart';
import 'MainPanelScreen.dart';
import 'main.dart';

Future<void> changePassword(String newPass, String oldPass) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  final Map<String, dynamic> requestBody = {
    'current_password': oldPass,
    'new_password': newPass,
  };
  String requestBodyJson = jsonEncode(requestBody);

  final response = await http.patch(
    Uri.parse(apiURLChangePassword),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken'
    },
    body: requestBodyJson,
  );
  if (response.statusCode == 200) {
    print("Okej :D");
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
  } else {
    print("Nie okej :(");
    throw Exception('Failed to load data');
  }
}

Future<void> sendOpinion(String comment, int starsRating,
    String bookId) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  const String apiUrl = apiURLGetOpinion;
  final Map<String, dynamic> requestBody = {
    'book_id': bookId,
    'stars_count': starsRating,
    'comment': comment
  };
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
  if (message == 'object_created') {
    print("Okej :D");
  } else if (message == 'opinion_already_exists') {
    message = 'Możesz wystawić tylko jedną opinię dla danej książki';
    throw http.ClientException(message);
  } else if (message['comment'] ==
      'Value must be a str with length in range [0, 1000]') {
    message = 'Komentarz może mieć max 1000 znaków';
    throw http.ClientException(message);
  }
}

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
      "W pliku functions.dart wypisuję ważność tokenu i jego zawartość $isLoggedIn $actualToken");

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
  switch(profilePicture){
    case 1: return 'assets/profile_icons/funny_turtle.png';
    case 2: return 'assets/profile_icons/aries.png';
    case 3: return 'assets/profile_icons/camel.png';
    case 4: return 'assets/profile_icons/cat.png';
    case 5: return 'assets/profile_icons/chicken.png';
    case 6: return 'assets/profile_icons/cow.png';
    case 7: return 'assets/profile_icons/deer.png';
    case 8: return 'assets/profile_icons/dog.png';
    case 9: return 'assets/profile_icons/fox.png';
    case 10: return 'assets/profile_icons/frog.png';
    case 11: return 'assets/profile_icons/horse.png';
    case 12: return 'assets/profile_icons/lama.png';
    case 13: return 'assets/profile_icons/pig.png';
    case 14: return 'assets/profile_icons/rabbit.png';
    case 15: return 'assets/profile_icons/sheep.png';
    case 16: return 'assets/profile_icons/snake.png';
    case 17: return 'assets/profile_icons/turtle.png';
    case 18: return 'assets/profile_icons/worm.png';
  }
}