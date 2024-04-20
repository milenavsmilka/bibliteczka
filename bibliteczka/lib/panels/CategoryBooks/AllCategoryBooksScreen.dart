import 'dart:convert';

import 'package:biblioteczka/LoadingScreen.dart';
import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../styles/strings.dart';
import '../main.dart';
import 'DetailsOfBookScreen.dart';

class AllCategoryBooksScreen extends StatefulWidget {
  const AllCategoryBooksScreen(
      {super.key,
      required this.nameOfCategory,
      required this.nameOfCategoryEN});

  final String nameOfCategory;
  final String nameOfCategoryEN;

  @override
  State<AllCategoryBooksScreen> createState() => _AllCategoryBooksScreenState();
}

class _AllCategoryBooksScreenState extends State<AllCategoryBooksScreen> {
  List<dynamic> listOfBooks = [];

  @override
  void initState() {
    super.initState();
    giveMeListsOfBook(widget.nameOfCategoryEN);
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    print(widget.nameOfCategory);
    return listOfBooks.isEmpty
        ? LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              title: Text(widget.nameOfCategory),
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
                              bookId: listOfBooks[index]['id'], turnOpinions: true,
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

  Future<void> giveMeListsOfBook(String nameOfCategory) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    const String apiUrl = apiURLGetBooksByGenres;

    final params = {'genres': nameOfCategory};
    final response = await http
        .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    });
    Map<String, dynamic> data = jsonDecode(response.body);

    setState(() {
      listOfBooks = data['results'];
    });

    print('number of books ${listOfBooks.length}');

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      print(data);
    } else {
      print("Nie okej :(");
    }
  }
}
