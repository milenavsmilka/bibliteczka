import 'package:biblioteczka/panels/Authors/DetailsOfAutors.dart';
import 'package:biblioteczka/panels/Authors/PictureOfAuthor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:number_paginator/number_paginator.dart';

import '../../styles/strings.dart';
import '../Account/MyProfile.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/DefaultAppBar.dart';
import '../Tools/LoadingScreen.dart';
import '../Tools/functions.dart';

//todo paginacja dla książek w kategorii i w top i w komentarzach
//todo wyszukiwanie autorów i książek po lupie
//todo podobne książki
//todo dopracowanie themes
//todo shakeomat
//todo ogarnięcie ustawień użytkownika
class ChooseAuthorScreen extends StatefulWidget {
  const ChooseAuthorScreen({super.key});

  @override
  State<ChooseAuthorScreen> createState() => _ChooseAuthorScreenState();
}

class _ChooseAuthorScreenState extends State<ChooseAuthorScreen> {
  List<dynamic> listOfPopularAuthors = [-1];
  List<dynamic> listOfAuthors = [-1];
  List<dynamic> listOfKeyboard = [
    listOfAlphabet,
    listOfPolishSpecialChars,
    listOfCzechSpecialChars,
    listOfGermanySpecialChars
  ];
  List<dynamic> currentList = listOfAlphabet;
  int index = 0;
  int pagesCount = -1;
  int currentPage = -1;
  String letterThatWasClicked = 'A';
  List<dynamic> pages = [-1];

  @override
  void initState() {
    super.initState();
    giveMeListsOfTopAuthors();
    giveMeListsOfAuthors(1, 'A');
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if ((listOfPopularAuthors.isNotEmpty && listOfPopularAuthors[0] == -1) ||
        (listOfAuthors.isNotEmpty && listOfAuthors[0] == -1)) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
          appBar: DefaultAppBar(
            title: 'Autorzy',
            automaticallyImplyLeading: true,
            onTap: () {
              checkIsTokenValid(
                  context,
                  Navigator.push(
                          context,
                          CustomPageRoute(
                              chooseAnimation: CustomPageRoute.SLIDE, child: const MyProfileScreen()))
                      .then((value) => giveMeListsOfAuthors(currentPage, letterThatWasClicked)));
            },
          ),
          body: SingleChildScrollView(
            // padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Popularni autorzy', style: Theme.of(context).textTheme.headlineMedium),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  alignment: Alignment.center,
                  color: Theme.of(context).secondaryHeaderColor,
                  height: heightScreen / 4,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, mainAxisExtent: heightScreen / 5),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      if (listOfPopularAuthors.isEmpty) ...{
                        emptyBox(widthScreen, heightScreen),
                      } else ...{
                        for (int i = 0; i < listOfPopularAuthors.length; i++) ...{
                          PictureOfAuthor(
                            isEditingLibrary: false,
                            authorId: listOfPopularAuthors[i]['id'],
                            onPressed: () {
                              checkIsTokenValid(
                                  context,
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailsOfAuthorsScreen(
                                        authorId: listOfPopularAuthors[i]['id']),
                                  )));
                            },
                          ),
                        }
                      }
                    ],
                  ),
                ),
                const Text(''),
                Text('Alfabetycznie', style: Theme.of(context).textTheme.headlineMedium),
                Wrap(children: [
                  for (int i = 0; i < currentList.length; i++) ...{
                    SizedBox(
                        height: widthScreen * 0.1,
                        width: widthScreen * 0.1,
                        child: TextButton(
                          onPressed: () {
                            giveMeListsOfAuthors(1, currentList[i]);
                            letterThatWasClicked = currentList[i];
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Theme.of(context).cardColor),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              side: BorderSide(
                                  color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                            )),
                          ),
                          child: Text(currentList[i],
                              style: TextStyle(
                                  fontFamily: GoogleFonts.getFont('Proza Libre').fontFamily)),
                        )),
                  },
                  IconButton(
                      onPressed: () {
                        setState(() {
                          currentList = listOfKeyboard[++index % listOfKeyboard.length];
                        });
                      },
                      icon: const Icon(Icons.language, size: 30)),
                ]),
                SizedBox(
                  height: heightScreen / 3,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5, mainAxisExtent: heightScreen / 4),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      if (listOfAuthors.isEmpty) ...{
                        emptyBox(widthScreen, heightScreen),
                      } else ...{
                        for (int i = 0; i < listOfAuthors.length; i++) ...{
                          TextButton(
                              child: Text(listOfAuthors[i]['name']),
                              onPressed: () {
                                checkIsTokenValid(
                                    context,
                                    Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DetailsOfAuthorsScreen(authorId: listOfAuthors[i]['id']),
                                    )));
                              }),
                        }
                      }
                    ],
                  ),
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
                              giveMeListsOfAuthors(currentPage + 1, letterThatWasClicked);
                            });
                          },
                        )
                      }
                    ]),
              ],
            ),
          ));
    }
  }

  Future<void> giveMeListsOfAuthors(int page, String letter) async {
    Map<String, dynamic> data = await getSthById(
        context,
        apiURLGetAuthor,
        Map.of({
          'per_page': '10',
          'sorts': 'name',
          'name': letter,
          'page': page.toString(),
          'name_is_startswith': true.toString()
        }));

    setState(() {
      listOfAuthors = data['results'];
      pagesCount = data['pagination']['pages'];
      if (pagesCount != -1 && pagesCount != 0) {
        currentPage = 1;
        pages =
            List.generate(pagesCount, (index) => Center(child: Text('Page number:${index + 1}')));
      }
    });
    print('hej autorzy! ${listOfAuthors.length}');
  }

  Future<void> giveMeListsOfTopAuthors() async {
    Map<String, dynamic> data = await getSthById(
        context, apiURLGetAuthor, Map.of({'per_page': '10', 'sorts': '-fans_count'}));

    setState(() {
      listOfPopularAuthors = data['results'];
    });
    print('number of books ${listOfPopularAuthors.length}');
  }
}
