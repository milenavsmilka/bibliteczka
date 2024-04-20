import 'dart:convert';

import 'package:biblioteczka/panels/CategoryBooks/OpinionScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../LoadingScreen.dart';
import '../../styles/strings.dart';
import '../apiRequests.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class DetailsOfBookScreen extends StatefulWidget {
  const DetailsOfBookScreen({super.key, required this.bookId, this.turnOpinions});

  final int bookId;
  final bool? turnOpinions;

  @override
  State<DetailsOfBookScreen> createState() => _DetailsOfBookScreenState();
}

class _DetailsOfBookScreenState extends State<DetailsOfBookScreen> {
  String nameOfCategory = '';
  String title = '';
  String description = '';
  String isbn = '';
  String dateOfPremiere = '';
  String publishingHouse = '';
  String picture = '';
  String authorName = '';
  int authorId = -1;
  List<dynamic> opinions = [];
  double rate = 1.0;

  @override
  void initState() {
    super.initState();
    giveMeDetailsOfBook('pl', widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print('${nameOfCategory} ${title}');

    if (authorName == '') {
      return const LoadingScreen();
    } else {
      return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Wrap(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Image.network(picture,
                          width: widthScreen / 2, height: heightScreen / 3),
                      Text(title),
                    ],
                  ),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(children: [Text('Tytuł: '), Text(title)]),
                        Row(
                          children: [Text('Autor: '), Text(authorName)],
                        ),
                        Row(children: [
                          Text('Wydawnictwo: '),
                          Text(publishingHouse)
                        ]),
                        Row(
                          children: [
                            Text('Premiera: '),
                            Text(dateOfPremiere.substring(5, 16))
                          ],
                        ),
                        HowMuchStars(rate: rate.isNaN ? 0 : rate),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Flexible(child: Text(description)),
                ],
              ),
              if(widget.turnOpinions == true)...{
                for (int i =0;i< opinions.length; i++)
                  OpinionScreen(opinionId: opinions[i]),
              }
            ]),
          );
    }
  }

  Future<void> giveMeDetailsOfBook(String language, int bookId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    String apiUrl = apiURLGetBooksByGenres;

    final params = {'language': language, 'id': bookId.toString()};
    print(Uri.parse(apiUrl).replace(queryParameters: params));
    final response = await http
        .get(Uri.parse(apiUrl).replace(queryParameters: params), headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $actualToken',
    });
    Map<String, dynamic> data = jsonDecode(response.body);

    setState(() {
      final results = data['results'];
      title = results[0]['title'];
      description = results[0]['description'];
      isbn = results[0]['isbn'];
      dateOfPremiere = results[0]['premiere_date'];
      publishingHouse = results[0]['publishing_house'];
      picture = results[0]['picture'];
      authorId = results[0]['author_id'];
      rate = results[0]['score'] * 1.0 / results[0]['opinions_count'];
      opinions = results[0]['opinions'];
    });

    if (response.statusCode == 200) {
      print(data);
    } else {
      print("Nie okej :(");
    }

    Map<String, dynamic> authorData =
        await getSthById(language, apiURLGetAuthorById, actualToken!, authorId);
    setState(() {
      authorName = authorData['results'][0]['name'];
    });

    print('Imię autora $authorName i opinie $opinions');
  }
}

class HowMuchStars extends StatelessWidget {
  final double rate;

  const HowMuchStars({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    String halfStarString = (rate - rate.toInt()).toStringAsPrecision(2);
    double halfStar = double.parse(halfStarString);
    print('Ile gwiazdek? $rate, jaki wynik połówki? $halfStar');
    return Row(
      children: [
        if (rate == 0.0) ...[
          for (var i = 0; i < 5; i++) const Icon(Icons.star_border_rounded),
        ] else if (rate == 5.0) ...[
          for (var i = 0; i < 5; i++) const Icon(Icons.star_rounded),
        ] else ...[
          for (var i = 0; i < rate.toInt(); i++) Icon(Icons.star_rounded),
          if (halfStar >= 0.35 && halfStar <= 0.65) ...[
            Icon(Icons.star_half_rounded)
          ] else if (halfStar < 0.35) ...[
            Icon(Icons.star_border_rounded)
          ] else if (halfStar > 0.65) ...[
            Icon(Icons.star_rounded)
          ],
          for (var i = 0; i < 4 - rate.toInt(); i++)
            Icon(Icons.star_border_rounded),
        ],
        Text(rate.toString()),
      ],
    );
  }
}
