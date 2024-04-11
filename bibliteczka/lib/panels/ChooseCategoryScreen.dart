import 'dart:convert';
import 'dart:isolate';

import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'AllCategoryBooksScreen.dart';
import 'main.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({super.key});

  @override
  State<ChooseCategoryScreen> createState() => _ChooseCategoryScreenState();
}

class _ChooseCategoryScreenState extends State<ChooseCategoryScreen> {
  List<dynamic> users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kategoria"),
        ),
        body: CustomScrollView(
          scrollDirection: Axis.vertical,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Wrap(children: [
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Romans',
                      pathToImage: iconHeart,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Dziecięce',
                      pathToImage: iconChild,
                    ),
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Historia',
                      pathToImage: iconSwords,
                    ),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                      nameOfCategory: 'Nauka',
                      pathToImage: iconBrainstorming,
                    ),
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Wiersze',
                      pathToImage: iconQuill,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Młodzieżowe',
                      pathToImage: iconYoungAdults,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Fantasy',
                      pathToImage: iconDragon,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Biografie',
                      pathToImage: iconContacts,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Przygodowe',
                      pathToImage: iconAdventure,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Komiksy',
                      pathToImage: iconComic,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                      nameOfCategory: 'Thrillery',
                      pathToImage: iconDetective,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Inne',
                      pathToImage: iconOther,
                    )
                  ],
                ),
                SizedBox(height: 20, width: 20),
              ]),
            )
          ],
        ));
  }
}

Future<List> giveMeListsOfBook() async {
  List<dynamic> books = [];
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  const String apiUrl = apiURLGetBooksByGenres;

  final params = {'language':'pl','genres': 'Romance'};
  final response = await http
      .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $actualToken',
  });
  print('Dupa');
  Map<String, dynamic> data = jsonDecode(response.body);

  books = data['books'];
  print('number of books ${books.length}');

  if (response.statusCode == 200) {
    print("Czy okej?");
    // If the server returns a 200 OK response, parse the JSON
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
    // Do something with the data
  } else {
    print("Nie okej :(");
  }
  return books;
}

class CategoryButton extends StatelessWidget {
  final String nameOfCategory;
  final String pathToImage;

  const CategoryButton(
      {super.key, required this.nameOfCategory, required this.pathToImage});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          List<dynamic> books = await giveMeListsOfBook();
          checkIsTokenValid(
              context, TestScreen(nameOfCategory: nameOfCategory,listOfBooks: books));
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23.0)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(pathToImage,
                height: MediaQuery.of(context).size.width * 0.3),
            Text(nameOfCategory)
          ],
        ));
  }
}
