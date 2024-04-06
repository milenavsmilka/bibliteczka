import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({Key? key}) : super(key: key);

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  List<dynamic> users=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Testy mikrofonu"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: giveMeInformation,
        ));
  }

  void giveMeInformation() async {
    print("Próba mikrofonu");

    const String apiUrl = 'https://192.168.0.2:5000/api/account/register';
    final Map<String, dynamic> requestBody = {
      'username': 'AniaBania-1234',
      'password': 'AniaBania-1234',
      'email': 'aniBania@gmail.com'
    };
    String requestBodyJson = jsonEncode(requestBody);
    final Uri uri = Uri.parse(apiUrl);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: requestBodyJson,
    );
    if (response.statusCode == 200) {
      print("Czy okej?");
      // If the server returns a 200 OK response, parse the JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
      // Do something with the data
    } else {
      print("Nie okej :(");
      // If the server returns an error response
      throw Exception('Failed to load data');
    }
  }
}
