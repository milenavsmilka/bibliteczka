import 'package:biblioteczka/panels/CategoryBooks/OpinionScreen.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/panels/Tools/NetworkLoadingImage.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import '../Tools/HowMuchStars.dart';
import '../Tools/IconsAnimation.dart';
import '../Tools/LoadingScreen.dart';

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
  List<dynamic> opinions = [];
  List<dynamic> authorsNames = [nothingHere];
  double rate = 1.0;

  bool isHeartAnimating = false;
  bool emptyHeart = false;
  bool isReadAnimating = false;
  bool emptyRead = false;

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
        ),
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
                            child: NetworkLoadingImage(pathToImage: picture),//todo problem z wywalaniem błędu
                          ),
                          Opacity(
                            opacity: isHeartAnimating ? 1 : 0,
                            child: IconsAnimation(
                              duration: Duration(milliseconds: 800),
                              child: emptyHeart ? Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                                size: 100,
                              ): Icon(Icons.favorite,
                              color: Colors.white,
                              size: 100,
                              ),
                              isAnimating: isHeartAnimating,
                              onEnd: () => setState(() {
                                isHeartAnimating = false;
                              }),
                            ),
                          ),
                          Opacity(
                            opacity: isReadAnimating ? 1 : 0,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconsAnimation(
                                duration: Duration(milliseconds: 800),
                                child: emptyRead ? Icon(
                                  Icons.remove_circle,
                                  color: Colors.redAccent,
                                  size: 100,
                                ): Icon(Icons.add_circle,
                                  color: Colors.greenAccent,
                                  size: 100,
                                ),
                                isAnimating: isReadAnimating,
                                onEnd: () => setState(() {
                                  isReadAnimating = false;
                                }),
                              ),
                            ),
                          )
                        ]),
                        onDoubleTap: () async {
                          print('dodaje $isHeartAnimating');
                          setState(() {
                            isHeartAnimating = true;
                          });
                          try{
                            await sendRequest(apiURLBookFromFav, Map.of({'book_id': widget.bookId.toString()}));
                            emptyHeart = true;
                          } on http.ClientException catch(e){
                            print('wcale nie $e');
                            deleteBooksFromMyLibrary(apiURLBookFromFav,
                                'book_id', widget.bookId.toString());
                            emptyHeart=false;
                          }
                        },
                        onLongPress: () async {
                          print('dodaje $isReadAnimating');
                          setState(() {
                            isReadAnimating = true;
                          });
                          try{
                            await sendRequest(apiURLBookFromRead,Map.of({'book_id': widget.bookId.toString()}));
                            emptyRead = true;
                          } on http.ClientException catch(e){
                            print('wcale nie $e');
                            deleteBooksFromMyLibrary(apiURLBookFromRead,
                                'book_id', widget.bookId.toString());
                            emptyRead=false;
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
                          Text(bookTitle,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(bookAuthor,
                              style: Theme.of(context).textTheme.headlineSmall),
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
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  )
                                } else ...{
                                  Text(
                                    '${authorsNames[i]},',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
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
                OpinionScreen(
                    instruction: OpinionScreen.SEND, bookId: widget.bookId),
                for (int i = 0; i < opinions.length; i++)
                  OpinionScreen(
                      opinionId: opinions[i],
                      instruction: OpinionScreen.LOAD,
                      bookId: widget.bookId),
              }
            ]),
          ),
        ),
      );
    }
  }

  Future<void> giveMeDetailsOfBook(int bookId) async {
    Map<String, dynamic> data = await getSthById(apiURLGetBooks, Map.of({'id':bookId.toString()}));

    setState(() {
      final results = data['results'];
      title = results[0]['title'];
      description = results[0]['description'];
      isbn = results[0]['isbn'];
      dateOfPremiere = results[0]['premiere_date'];
      publishingHouse = results[0]['publishing_house'];
      picture = results[0]['picture'];
      authorsNames = results[0]['authors_names'];
      rate = results[0]['score'] * 1.0;
      opinions = results[0]['opinions'];
    });
    print('Imię autora $authorsNames i opinie $opinions');
  }


  Future<void> isThatBookInMyLibrary() async {
    Map<String, dynamic> getUserResponse =
    await getSthById(apiURLGetUser, Map.of({'get_self': 'true'}));

    List<dynamic> userData;
    List<dynamic> favBooks = [-1];
    List<dynamic> readBooks = [-1];
    setState(() {
      userData = getUserResponse['results'];
      favBooks = userData[0]['library']['favourite_books'];
      readBooks = userData[0]['library']['read_books'];
    });

    if(favBooks.contains(widget.bookId)) {
      emptyHeart= true;
    } else {
      emptyHeart = false;
    }

    if(readBooks.contains(widget.bookId)) {
      emptyRead= true;
    } else {
      emptyRead = false;
    }
  }
}
