import 'package:biblioteczka/panels/Authors/DetailsOfAutors.dart';
import 'package:biblioteczka/panels/Authors/PictureOfAuthor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../styles/strings.dart';
import '../Account/PictureOfBooksInMyLibrary.dart';
import '../CategoryBooks/DetailsOfBookScreen.dart';
import '../Tools/DefaultAppBar.dart';
import '../Tools/Genres.dart';
import '../Tools/LoadingScreen.dart';
import '../Tools/functions.dart';

class ChooseAuthorScreen extends StatefulWidget {
  const ChooseAuthorScreen({super.key});

  @override
  State<ChooseAuthorScreen> createState() => _ChooseAuthorScreenState();
}

class _ChooseAuthorScreenState extends State<ChooseAuthorScreen> {
  List<dynamic> listOfPopularAuthors = [-1];

  @override
  void initState() {
    super.initState();
    giveMeListsOfTopAuthors();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if (listOfPopularAuthors.isEmpty) {
      return const LoadingScreen(message: nothingHere);
    } else if (listOfPopularAuthors[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
          appBar: DefaultAppBar(title: 'Autorzy', automaticallyImplyLeading: true),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Popularni autorzy', style: Theme.of(context).textTheme.headlineMedium),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: heightScreen / 4,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1, mainAxisExtent: heightScreen / 5, mainAxisSpacing: 20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        if (listOfPopularAuthors.isEmpty) ...{
                          SizedBox(
                            width: widthScreen / 5,
                            height: heightScreen / 5,
                            child: Text(nothingHere),
                          )
                        } else ...{
                          for (int i = 0; i < listOfPopularAuthors.length; i++) ...{
                            PictureOfAuthor(
                              authorId: listOfPopularAuthors[i]['id'],
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailsOfAuthorsScreen(
                                      authorId: listOfPopularAuthors[i]['id']),
                                ));
                              },
                            ),
                          }
                        }
                      ],
                    ),
                  ),
                ),
                Wrap(children: [
                  for (int i = 0; i < listOfAlphabet.length; i++) ...{
                    SizedBox(height: 38,width: 38,
                        child: TextButton(
                      onPressed: () {},
                      child: Text(listOfAlphabet[i]),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.orange),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0.0),
                              side: BorderSide(
                                  color: Theme.of(context).scaffoldBackgroundColor, width: 2),
                            )),

                      ),
                    )),
                  }
                ])
              ],
            ),
          ));
    }
  }

  // Future<void> giveMeUserData() async {
  //   Map<String, dynamic> getUserResponse =
  //       await getSthById(apiURLGetUser, Map.of({'get_self': 'true'}));
  //
  //   setState(() {
  //     userData = getUserResponse['results'];
  //     favBooks = userData[0]['library']['favourite_books'];
  //     readBooks = userData[0]['library']['read_books'];
  //   });
  // }

  Future<void> giveMeListsOfTopAuthors() async {
    Map<String, dynamic> data =
        await getSthById(apiURLGetAuthor, Map.of({'per_page': '10', 'sorts': '-fans_count'}));

    setState(() {
      listOfPopularAuthors = data['results'];
    });
    print('jaki rezulat? ${listOfPopularAuthors}');
    print('number of books ${listOfPopularAuthors.length}');
  }
}
