import 'dart:convert';

import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'TestScreen.dart';

class ChooseCategoryScreen extends StatefulWidget {
  const ChooseCategoryScreen({Key? key}) : super(key: key);

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
                      widgetToRoute: TestScreen(),
                    ),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                        nameOfCategory: 'Dziecięce',
                        pathToImage: iconChild,
                        widgetToRoute: TestScreen()),
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Historia',
                        pathToImage: iconSwords,
                        widgetToRoute: TestScreen()),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                        nameOfCategory: 'Nauka',
                        pathToImage: iconBrainstorming,
                        widgetToRoute: TestScreen()),
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Wiersze',
                        pathToImage: iconQuill,
                        widgetToRoute: TestScreen()),
                    CategoryButton(
                        nameOfCategory: 'Młodzieżowe',
                        pathToImage: iconYoungAdults,
                        widgetToRoute: TestScreen())
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Fantasy',
                        pathToImage: iconDragon,
                        widgetToRoute: TestScreen()),
                    CategoryButton(
                        nameOfCategory: 'Biografie',
                        pathToImage: iconContacts,
                        widgetToRoute: TestScreen())
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Przygodowe',
                        pathToImage: iconAdventure,
                        widgetToRoute: TestScreen()),
                    CategoryButton(nameOfCategory: 'Komiksy', pathToImage: iconComic, widgetToRoute: TestScreen())
                  ],
                ),
                SizedBox(height: 20, width: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Thrillery',
                        pathToImage: iconDetective,
                        widgetToRoute: TestScreen()),
                    CategoryButton(
                        nameOfCategory: 'Inne',
                        pathToImage: iconOther,
                        widgetToRoute: TestScreen())
                  ],
                ),
                SizedBox(height: 20, width: 20),
              ]),
            )
          ],
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

class CategoryButton extends StatelessWidget {
  final String nameOfCategory;
  final String pathToImage;
  final Widget widgetToRoute;

  const CategoryButton(
      {super.key,
      required this.nameOfCategory,
      required this.pathToImage,
      required this.widgetToRoute});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          checkIsTokenValid(context, widgetToRoute);
        },
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(23.0)))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(pathToImage,
                    height: MediaQuery.of(context).size.width * 0.3)
            ,Text(nameOfCategory)
          ],
        ));
  }
}
