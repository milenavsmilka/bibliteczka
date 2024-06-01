import 'dart:async';
import 'dart:convert';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Login.dart';
import '../MainPanel.dart';
import '../main.dart';
import 'CustomPageRoute.dart';
import 'NoConnection.dart';

Widget emptyBox(double widthScreen, double heightScreen, BuildContext context) {
  return SizedBox(
    width: widthScreen / 5,
    height: heightScreen / 5,
    child: Center(child: Text(AppLocalizations.of(context)!.nothingHere)),
  );
}

Future<void> deleteSth(BuildContext context, String apiUrl, Map<String,dynamic> requestBody) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  String requestBodyJson = jsonEncode(requestBody);

  try {
    final response = await http
        .delete(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $actualToken'
          },
          body: requestBodyJson,
        )
        .timeout(const Duration(seconds: 10));
    print('Response: $requestBody');
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    if (response.statusCode == 200) {
      print("Okej :D");
    } else {
      print("Nie okej :(");
      throw http.ClientException(response.body);
    }
  } on TimeoutException catch (_) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NoConnection();
        });
  }
}

Future<Map<String, dynamic>> changeSthInMyAccount(
    BuildContext context, String apiURL, Map<String, dynamic> requestBody) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  String requestBodyJson = jsonEncode(requestBody);

  try {
    final response = await http
        .patch(
          Uri.parse(apiURL),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $actualToken'
          },
          body: requestBodyJson,
        )
        .timeout(const Duration(seconds: 10));

    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("Okej :D");
    } else {
      print("Nie okej :(");
      throw http.ClientException(response.body);
    }
    return data;
  } on TimeoutException catch (_) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NoConnection();
        });
  }
  return Map.of({});
}

Future<void> sendRequest(
    String apiUrl, Map<String, dynamic> requestBody, BuildContext context) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

  String requestBodyJson = jsonEncode(requestBody);

  try {
    final response = await http
        .post(
          Uri.parse(apiUrl),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $actualToken',
          },
          body: requestBodyJson,
        )
        .timeout(const Duration(seconds: 10));
    print(requestBody);

    Map<String, dynamic> data = jsonDecode(response.body);
    var message = data['message'];
    print(message);
    if (message == 'logged_out') {
      sharedPreferences.clear();
      print(AppLocalizations.of(context)!.userLogOutCorrectly);
      checkIsTokenValid(
          context,
          Navigator.push(context,
              CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: const LoginScreen())));
    } else if (response.statusCode == 200) {
      print("Okej :D");
    } else if (message == 'opinion_already_exists') {
      message = AppLocalizations.of(context)!.youCanSendOneOpinion;
      throw http.ClientException(message);
    } else if (message == 'length_validation_error') {
      message = AppLocalizations.of(context)!.commentMin2Max1000;
      throw http.ClientException(message);
    } else {
      print("Nie okej :(");
      throw http.ClientException(message);
    }
  } on TimeoutException catch (_) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NoConnection();
        });
  }
}

Future<Map<String, dynamic>> getSthById(
    BuildContext context, String url, Map<String, dynamic> params) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  try {
    final response = await http.get(Uri.parse(url).replace(queryParameters: params), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    }).timeout(const Duration(seconds: 10));
    Map<String, dynamic> data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print('good');
    } else {
      print("Nie good $params ${response.body}");
    }
    return data;
  } on TimeoutException catch (_) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NoConnection();
        });
  }
  return Map.of({});
}

void checkIsTokenValid(BuildContext context, [Future<dynamic>? navigator]) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print("Wypisuję ważność tokenu i jego zawartość $isLoggedIn $actualToken");

  if (actualToken != null) {
    try {
      final response = await http.get(Uri.parse(apiURLIsTokenValid), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $actualToken'
      }).timeout(const Duration(seconds: 10));
      Map<String, dynamic> data = jsonDecode(response.body);
      String tokenValid = data['message'];
      print('Czy token valid? $tokenValid');
      if (tokenValid == AppLocalizations.of(context)!.tokenIsValid) {
        if (navigator != null) {
          navigator;
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.sessionExpired),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              CustomPageRoute(
                                  chooseAnimation: CustomPageRoute.SLIDE, child: const LoginScreen()));
                        },
                        child: Text(AppLocalizations.of(context)!.ok)),
                  ],
                ));
      }
    } on TimeoutException catch (_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return const NoConnection();
          });
    }
  } else {
    Navigator.push(
        context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: const LoginScreen()));
  }
}

void whereToGo(BuildContext context) async {
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  var isLoggedIn = sharedPreferences.getBool('isLogged') ?? false;

  print("Wypiszę $isLoggedIn $actualToken");

  Timer(const Duration(seconds: 2), () async {
    if (actualToken != null) {
      Map<String, dynamic> data = await getSthById(context, apiURLIsTokenValid, Map.of({}));
      String tokenValid = data['message'];
      print('Czy token valid? $tokenValid');
      if (tokenValid == AppLocalizations.of(context)!.tokenIsValid) {
        Navigator.push(context,
            CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: const MainPanelScreen()));
      } else {
        Navigator.push(
            context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: const LoginScreen()));
      }
    } else {
      Navigator.push(
          context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: const LoginScreen()));
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
