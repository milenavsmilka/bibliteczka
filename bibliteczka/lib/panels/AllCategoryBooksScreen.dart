import 'dart:convert';
import 'dart:math';

import 'package:biblioteczka/panels/ChooseCategoryScreen.dart';
import 'package:biblioteczka/panels/DetailsOfBookScreen.dart';
import 'package:biblioteczka/panels/MainPanelScreen.dart';
import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../styles/strings.dart';
import 'main.dart';

class AllCategoryBooksScreen extends StatefulWidget {
  const AllCategoryBooksScreen(
      {super.key, required this.nameOfCategory, required this.listOfBooks});

  final String nameOfCategory;
  final List<dynamic> listOfBooks;

  @override
  State<AllCategoryBooksScreen> createState() => _AllCategoryBooksScreenState();
}

class _AllCategoryBooksScreenState extends State<AllCategoryBooksScreen> {
  String title = '';
  String description = '';
  String isbn = '';
  String dateOfPremiere = '';
  String publishingHouse = '';
  String picture = '';

  @override
  Widget build(BuildContext context) {
    print(widget.nameOfCategory);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nameOfCategory),
      ),
      body: ListView.builder(
          itemCount: widget.listOfBooks.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {
                await giveMeDetailsOfBook('pl', widget.listOfBooks[index]['id']);
                checkIsTokenValid(
                    context,
                    DetailsOfBookScreen(
                      nameOfCategory: widget.nameOfCategory,
                      title: title,
                      dateOfPremiere: dateOfPremiere,
                      description: description,
                      isbn: isbn,
                      picture: picture,
                      publishingHouse: publishingHouse,
                    ));
              },
              child: Card(
                key: ValueKey(widget.listOfBooks[index]['id']),
                margin: EdgeInsets.all(10),
                color: Colors.amber.shade50,
                child: ListTile(
                  leading: Image.network(widget.listOfBooks[index]['picture']),
                  title: Text(widget.listOfBooks[index]['title']),
                  subtitle: Text(widget.listOfBooks[index]['isbn']),
                ),
              ),
            );
          }),
    );
  }

  Future<void> giveMeDetailsOfBook(String language, int bookId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    const String apiUrl = apiURLGetBooksByGenres;

    final params = {'language': language, 'id': bookId.toString()};
    print(Uri.parse(apiUrl).replace(queryParameters: params));
    final response = await http
        .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    });
    Map<String, dynamic> data = jsonDecode(response.body);

    title = data['title'];
    description = data['description'];
    isbn = data['isbn'];
    dateOfPremiere = data['premiere_date'];
    publishingHouse = data['publishing_house'];
    picture = data['picture'];

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      print("Nie okej :(");
    }
  }
}
