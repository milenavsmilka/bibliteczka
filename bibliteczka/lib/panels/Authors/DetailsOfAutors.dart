import 'package:biblioteczka/panels/Account/PictureOfBooksInMyLibrary.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/panels/Tools/NetworkLoadingImage.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBook.dart';
import '../Tools/IconsAnimation.dart';
import '../Tools/LoadingScreen.dart';

class DetailsOfAuthorsScreen extends StatefulWidget {
  const DetailsOfAuthorsScreen({super.key, required this.authorId});

  final String authorId;

  @override
  State<DetailsOfAuthorsScreen> createState() => _DetailsOfAuthorsScreenState();
}

class _DetailsOfAuthorsScreenState extends State<DetailsOfAuthorsScreen> {
  String biography = '';
  String name = '';
  int releasedBooksCount = -1;
  String picture = '';
  List<dynamic> genres = [nothingHere];
  List<dynamic> releasedBooks = [nothingHere];

  bool isHeartAnimating = false;
  bool emptyHeart = false;

  @override
  void initState() {
    super.initState();
    giveMeDetailsOfAuthors(widget.authorId);
    isThatAuthorInMyLibrary();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print('Picture $picture');

    if (biography.isEmpty) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(
          title: name,
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: IconsAnimation(
                              duration: Duration(milliseconds: 800),
                              child: emptyHeart
                                  ? Icon(
                                      Icons.favorite_border,
                                      color: Colors.white,
                                      size: 100,
                                    )
                                  : Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                              isAnimating: isHeartAnimating,
                              onEnd: () => setState(() {
                                isHeartAnimating = false;
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
                            // await sendRequest(apiURLBookFromFav, Map.of({'author_id': widget.authorId.toString()}));
                            // emptyHeart = true;
                          } on http.ClientException catch (e) {
                            //todo dodanie do ulubionych autorów
                            // print('wcale nie $e');
                            // deleteBooksFromMyLibrary(apiURLBookFromFav,
                            //     'book_id', widget.authorId.toString());
                            // emptyHeart=false;
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Autor: ', style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text('Liczba książek: ',
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            '$releasedBooksCount',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text('Pisze: ', style: Theme.of(context).textTheme.headlineSmall),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (genres.isEmpty) ...{
                                Text(
                                  nothingHere,
                                  style: Theme.of(context).textTheme.titleSmall,
                                )
                              },
                              for (int i = 0; i < genres.length; i++) ...{
                                if (i == genres.length - 1) ...{
                                  Text(
                                    genres[i].toString(),
                                    style: Theme.of(context).textTheme.titleSmall,
                                  )
                                } else ...{
                                  Text(
                                    '${genres[i]},',
                                    style: Theme.of(context).textTheme.titleSmall,
                                  )
                                }
                              }
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              const Row(children: [Text('')]),
              Row(
                children: [
                  Flexible(child: Text(biography, style: Theme.of(context).textTheme.titleSmall)),
                ],
              ),
              Center(child: Text('Wydane książki', style: Theme.of(context).textTheme.headlineMedium)),
              const Row(children: [Text('')]),
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
                      if (releasedBooks.isEmpty) ...{
                        emptyBox(widthScreen, heightScreen),
                      } else ...{
                        for (int i = 0; i < releasedBooks.length; i++) ...{
                          PictureOfBooksInMyLibrary(
                            bookId: releasedBooks[i],
                            isEditingLibrary: false,
                            categoryUrl: '',
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DetailsOfBookScreen(
                                    bookId: releasedBooks[i]),
                              ));
                            },
                          ),
                        }
                      }
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    }
  }

  Future<void> giveMeDetailsOfAuthors(String authorId) async {
    Map<String, dynamic> data =
        await getSthById(apiURLGetAuthor, Map.of({'id': authorId}));

    setState(() {
      final results = data['results'];
      biography = results[0]['biography'];
      name = results[0]['name'];
      genres = results[0]['genres'];
      picture = results[0]['picture'];
      releasedBooksCount = results[0]['released_books_count'];
      releasedBooks = results[0]['released_books'];
    });
    print('Imię autora $name i gatunki $genres');
  }

  Future<void> isThatAuthorInMyLibrary() async {
    Map<String, dynamic> getUserResponse =
        await getSthById(apiURLGetUser, Map.of({'get_self': 'true'}));

    List<dynamic> userData;
    List<dynamic> followedAuthors = [-1];
    setState(() {
      userData = getUserResponse['results'];
      followedAuthors = userData[0]['followed_authors'];
    });

    if (followedAuthors.contains(widget.authorId)) {
      emptyHeart = true;
    } else {
      emptyHeart = false;
    }
  }
}
