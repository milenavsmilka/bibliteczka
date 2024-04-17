import 'dart:convert';

import 'package:biblioteczka/LoadingScreen.dart';
import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBookScreen.dart';
import '../main.dart';

class NewBooksScreen extends StatefulWidget {
  const NewBooksScreen({super.key});

  @override
  State<NewBooksScreen> createState() => _NewBooksScreenState();
}

class _NewBooksScreenState extends State<NewBooksScreen> {
  List<dynamic> listOfBooks = [];
  String title = '';
  String description = '';
  String isbn = '';
  String dateOfPremiere = '';
  String publishingHouse = '';
  String picture = '';
  double score = 0;
  int opinions_count = 0;

  @override
  initState() {
    super.initState();
    giveMeNewBooks('pl');
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print(listOfBooks);
    return listOfBooks.isEmpty
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text('Nowości'),
            ),
            body: ListView.builder(
                itemCount: listOfBooks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        checkIsTokenValid(
                            context,
                            DetailsOfBookScreen(
                              bookId: index,
                            ));
                      },
                      child: Row(
                        children: [
                          Column(children: [
                            Image.network(listOfBooks[index]['picture'],
                                width: widthScreen / 2, height: heightScreen / 3)
                          ]),
                          Column(
                            children: [
                              Text(listOfBooks[index]['title']),
                              Text(listOfBooks[index]['publishing_house']),
                              Text(listOfBooks[index]['premiere_date']
                                  .substring(5, 16))
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
          );
  }

  Future<void> giveMeNewBooks(String language) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    const String apiUrl = apiURLGetNewBooks;

    final params = {'language': language};
    final response = await http
        .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    });
    Map<String, dynamic> data = jsonDecode(response.body);

    setState(() {
      listOfBooks = data['results'];
    });
    print('number of listOfBooks ${listOfBooks.length}');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      print("Nie okej :(");
    }
  }
}
