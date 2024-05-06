import 'dart:convert';

import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../CategoryBooks/DetailsOfBookScreen.dart';
import '../Tools/Genres.dart';
import '../Tools/LoadingScreen.dart';
import '../Tools/functions.dart';
import '../main.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({Key? key}) : super(key: key);

  @override
  _TopScreen createState() => _TopScreen();
}

class _TopScreen extends State<TopScreen> {
  Genres genres = Genres.all;
  List<dynamic> listOfBooks = [-1];
  int current = 0;

  @override
  void initState() {
    super.initState();
    giveMeListsOfBook(Genres.all.nameEN);
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if (listOfBooks.isNotEmpty && listOfBooks[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar:
            DefaultAppBar(title: titleOfApp, automaticallyImplyLeading: true),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: heightScreen * 0.13,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: Genres.values.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (ctx, index) {
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    current = index;
                                    giveMeListsOfBook(
                                        Genres.values[index].nameEN);
                                  });
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin: const EdgeInsets.all(5),
                                  width: widthScreen * 0.3,
                                  height: heightScreen * 0.1,
                                  decoration: BoxDecoration(
                                    color: current == index
                                        ? Theme.of(context)
                                            .inputDecorationTheme
                                            .enabledBorder!
                                            .borderSide
                                            .color
                                        : Colors.white54,
                                    borderRadius: current == index
                                        ? BorderRadius.circular(12)
                                        : BorderRadius.circular(7),
                                    border: current == index
                                        ? Border.all(
                                            color: Theme.of(context)
                                                .inputDecorationTheme
                                                .enabledBorder!
                                                .borderSide
                                                .color,
                                            width: 2.5)
                                        : null,
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Genres.values[index].name,
                                          style: TextStyle(
                                              color: current == index
                                                  ? Theme.of(context)
                                                      .appBarTheme
                                                      .foregroundColor
                                                  : Colors.grey,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.fontSize,
                                              fontFamily: current == index
                                                  ? Theme.of(context)
                                                      .textTheme
                                                      .headlineSmall
                                                      ?.fontFamily
                                                  : Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.fontFamily),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
              if (listOfBooks.isEmpty) ...{
                Container(child: Text(nothingHere))
              } else ...{
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: heightScreen / 2.4 + 30),
                    padding: const EdgeInsets.all(10.0),
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: listOfBooks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            GestureDetector(
                              onTap: () {
                                checkIsTokenValid(
                                    context,
                                    DetailsOfBookScreen(
                                      bookId: listOfBooks[index]['id'],
                                      turnOpinions: true,
                                    ));
                              },
                              child: SizedBox(
                                  width: widthScreen / 2.3,
                                  height: heightScreen / 2.5,
                                  child: Image.network(
                                    listOfBooks[index]['picture'],
                                    fit: BoxFit.fill,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                          'assets/images/brak_ksiazki.png',
                                          fit: BoxFit.fill);
                                    },
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                              child: Text(listOfBooks[index]['title'],
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                            )
                          ]),
                        ],
                      );
                    }),
              }
            ],
          ),
        ),
      );
    }
  }

  Future<void> giveMeListsOfBook(String nameOfCategory) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    const String apiUrl = apiURLGetBooks;

    var params = {'': ''};
    if (nameOfCategory != Genres.all.nameEN) {
      params = {
        'genres': nameOfCategory,
        'per_page': '10',
        'minimum_score': '4',
        'sorts': '-opinions_count,-score'
      };
    } else {
      params = {
        'per_page': '10',
        'minimum_score': '4',
        'sorts': '-opinions_count,-score'
      };
    }
    final response = await http
        .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    });
    Map<String, dynamic> data = jsonDecode(response.body);
    print('jaki rezulat? $data');
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