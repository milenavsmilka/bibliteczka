import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../Tools/LoadingScreen.dart';
import '../functions.dart';
import '../main.dart';
import 'PictureOfFavBooks.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  List<dynamic> userData = [-1];
  List<dynamic> favBooks = [-1];
  List<dynamic> readBooks = [-1];

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
                          Row(
                            children: [
                              Text(
                                  userData[0]['library']
                                          ['favourite_books_count']
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text(' Ulubione',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  userData[0]['library']['read_books_count']
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text(' Przeczytane',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                  userData[0]['followed_authors_count']
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text(' Ulubionych autorów',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                          Row(
                            children: [
                              Text(userData[0]['opinions_count'].toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall),
                              Text(' Opinii',
                                  style:
                                      Theme.of(context).textTheme.titleSmall),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(''),
                Text(
                  'Twoja Biblioteczka',
                  style: Theme.of(context).textTheme.headlineMedium,
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
                SizedBox(
                  height: screenHeight / 4,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: screenHeight / 5,
                        mainAxisSpacing: 20),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      if (favBooks.length == 0) ...{
                        SizedBox(
                          width: screenWidth / 5,
                          height: screenHeight / 5,
                          child: Text(nothingHere),
                        )
                      } else ...{
                        for (int i = 0; i < favBooks.length; i++) ...{
                          PictureOfFavBooks(bookId: favBooks[i]),
                        }
                      }
                    ],
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
                SizedBox(
                  height: screenHeight / 4,
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisExtent: screenHeight / 5,
                        mainAxisSpacing: 20),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    children: [
                      if (readBooks.length == 0) ...{
                        SizedBox(
                          width: screenWidth / 5,
                          height: screenHeight / 5,
                          child: Text(nothingHere),
                        )
                      } else ...{
                        for (int i = 0; i < readBooks.length; i++) ...{
                          PictureOfFavBooks(bookId: readBooks[i]),
                        }
                      }
                    ],
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
