import 'package:biblioteczka/panels/Authors/DetailsOfAutors.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBook.dart';
import 'CustomPageRoute.dart';
import 'NetworkLoadingImage.dart';
import 'functions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.whatSearch});

  final String whatSearch;
  static const String TURNAUTHORS = 'AUTHORS';
  static const String TURNBOOKS = 'BOOKS';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController(text: search);
  int pagesCount = -1;
  int currentPage = -1;
  List<dynamic> pages = [-1];
  List<dynamic> listOfBooks = [-1];
  List<dynamic> listOfAuthors = [-1];

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight + kBottomNavigationBarHeight);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          SizedBox(
              width: widthScreen / 2,
              child: TextFormField(
                cursorColor: Theme.of(context).textTheme.titleLarge?.color,
                style: Theme.of(context).textTheme.titleLarge,
                controller: searchController,
                decoration: const InputDecoration(
                    disabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none),
              )),
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 35,
            ),
            onPressed: () {
              setState(() {
                giveMeBooksByName(1, searchController.text);
              });
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.close,
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: heightScreen,
              child: (listOfBooks.isNotEmpty && listOfBooks[0] != -1)
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisExtent: heightScreen / 2 + 30),
                      padding: const EdgeInsets.all(10.0),
                      scrollDirection: Axis.vertical,
                      itemCount: listOfBooks.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(children: [
                              GestureDetector(
                                onTap: () {
                                  checkIsTokenValid(
                                      context,
                                      Navigator.push(
                                          context,
                                          CustomPageRoute(
                                              chooseAnimation: CustomPageRoute.SLIDE,
                                              child: widget.whatSearch == SearchScreen.TURNBOOKS
                                                  ? DetailsOfBookScreen(
                                                      bookId: listOfBooks[index]['id'])
                                                  : DetailsOfAuthorsScreen(
                                                      authorId: listOfAuthors[index]['id']))));
                                },
                                child: SizedBox(
                                    width: widthScreen / 2.3,
                                    height: heightScreen / 2.1,
                                    child: NetworkLoadingImage(
                                        pathToImage: widget.whatSearch == SearchScreen.TURNBOOKS
                                            ? listOfBooks[index]['picture']
                                            : listOfAuthors[index]['picture'])),
                              ),
                              SizedBox(
                                height: 30,
                                width: widthScreen / 2.3,
                                child: Center(
                                  child: Text(
                                      widget.whatSearch == SearchScreen.TURNBOOKS
                                          ? listOfBooks[index]['title']
                                          : listOfAuthors[index]['name'],
                                      style: Theme.of(context).textTheme.headlineSmall),
                                ),
                              ),
                            ]),
                          ],
                        );
                      })
                  : Center(
                      child: Text(AppLocalizations.of(context)!.nothingHere,
                          style: Theme.of(context).textTheme.titleLarge)),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pagesCount != -1 && pagesCount != 0) ...{
                    NumberPaginator(
                      config: NumberPaginatorUIConfig(
                          buttonSelectedBackgroundColor: Theme.of(context).primaryColor),
                      numberPages: pagesCount,
                      onPageChange: (index) {
                        setState(() {
                          currentPage = index;
                          giveMeBooksByName(currentPage + 1, searchController.text);
                        });
                      },
                    )
                  }
                ]),
          ],
        ),
      ),
    );
  }

  Future<void> giveMeBooksByName(int page, String textToSearch) async {
    Map<String, dynamic> data;
    widget.whatSearch == SearchScreen.TURNBOOKS
        ? data = await getSthById(
            context,
            apiURLGetBooks,
            Map.of({
              'title': textToSearch,
              'page': page.toString(),
            }))
        : data = await getSthById(
            context, apiURLGetAuthor, Map.of({'name': textToSearch, 'page': page.toString()}));

    print('jaki rezulat? $data');

    setState(() {
      listOfBooks = data['results'];
      listOfAuthors = data['results'];

      pagesCount = data['pagination']['pages'];
      if (pagesCount != -1 && pagesCount != 0) {
        currentPage = 1;
        pages =
            List.generate(pagesCount, (index) => Center(child: Text('Page number:${index + 1}')));
      }
    });
  }
}
