import 'package:biblioteczka/panels/Authors/DetailsOfAutors.dart';
import 'package:biblioteczka/panels/Authors/PictureOfAuthor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBook.dart';
import '../Tools/Loading.dart';
import '../Tools/functions.dart';
import 'PictureOfBooksInMyLibrary.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  List<dynamic> userData = [-1];
  List<dynamic> favBooks = [-1];
  List<dynamic> readBooks = [-1];
  List<dynamic> similarBooks = [-1];
  List<dynamic> favAuthors = [-1];
  int userId = -1;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    giveMeUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if (userData.isEmpty) {
      return LoadingScreen(message: AppLocalizations.of(context)!.nothingHere);
    } else if (userData[0] == -1) {
      return LoadingScreen(message: AppLocalizations.of(context)!.loading);
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.myProfile),
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        showChangeProfilePictureDialog();
                      },
                      icon: Image.asset(
                        setProfilePicture(userData[0]['profile_picture']),
                        height: widthScreen * 0.35,
                        width: widthScreen * 0.35,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Text('${AppLocalizations.of(context)!.hello} ${userData[0]['username']}!',
                              style: Theme.of(context).textTheme.headlineMedium),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(userData[0]['library']['favourite_books_count'].toString(),
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text(' ${AppLocalizations.of(context)!.favourite}',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        Row(
                          children: [
                            Text(userData[0]['library']['read_books_count'].toString(),
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text(' ${AppLocalizations.of(context)!.read}',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(userData[0]['followed_authors_count'].toString(),
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text(' ${AppLocalizations.of(context)!.favouriteAuthors}',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        Row(
                          children: [
                            Text(userData[0]['opinions_count'].toString(),
                                style: Theme.of(context).textTheme.headlineSmall),
                            Text(' ${AppLocalizations.of(context)!.opinions}',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Text(''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.myLibrary,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        icon: SvgPicture.asset("assets/icons/pen.svg",
                            height: Theme.of(context).textTheme.headlineSmall?.fontSize))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.favourite,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
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
                        if (favBooks.isEmpty) ...{
                          emptyBox(widthScreen, heightScreen, context),
                        } else ...{
                          for (int i = 0; i < favBooks.length; i++) ...{
                            PictureOfBooksInMyLibrary(
                              bookId: favBooks[i],
                              isEditingLibrary: isEditing,
                              categoryUrl: apiURLBookFromFav,
                              onPressed: () {
                                checkIsTokenValid(
                                    context,
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsOfBookScreen(bookId: favBooks[i]),
                                        ))
                                        .then((value) => setState(() {
                                              giveMeUserData();
                                            })));
                              },
                            ),
                          }
                        }
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.read,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
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
                        if (readBooks.isEmpty) ...{
                          emptyBox(widthScreen, heightScreen, context),
                        } else ...{
                          for (int i = 0; i < readBooks.length; i++) ...{
                            PictureOfBooksInMyLibrary(
                              bookId: readBooks[i],
                              isEditingLibrary: isEditing,
                              categoryUrl: apiURLBookFromRead,
                              onPressed: () {
                                checkIsTokenValid(
                                    context,
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsOfBookScreen(bookId: readBooks[i]),
                                        ))
                                        .then((value) => setState(() {
                                              giveMeUserData();
                                            })));
                              },
                            ),
                          }
                        }
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.authors,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
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
                        if (favAuthors.isEmpty) ...{
                          emptyBox(widthScreen, heightScreen, context),
                        } else ...{
                          for (int i = 0; i < favAuthors.length; i++) ...{
                            PictureOfAuthor(
                              authorId: favAuthors[i],
                              isEditingLibrary: isEditing,
                              userId: userId,
                              onPressed: () {
                                checkIsTokenValid(
                                    context,
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsOfAuthorsScreen(authorId: favAuthors[i]),
                                        ))
                                        .then((value) => setState(() {
                                              giveMeUserData();
                                            })));
                              },
                            ),
                          }
                        }
                      ],
                    ),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.mayBeInterestedForYou,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
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
                        if (similarBooks.isEmpty) ...{
                          emptyBox(widthScreen, heightScreen, context),
                        } else ...{
                          for (int i = 0; i < similarBooks.length; i++) ...{
                            PictureOfBooksInMyLibrary(
                              bookId: similarBooks[i]['id'],
                              isEditingLibrary: false,
                              categoryUrl: '',
                              onPressed: () {
                                checkIsTokenValid(
                                    context,
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsOfBookScreen(bookId: similarBooks[i]['id']),
                                        ))
                                        .then((value) => setState(() {
                                              giveMeUserData();
                                            })));
                              },
                            ),
                          }
                        }
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ));
    }
  }

  Future<void> giveMeUserData() async {
    Map<String, dynamic> getUserResponse =
        await getSthById(context, apiURLGetUser, Map.of({'get_self': 'true'}));

    if (!mounted) return;
    Map<String, dynamic> getSimilarBooks =
        await getSthById(context, apiURLSimilarBooks, Map.of({}));
    print(getSimilarBooks['results']);
    setState(() {
      userData = getUserResponse['results'];
      favBooks = userData[0]['library']['favourite_books'];
      readBooks = userData[0]['library']['read_books'];
      similarBooks = getSimilarBooks['results'];
      favAuthors = userData[0]['followed_authors'];
      userId = userData[0]['id'];
    });
  }

  showChangeProfilePictureDialog() {
    double heightScreen = MediaQuery.of(context).size.height;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return Container(
            color: Colors.grey.withAlpha(60),
            child: GridView(
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: heightScreen / 4),
              children: [
                for (int i = 1; i < 19; i++) ...{
                  IconButton(
                    onPressed: () {
                      setState(() {
                        userData[0]['profile_picture'] = i;
                        changeSthInMyAccount(
                            context, apiURLChangeProfilePicture, Map.of({'profile_picture': i}));
                        Navigator.pop(context);
                      });
                    },
                    icon: Image.asset(
                      setProfilePicture(i),
                    ),
                  ),
                },
              ],
            ),
          );
        });
  }
}
