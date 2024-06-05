import 'package:biblioteczka/panels/Account/PictureOfBooksInMyLibrary.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/panels/Tools/Icons.dart';
import 'package:biblioteczka/panels/Tools/NetworkLoadingImage.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/strings.dart';
import '../Account/MyProfile.dart';
import '../CategoryBooks/DetailsOfBook.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/IconsAnimation.dart';
import '../Tools/Loading.dart';

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
  String dateOfBirth = '';
  String dateOfDead = '';
  String authorsWebsite = '';
  int userId = -1;
  List<dynamic> genres = [nothingHere];
  List<dynamic> releasedBooks = [nothingHere];

  bool isHeartAnimating = false;
  bool emptyHeart = false;

  var showAll = false;
  final length = lengthToShow + 150;

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

    if (biography.isEmpty) {
      return LoadingScreen(message: AppLocalizations.of(context)!.loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(
          title: name,
          automaticallyImplyLeading: true,
          onTap: () {
            checkIsTokenValid(
                context,
                Navigator.push(
                    context,
                    CustomPageRoute(
                        chooseAnimation: CustomPageRoute.SLIDE, child: const MyProfileScreen())));
          },
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
                            child: SizedBox(
                              width: widthScreen / 2.3,
                              height: heightScreen / 2.5,
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
                          SizedBox(
                            width: widthScreen / 2.3,
                            height: heightScreen / 2.5,
                            child: Align(
                              alignment: Alignment.bottomLeft,
                              child: IconButton(
                                  icon: !emptyHeart ? deleteFromFavIcon(45) : addToFavIcon(45),
                                  onPressed: () async {
                                    try {
                                      await sendRequest(
                                          apiURLFan,
                                          Map.of({
                                            'user_id': userId,
                                            'author_id': widget.authorId.toString()
                                          }),
                                          context);
                                      setState(() {
                                        emptyHeart = true;
                                      });
                                    } on http.ClientException catch (e) {
                                      print('wcale nie $e');
                                      deleteSth(
                                          context,
                                          apiURLFan,
                                          Map.of({
                                            'user_id': userId,
                                            'author_id': widget.authorId.toString()
                                          }));
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
                            await sendRequest(
                                apiURLFan,
                                Map.of(
                                    {'user_id': userId, 'author_id': widget.authorId.toString()}),
                                context);
                            emptyHeart = true;
                          } on http.ClientException {
                            deleteSth(
                                context,
                                apiURLFan,
                                Map.of(
                                    {'user_id': userId, 'author_id': widget.authorId.toString()}));
                            emptyHeart = false;
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
                          Text(AppLocalizations.of(context)!.authorTitle, style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            name,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          if (dateOfBirth != '') ...{
                            Text(AppLocalizations.of(context)!.dateOfBirthTitle,
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text(
                              dateOfBirth,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            if (dateOfDead != '') ...{
                              Text(AppLocalizations.of(context)!.dateOfDeadTitle,
                                  style: Theme.of(context).textTheme.headlineSmall),
                              Text(
                                dateOfDead,
                                style: Theme.of(context).textTheme.titleSmall,
                              )
                            },
                          },
                          if (authorsWebsite != '') ...{
                            Text(AppLocalizations.of(context)!.authorsWebsiteTitle,
                                style: Theme.of(context).textTheme.headlineSmall),
                            GestureDetector(
                              child: Text(
                                'LINK',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              onTap: () {
                                _launchUrl(authorsWebsite);
                              },
                            )
                          },
                          Text(AppLocalizations.of(context)!.numberOfBooksTitle,
                              style: Theme.of(context).textTheme.headlineSmall),
                          Text(
                            '$releasedBooksCount',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Text(AppLocalizations.of(context)!.writesGenresTitle, style: Theme.of(context).textTheme.headlineSmall),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (genres.isEmpty) ...{
                                Text(
                                  AppLocalizations.of(context)!.nothingHere,
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
                  Flexible(
                    child: Text.rich(TextSpan(
                      children: <InlineSpan>[
                        TextSpan(
                            text: biography.length > length && !showAll
                                ? "${biography.substring(0, length)}..."
                                : biography,
                            style: Theme.of(context).textTheme.titleSmall),
                        biography.length > length
                            ? WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showAll = !showAll;
                              });
                            },
                            child: Text(
                              showAll
                                  ? AppLocalizations.of(context)!.showLess
                                  : AppLocalizations.of(context)!.showMore,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        )
                            : const TextSpan(),
                      ],
                    )),
                  )
                ],
              ),
              Center(
                  child: Text(AppLocalizations.of(context)!.releasedBooksTitle, style: Theme.of(context).textTheme.headlineMedium)),
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
                        emptyBox(widthScreen, heightScreen, context),
                      } else ...{
                        for (int i = 0; i < releasedBooks.length; i++) ...{
                          PictureOfBooksInMyLibrary(
                            bookId: releasedBooks[i],
                            isEditingLibrary: false,
                            categoryUrl: '',
                            onPressed: () {
                              checkIsTokenValid(
                                  context,
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsOfBookScreen(bookId: releasedBooks[i]),
                                  )));
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
        await getSthById(context, apiURLGetAuthor, Map.of({'id': authorId}));

    setState(() {
      final results = data['results'];
      name = results[0]['name'];
      genres = results[0]['genres'];
      picture = results[0]['picture'];
      releasedBooksCount = results[0]['released_books_count'];
      releasedBooks = results[0]['released_books'];

      if (results[0]['biography'] != null) biography = results[0]['biography'];
      if (results[0]['birth_date'] != null) dateOfBirth = results[0]['birth_date'];
      if (results[0]['death_date'] != null) dateOfDead = results[0]['death_date'];
      if (results[0]['website'] != null) authorsWebsite = results[0]['website'];
    });
    print('Imię autora $name i gatunki $genres');
  }

  Future<void> isThatAuthorInMyLibrary() async {
    Map<String, dynamic> getUserResponse =
        await getSthById(context, apiURLGetUser, Map.of({'get_self': 'true'}));

    List<dynamic> userData;
    List<dynamic> followedAuthors = [-1];
    setState(() {
      userData = getUserResponse['results'];
      followedAuthors = userData[0]['followed_authors'];
      userId = userData[0]['id'];
    });

    if (followedAuthors.contains(widget.authorId)) {
      emptyHeart = true;
    } else {
      emptyHeart = false;
    }
  }

  Future<void> _launchUrl(url) async {
    final Uri url2 = Uri.parse(url);
    if (!await launchUrl(url2)) {
      throw Exception(url2);
    }
  }
}
