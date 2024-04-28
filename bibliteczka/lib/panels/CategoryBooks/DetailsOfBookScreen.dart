import 'dart:convert';

import 'package:biblioteczka/panels/CategoryBooks/OpinionScreen.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../LoadingScreen.dart';
import '../../styles/strings.dart';
import '../Tools/HowMuchStars.dart';
import '../functions.dart';
import '../main.dart';

class DetailsOfBookScreen extends StatefulWidget {
  const DetailsOfBookScreen(
      {super.key, required this.bookId, this.turnOpinions});

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
    giveMeDetailsOfBook(widget.bookId);
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if (authorName == '') {
      return const LoadingScreen();
    } else {
      return Scaffold(
        appBar: DefaultAppBar(
          title: title,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: widthScreen / 2.3,
                        height: heightScreen / 2.5,
                        child: Image.network(picture, fit: BoxFit.fill),
                      )
                    ],
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bookTitle,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall)
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  title,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                )
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bookAuthor,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall)
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  authorName,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                )
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(bookPublishingHouse,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall)
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  publishingHouse,
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
                                )
                              ]),
                          const Row(children: [Text('')]),
                          HowMuchStars(rate: rate.isNaN ? 0 : rate),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Row(children: [Text('')]),
              Row(
                children: [
                  Flexible(
                      child: Text(description,
                          style: Theme.of(context).textTheme.titleSmall)),
                ],
              ),
              const Row(children: [Text('')]),
              if (widget.turnOpinions == true) ...{
                Text(opinionsAndTalks,
                    style: Theme.of(context).textTheme.headlineSmall),
                const Row(children: [Text('')]),
                OpinionScreen(instruction: OpinionScreen.SEND,bookId: widget.bookId),
                for (int i = 0; i < opinions.length; i++)
                  OpinionScreen(
                      opinionId: opinions[i], instruction: OpinionScreen.LOAD,bookId: widget.bookId),
              }
            ]),
          ),
        ),
      );
    }
  }

  Future<void> giveMeDetailsOfBook(int bookId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    String apiUrl = apiURLGetBooksByGenres;

    final params = {'id': bookId.toString()};
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
      rate = results[0]['score'] * 1.0;
      opinions = results[0]['opinions'];
    });

    if (response.statusCode == 200) {
      print(data);
    } else {
      print("Nie okej :(");
    }

    Map<String, dynamic> authorData =
        await getSthById(apiURLGetAuthor, actualToken!, 'id', authorId.toString());
    setState(() {
      authorName = authorData['results'][0]['name'];
    });

    print('Imię autora $authorName i opinie $opinions');
  }
}
