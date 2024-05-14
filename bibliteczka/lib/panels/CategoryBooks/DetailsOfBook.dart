import 'package:biblioteczka/panels/CategoryBooks/Opinion.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/panels/Tools/NetworkLoadingImage.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import '../Account/MyProfile.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/HowMuchStars.dart';
import '../Tools/Icons.dart';
import '../Tools/IconsAnimation.dart';
import '../Tools/LoadingScreen.dart';

class DetailsOfBookScreen extends StatefulWidget {
  const DetailsOfBookScreen({super.key, required this.bookId});

  final String bookId;

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
  int countOfPages = 0;
  List<dynamic> opinions = [];
  List<dynamic> authorsNames = [nothingHere];
  double rate = 1.0;

  bool isHeartAnimating = false;
  bool emptyHeart = false;
  bool isReadAnimating = false;
  bool emptyRead = false;

  String username = '-1';

  @override
  void initState() {
    super.initState();
    giveMeDetailsOfBook(widget.bookId);
    isThatBookInMyLibrary();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print('Picture $picture');

    if (title.isEmpty) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(
            title: title,
            automaticallyImplyLeading: true,
            onTap: () {
              checkIsTokenValid(
                  context,
                  Navigator.push(
                          context,
                          CustomPageRoute(
                              chooseAnimation: CustomPageRoute.SLIDE,
                              child: const MyProfileScreen()))
                      .then((value) => isThatBookInMyLibrary()));
            }),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        child: Stack(children: [
                          SizedBox(
                            width: widthScreen / 2.3,
                            height: heightScreen / 2.5,
                            child: NetworkLoadingImage(pathToImage: picture),
                          ),
                          Opacity(
                            opacity: isHeartAnimating ? 1 : 0,
                            child: SizedBox(
                              width: widthScreen / 2.3,
                              height: heightScreen / 2.5,
                              child: Align(
                                alignment: Alignment.center,
                                child: IconsAnimation(
                                  duration: const Duration(milliseconds: 800),
                                  isAnimating: isHeartAnimating,
                                  onEnd: () => setState(() {
                                    isHeartAnimating = false;
                                  }),
                                  child: emptyHeart ? deleteFromFavIcon(100) : addToFavIcon(100),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: isReadAnimating ? 1 : 0,
                            child: SizedBox(
                              width: widthScreen / 2.3,
                              height: heightScreen / 2.5,
                              child: Align(
                                alignment: Alignment.center,
                                child: IconsAnimation(
                                  duration: const Duration(milliseconds: 800),
                                  isAnimating: isReadAnimating,
                                  onEnd: () => setState(() {
                                    isReadAnimating = false;
                                  }),
                                  child: emptyRead ? deleteFromReadIcon(100) : addToReadIcon(100),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widthScreen / 2.3,
                            height: heightScreen / 2.5,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                icon: emptyRead ? deleteFromReadIcon(45) : addToReadIcon(45),
                                onPressed: () async {
                                  try {
                                    await sendRequest(apiURLBookFromRead,
                                        Map.of({'book_id': widget.bookId.toString()}), context);
                                    setState(() {
                                      emptyRead = true;
                                    });
                                  } on http.ClientException catch (e) {
                                    print('wcale nie $e');
                                    await deleteSth(context, apiURLBookFromRead, Map.of({'book_id':
                                      widget.bookId.toString()}));
                                    setState(() {
                                      emptyRead = false;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widthScreen / 2.3,
                            height: heightScreen / 2.5,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: IconButton(
                                  icon: !emptyHeart ? deleteFromFavIcon(45) : addToFavIcon(45),
                                  onPressed: () async {
                                    try {
                                      await sendRequest(apiURLBookFromFav,
                                          Map.of({'book_id': widget.bookId.toString()}), context);
                                      setState(() {
                                        emptyHeart = true;
                                      });
                                    } on http.ClientException catch (e) {
                                      print('wcale nie $e');
                                      await deleteSth(context, apiURLBookFromFav,
                                          Map.of({'book_id': widget.bookId.toString()}));
                                      setState(() {
                                        emptyHeart = false;
                                      });
                                    }
                                  }),
                            ),
                          ),
                        ]),
                        onDoubleTap: () async {
                          print('dodaje $isHeartAnimating');
                          setState(() {
                            isHeartAnimating = true;
                          });
                          try {
                            await sendRequest(apiURLBookFromFav,
                                Map.of({'book_id': widget.bookId.toString()}), context);
                            emptyHeart = true;
                          } on http.ClientException catch (e) {
                            print('wcale nie $e');
                            await deleteSth(
                                context, apiURLBookFromFav, Map.of({'book_id': widget.bookId.toString()}));
                            emptyHeart = false;
                          }
                        },
                        onLongPress: () async {
                          print('dodaje $isReadAnimating');
                          setState(() {
                            isReadAnimating = true;
                          });
                          try {
                            await sendRequest(apiURLBookFromRead,
                                Map.of({'book_id': widget.bookId.toString()}), context);
                            emptyRead = true;
                          } on http.ClientException catch (e) {
                            print('wcale nie $e');
                            await deleteSth(
                                context, apiURLBookFromRead, Map.of({'book_id': widget.bookId.toString()}));
                            emptyRead = false;
                          }
                        },
                      ),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bookTitle, style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(bookAuthor, style: Theme.of(context).textTheme.headlineSmall),
                          Column(
                            children: [
                              if (authorsNames.isEmpty) ...{
                                Text(
                                  nothingHere,
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              },
                              for (int i = 0; i < authorsNames.length; i++) ...{
                                if (i == authorsNames.length - 1) ...{
                                  Text(
                                    authorsNames[i].toString(),
                                    style: Theme.of(context).textTheme.titleSmall,
                                  )
                                } else ...{
                                  Text(
                                    '${authorsNames[i]},',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  )
                                }
                              }
                            ],
                          ),
                          Text(bookPublishingHouse,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            publishingHouse,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          if (countOfPages != 0) ...{
                            Text(numberOfPages, style: Theme.of(context).textTheme.headlineSmall),
                            Text(
                              countOfPages.toString(),
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          },
                          const Row(children: [Text('')]),
                          HowMuchStars(rate: rate.isNaN ? 0 : rate),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Row(children: [Text('')]),
              if (description != '') ...{
                Row(
                  children: [
                    Flexible(
                        child: Text(description, style: Theme.of(context).textTheme.titleSmall)),
                  ],
                )
              },
              const Row(children: [Text('')]),
              Text(opinionsAndTalks, style: Theme.of(context).textTheme.headlineSmall),
              const Row(children: [Text('')]),
              OpinionScreen(instruction: OpinionScreen.SEND, bookId: widget.bookId),
              for (int i = 0; i < opinions.length; i++)
                OpinionScreen(
                    opinionId: opinions[i],
                    instruction: OpinionScreen.LOAD,
                    bookId: widget.bookId,
                    currentUsername: username),
            ]),
          ),
        ),
      );
    }
  }

  Future<void> giveMeDetailsOfBook(String bookId) async {
    Map<String, dynamic> data = await getSthById(context, apiURLGetBooks, Map.of({'id': bookId}));

    setState(() {
      final results = data['results'];
      title = results[0]['title'];
      isbn = results[0]['isbn'];
      dateOfPremiere = results[0]['premiere_date'];
      publishingHouse = results[0]['publishing_house'];
      picture = results[0]['picture'];
      authorsNames = results[0]['authors_names'];
      rate = results[0]['score'] * 1.0;
      opinions = results[0]['opinions'];
      if (results[0]['description'] != null) description = results[0]['description'];
      if (results[0]['number_of_pages'] != null) countOfPages = results[0]['number_of_pages'];
    });
    print('Imię autora $authorsNames i opinie $opinions');
  }

  Future<void> isThatBookInMyLibrary() async {
    Map<String, dynamic> getUserResponse =
        await getSthById(context, apiURLGetUser, Map.of({'get_self': 'true'}));

    List<dynamic> userData;
    List<dynamic> favBooks = [-1];
    List<dynamic> readBooks = [-1];
    setState(() {
      userData = getUserResponse['results'];
      favBooks = userData[0]['library']['favourite_books'];
      readBooks = userData[0]['library']['read_books'];
      username = userData[0]['username'];
    });

    if (favBooks.contains(widget.bookId)) {
      emptyHeart = true;
    } else {
      emptyHeart = false;
    }

    if (readBooks.contains(widget.bookId)) {
      emptyRead = true;
    } else {
      emptyRead = false;
    }
  }
}
