import 'package:biblioteczka/panels/Tools/Loading.dart';
import 'package:biblioteczka/panels/Tools/NetworkLoadingImage.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBook.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/DefaultAppBar.dart';

class NewBooksScreen extends StatefulWidget {
  const NewBooksScreen({super.key});

  @override
  State<NewBooksScreen> createState() => _NewBooksScreenState();
}

class _NewBooksScreenState extends State<NewBooksScreen> {
  List<dynamic> listOfBooks = [-1];
  int pagesCount = -1;
  int currentPage = -1;
  List<dynamic> pages = [-1];

  @override
  initState() {
    super.initState();
    giveMeNewBooks(1);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight + kBottomNavigationBarHeight);

    print(listOfBooks);
    if (listOfBooks.isEmpty) {
      return LoadingScreen(message: AppLocalizations.of(context)!.nothingHere);
    } else if (listOfBooks[0] == -1) {
      return LoadingScreen(message: AppLocalizations.of(context)!.loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(title: AppLocalizations.of(context)!.news, automaticallyImplyLeading: true),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: heightScreen,
                child: ListView.builder(
                    itemCount: listOfBooks.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: GestureDetector(
                          onTap: () {
                            checkIsTokenValid(
                              context,
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      chooseAnimation: CustomPageRoute.SLIDE,
                                      child: DetailsOfBookScreen(
                                        bookId: listOfBooks[index]['id'],
                                      ))),
                            );
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: widthScreen / 2.3,
                                height: heightScreen / 2.1,
                                child:
                                    NetworkLoadingImage(pathToImage: listOfBooks[index]['picture']),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(AppLocalizations.of(context)!.bookTitle,
                                          style: Theme.of(context).textTheme.headlineSmall,
                                          textAlign: TextAlign.start),
                                      Text(
                                        (listOfBooks[index]['title']),
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      Text(AppLocalizations.of(context)!.bookAuthors,
                                          style: Theme.of(context).textTheme.headlineSmall),
                                      Column(
                                        children: [
                                          if (listOfBooks[index]['authors_names'].length == 0) ...{
                                            Text(
                                              nothingHere,
                                              style: Theme.of(context).textTheme.titleSmall,
                                            )
                                          },
                                          for (int i = 0;
                                              i < (listOfBooks[index]['authors_names']).length;
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
                                          }
                                        ],
                                      ),
                                      Text(AppLocalizations.of(context)!.bookPublishingHouse,
                                          style: Theme.of(context).textTheme.headlineSmall),
                                      Text(
                                        listOfBooks[index]['publishing_house'],
                                        style: Theme.of(context).textTheme.titleSmall,
                                      ),
                                      Text(AppLocalizations.of(context)!.dateOfPremiere,
                                          style: Theme.of(context).textTheme.headlineSmall),
                                      Text(
                                        listOfBooks[index]['premiere_date'],
                                        style: Theme.of(context).textTheme.titleSmall,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (pagesCount != -1 && pagesCount != 0) ...{
                      NumberPaginator(
                        numberPages: pagesCount,
                        onPageChange: (index) {
                          setState(() {
                            currentPage = index;
                            giveMeNewBooks(currentPage + 1);
                          });
                        },
                      )
                    }
                  ])
            ],
          ),
        ),
      );
    }
  }

  Future<void> giveMeNewBooks(int page) async {
    DateTime date = DateTime(DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
    Map<String, dynamic> newBooksResponse = await getSthById(
        context,
        apiURLGetNewBooks,
        Map.of({
          'date_from': date.toString(),
          'page': page.toString(),
        }));

    setState(() {
      listOfBooks = newBooksResponse['results'];
      pagesCount = newBooksResponse['pagination']['pages'];
      if (pagesCount != -1 && pagesCount != 0) {
        currentPage = 1;
        pages =
            List.generate(pagesCount, (index) => Center(child: Text('Page number:${index + 1}')));
      }
    });
    print('number of listOfBooks ${listOfBooks.length}');
  }
}
