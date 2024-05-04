import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../Tools/LoadingScreen.dart';
import '../Tools/functions.dart';
import '../main.dart';
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
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    giveMeUserData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (userData.isEmpty) {
      return const LoadingScreen(message: nothingHere);
    } else if (userData[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
          appBar: AppBar(
            title: Text('Mój profil'),
            automaticallyImplyLeading: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(8),
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
                        height: screenWidth * 0.35,
                        width: screenWidth * 0.35,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        children: [
                          Text('Cześć ${userData[0]['username']}!',
                              style:
                                  Theme.of(context).textTheme.headlineMedium),
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
                            Text(
                                userData[0]['library']['favourite_books_count']
                                    .toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Text(' Ulubione',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                                userData[0]['library']['read_books_count']
                                    .toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Text(' Przeczytane',
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
                            Text(
                                userData[0]['followed_authors_count']
                                    .toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Text(' Ulubionych autorów',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                        Row(
                          children: [
                            Text(userData[0]['opinions_count'].toString(),
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            Text(' Opinii',
                                style: Theme.of(context).textTheme.titleSmall),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Text(''),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Twoja Biblioteczka',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isEditing = !isEditing;
                          });
                        },
                        icon: SvgPicture.asset("assets/icons/pen.svg",
                            height: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.fontSize))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Ulubione',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: screenHeight / 4,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: screenHeight / 5,
                          mainAxisSpacing: 20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        if (favBooks.isEmpty) ...{
                          SizedBox(
                            width: screenWidth / 5,
                            height: screenHeight / 5,
                            child: Text(nothingHere),
                          )
                        } else ...{
                          for (int i = 0; i < favBooks.length; i++) ...{
                              PictureOfBooksInMyLibrary(
                                bookId: favBooks[i],
                                isEditingLibrary: isEditing,
                                categoryUrl: apiURLBookFromFav,
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
                      'Przeczytane',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    height: screenHeight / 4,
                    child: GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisExtent: screenHeight / 5,
                          mainAxisSpacing: 20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      children: [
                        if (readBooks.isEmpty) ...{
                          SizedBox(
                            width: screenWidth / 5,
                            height: screenHeight / 5,
                            child: Text(nothingHere),
                          )
                        } else ...{
                          for (int i = 0; i < readBooks.length; i++) ...{
                            PictureOfBooksInMyLibrary(
                              bookId: readBooks[i],
                              isEditingLibrary: isEditing,
                              categoryUrl: apiURLBookFromRead,
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
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);
    Map<String, dynamic> getUserResponse =
        await getSthById(apiURLGetUser, actualToken!, 'get_self', 'true');

    setState(() {
      userData = getUserResponse['results'];
      favBooks = userData[0]['library']['favourite_books'];
      readBooks = userData[0]['library']['read_books'];
    });
  }

  showChangeProfilePictureDialog() {
    double screenHeight = MediaQuery.of(context).size.height;
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return GridView(
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: screenHeight / 4),
            children: [
              for (int i = 1; i < 19; i++) ...{
                IconButton(
                  onPressed: () {
                    setState(() {
                      userData[0]['profile_picture'] = i;
                      changeProfilePicture(
                          apiURLChangeProfilePicture, 'profile_picture', i);
                      Navigator.pop(context);
                    });
                  },
                  icon: Image.asset(
                    setProfilePicture(i),
                  ),
                ),
              },
            ],
          );
        });
  }
}
