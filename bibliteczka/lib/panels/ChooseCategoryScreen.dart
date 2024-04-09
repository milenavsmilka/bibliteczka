import 'dart:convert';

import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

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
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
              // alignment: WrapAlignment.spaceBetween,
              // crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Romans',
                        pathToImage: iconHeart),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                        nameOfCategory: 'Dziecięce',
                        pathToImage: iconChild),
                  ],
                ),
                // SizedBox(width: 1, height: MediaQuery.of(context).size.height* 0.3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Historia',
                        pathToImage: iconSwords),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.06),
                    CategoryButton(
                        nameOfCategory: 'Popularnonaukowe',
                        pathToImage: iconBrainstorming),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CategoryButton(
                        nameOfCategory: 'Wiersze',
                        pathToImage: iconQuill),
                    CategoryButton(
                        nameOfCategory: 'Młodzieżowe',
                        pathToImage: iconYoungAdults)
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     CategoryButton(
                //         nameOfCategory: 'Fantasy',
                //         pathToImage: 'assets/icons/child.svg'),
                //     CategoryButton(
                //         nameOfCategory: 'Biografie',
                //         pathToImage: 'assets/icons/child.svg')
                //   ],
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     CategoryButton(
                //         nameOfCategory: 'Kryminał',
                //         pathToImage: 'assets/icons/child.svg'),
                //     CategoryButton(
                //         nameOfCategory: 'Dziecięce',
                //         pathToImage: 'assets/icons/child.svg')
                //   ],
                // ),
              ]),
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

  const CategoryButton(
      {super.key, required this.nameOfCategory, required this.pathToImage});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {},
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
