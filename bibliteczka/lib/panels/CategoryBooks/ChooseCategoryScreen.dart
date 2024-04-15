import 'dart:convert';

import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'AllCategoryBooksScreen.dart';

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
                      nameOfCategoryEN: 'Romance',
                      pathToImage: iconHeart,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Dziecięce',
                      nameOfCategoryEN: "Children's",
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
                      nameOfCategoryEN: 'History',
                      pathToImage: iconSwords,
                    ),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                      nameOfCategory: 'Nauka',
                      nameOfCategoryEN: 'Popular Science',
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
                      nameOfCategoryEN: 'Poetry, Plays',
                      pathToImage: iconQuill,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Młodzieżowe',
                      nameOfCategoryEN: 'Young Adult',
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
                      nameOfCategoryEN: 'Fantasy, Science fiction',
                      pathToImage: iconDragon,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Biografie',
                      nameOfCategoryEN: 'Biography',
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
                      nameOfCategoryEN: 'Action & Adventure',
                      pathToImage: iconAdventure,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Komiksy',
                      nameOfCategoryEN: 'Comic books',
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
                      nameOfCategoryEN: 'Thriller, Horror, Mystery and detective stories',
                      pathToImage: iconDetective,
                    ),
                    CategoryButton(
                      nameOfCategory: 'Inne',
                      nameOfCategoryEN: 'Other',
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

Future<List> giveMeListsOfBook(String language, String nameOfCategory) async {
  List<dynamic> books = [];
  var sharedPreferences = await SharedPreferences.getInstance();
  String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
  const String apiUrl = apiURLGetBooksByGenres;

  final params = {'language': language,'genres': nameOfCategory};
  final response = await http
      .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer $actualToken',
  });
  Map<String, dynamic> data = jsonDecode(response.body);

  books = data['books'];
  print('number of books ${books.length}');

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);
  } else {
    print("Nie okej :(");
  }
  return books;
}

class CategoryButton extends StatelessWidget {
  final String nameOfCategory;
  final String nameOfCategoryEN;
  final String pathToImage;

  const CategoryButton(
      {super.key, required this.nameOfCategory, required this.pathToImage, required this.nameOfCategoryEN});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          List<dynamic> books = await giveMeListsOfBook('pl',nameOfCategoryEN);
          checkIsTokenValid(
              context, AllCategoryBooksScreen(nameOfCategory: nameOfCategory,listOfBooks: books));
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
