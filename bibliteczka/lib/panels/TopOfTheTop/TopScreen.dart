import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';

import '../CategoryBooks/DetailsOfBook.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/Genres.dart';
import '../Tools/HowMuchStars.dart';
import '../Tools/LoadingScreen.dart';
import '../Tools/NetworkLoadingImage.dart';
import '../Tools/functions.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({super.key});

  @override
  _TopScreen createState() => _TopScreen();
}

class _TopScreen extends State<TopScreen> {
  String genres = Genres.all.nameEN;
  List<dynamic> listOfBooks = [-1];
  int current = 0;

  @override
  void initState() {
    super.initState();
    giveMeListsOfBookToTop(Genres.all.nameEN);
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if (listOfBooks.isNotEmpty && listOfBooks[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(title: 'Top książki', automaticallyImplyLeading: true),
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
                                    genres=Genres.values[index].nameEN;
                                    giveMeListsOfBookToTop(Genres.values[index].nameEN);
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
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          Genres.values[index].name,
                                          style: TextStyle(
                                              color: current == index
                                                  ? Theme.of(context).appBarTheme.foregroundColor
                                                  : Theme.of(context).inputDecorationTheme.labelStyle?.color,
                                              fontSize:
                                                  Theme.of(context).textTheme.titleMedium?.fontSize,
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
                const Text(nothingHere)
              } else ...{
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, mainAxisExtent: heightScreen / 2.3),
                    scrollDirection: Axis.vertical,
                    physics: const ScrollPhysics(),
                    itemCount: listOfBooks.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                checkIsTokenValid(
                                    context,
                                    Navigator.push(
                                        context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: DetailsOfBookScreen(
                                        bookId: listOfBooks[index]['id']
                                    )))..then((value) => setState(() {
                                      giveMeListsOfBookToTop(genres);
                                    })),
                                );
                              },
                              child: SizedBox(
                                  width: widthScreen / 2.3,
                                  height: heightScreen / 2.5,
                                  child: NetworkLoadingImage(
                                      pathToImage: listOfBooks[index]['picture'])),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(listOfBooks[index]['title'],
                                              style: Theme.of(context).textTheme.headlineSmall),
                                          if (listOfBooks[index]['authors_names'].isEmpty) ...{
                                            Text(
                                              nothingHere,
                                              style: Theme.of(context).textTheme.titleSmall,
                                            )
                                          },
                                          for (int i = 0;
                                              i < listOfBooks[index]['authors_names'].length;
                                              i++) ...{
                                            if (i ==
                                                listOfBooks[index]['authors_names'].length - 1) ...{
                                              Text(
                                                listOfBooks[index]['authors_names'][i].toString(),
                                                style: Theme.of(context).textTheme.titleSmall,
                                              )
                                            } else ...{
                                              Text(
                                                '${listOfBooks[index]['authors_names'][i]},',
                                                style: Theme.of(context).textTheme.titleSmall,
                                              )
                                            }
                                          },
                                          Text(''),
                                          HowMuchStars(
                                              rate: (listOfBooks[index]['score'] * 1.0).isNaN
                                                  ? 0
                                                  : (listOfBooks[index]['score'] * 1.0)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('Ilość opinii: ${listOfBooks[index]['opinions_count']}',
                                            style: Theme.of(context).textTheme.titleSmall),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              }
            ],
          ),
        ),
      );
    }
  }

  Future<void> giveMeListsOfBookToTop(String nameOfCategory) async {
    Map<String, dynamic> data;
    if (nameOfCategory != Genres.all.nameEN) {
      data = await getSthById(
          context,apiURLGetBooks,
          Map.of({
            'genres': nameOfCategory,
            'per_page': '10',
            'minimum_score': '4',
            'sorts': '-opinions_count,-score'
          }));
    } else {
      data = await getSthById(
          context,apiURLGetBooks,
          Map.of({
            'per_page': '10',
            'minimum_score': '4',
            'sorts': '-opinions_count,-score'
          }));
    }
    setState(() {
      listOfBooks = data['results'];
    });
    print('jaki rezulat? $data');
    print('number of books ${listOfBooks.length}');
  }
}
