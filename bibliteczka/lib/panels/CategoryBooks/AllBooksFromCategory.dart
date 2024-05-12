import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/panels/Tools/LoadingScreen.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/NetworkLoadingImage.dart';
import 'DetailsOfBook.dart';

class AllCategoryBooksScreen extends StatefulWidget {
  const AllCategoryBooksScreen(
      {super.key,
      required this.nameOfCategory,
      required this.nameOfCategoryEN});

  final String nameOfCategory;
  final String nameOfCategoryEN;

  @override
  State<AllCategoryBooksScreen> createState() => _AllCategoryBooksScreenState();
}

class _AllCategoryBooksScreenState extends State<AllCategoryBooksScreen> {
  List<dynamic> listOfBooks = [
    -1,
  ];

  @override
  void initState() {
    super.initState();
    giveMeListsOfBook(widget.nameOfCategoryEN);
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    print(widget.nameOfCategory);
    if (listOfBooks.isEmpty) {
      return const LoadingScreen(message: nothingHere);
    } else if (listOfBooks[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(
          title: widget.nameOfCategory,
          automaticallyImplyLeading: true,
        ),
        body: GridView.builder(
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: heightScreen / 2.4+30),
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
                            context, CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child:
                            DetailsOfBookScreen(
                              bookId: listOfBooks[index]['id']
                            ))));
                      },
                      child: SizedBox(
                        width: widthScreen / 2.3,
                        height: heightScreen / 2.5,
                        child: NetworkLoadingImage(pathToImage: listOfBooks[index]['picture'])
                      ),
                    ),
                    SizedBox(
                      height: 30,
                      child: Text(listOfBooks[index]['title'],
                          style: Theme.of(context).textTheme.headlineSmall),
                    )
                  ]),
                ],
              );
            }),
      );
    }
  }

  Future<void> giveMeListsOfBook(String nameOfCategory) async {
    Map<String, dynamic> data = await getSthById(context, apiURLGetBooks, Map.of({'genres':nameOfCategory}));
    print('jaki rezulat? $data');

    setState(() {
      listOfBooks = data['results'];
    });
    print('number of books ${listOfBooks.length}');
  }
}
