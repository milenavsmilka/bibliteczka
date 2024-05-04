import 'package:biblioteczka/panels/Tools/LoadingScreen.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBookScreen.dart';
import '../main.dart';

class NewBooksScreen extends StatefulWidget {
  const NewBooksScreen({super.key});

  @override
  State<NewBooksScreen> createState() => _NewBooksScreenState();
}

class _NewBooksScreenState extends State<NewBooksScreen> {
  List<dynamic> listOfBooks = [-1];

  @override
  initState() {
    super.initState();
    giveMeNewBooks();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print(listOfBooks);
    if (listOfBooks.isEmpty) {
      return const LoadingScreen(message: nothingHere);
    } else if (listOfBooks[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Nowości'),
        ),
        body: ListView.builder(
            itemCount: listOfBooks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () {
                    checkIsTokenValid(
                      context,
                      DetailsOfBookScreen(
                        bookId: listOfBooks[index]['id'],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SizedBox(
                        width: widthScreen / 2.3,
                        height: heightScreen / 2.5,
                        child: Image.network(listOfBooks[index]['picture'],
                            fit: BoxFit.fill),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(bookTitle,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                  textAlign: TextAlign.start),
                              Text(
                                (listOfBooks[index]['title']),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(bookAuthor,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall),
                              Column(
                                children: [
                                  if (listOfBooks[index]['authors_names']
                                          .length ==
                                      0) ...{
                                    Text(
                                      nothingHere,
                                      style:
                                          Theme.of(context).textTheme.titleSmall,
                                    )
                                  },
                                  for (int i = 0;
                                      i <
                                          (listOfBooks[index]['authors_names'])
                                              .length;
                                      i++) ...{
                                    if (i ==
                                        listOfBooks[index]['authors_names']
                                                .length -
                                            1) ...{
                                      Text(
                                        listOfBooks[index]['authors_names'][i]
                                            .toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    } else ...{
                                      Text(
                                        '${listOfBooks[index]['authors_names'][i]},',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      )
                                    }
                                  }
                                ],
                              ),
                              Text(bookPublishingHouse,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall),
                              Text(
                                listOfBooks[index]['publishing_house'],
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              Text(dateOfPremiere,
                                  style:
                                      Theme.of(context).textTheme.headlineSmall),
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
      );
    }
  }

  Future<void> giveMeNewBooks() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    DateTime date = DateTime(
        DateTime.now().year, DateTime.now().month - 3, DateTime.now().day);
    Map<String, dynamic> newBooksResponse = await getSthById(
        apiURLGetNewBooks, actualToken!, 'date_from', date.toString());

    setState(() {
      listOfBooks = newBooksResponse['results'];
    });
    print('number of listOfBooks ${listOfBooks.length}');
  }
}
