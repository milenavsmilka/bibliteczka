import 'package:biblioteczka/panels/Tools/LoadingScreen.dart';
import 'package:biblioteczka/panels/Tools/NetworkLoadingImage.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../CategoryBooks/DetailsOfBook.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/DefaultAppBar.dart';

class PopularUsersScreen extends StatefulWidget {
  const PopularUsersScreen({super.key});

  @override
  State<PopularUsersScreen> createState() => _PopularUsersScreenState();
}

class _PopularUsersScreenState extends State<PopularUsersScreen> {
  List<dynamic> listOfUsers = [-1];

  @override
  initState() {
    super.initState();
    giveMePopularUsers();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print(listOfUsers);
    if (listOfUsers.isEmpty) {
      return const LoadingScreen(message: nothingHere);
    } else if (listOfUsers[0] == -1) {
      return const LoadingScreen(message: loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(title: 'Społeczność', automaticallyImplyLeading: true),
        body: ListView.builder(
            itemCount: listOfUsers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index+1}',style: Theme.of(context).textTheme.displaySmall),
                    Row(
                      children: [
                        SizedBox(
                          width: widthScreen / 2.3,
                          height: heightScreen / 4,
                          child: Image.asset(
                            setProfilePicture(listOfUsers[index]['profile_picture']),
                          )
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (listOfUsers[index]['username']),
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                Text('Liczba opinii: ${listOfUsers[index]['opinions_count'].toString()}',
                                    style: Theme.of(context).textTheme.headlineSmall),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }),
      );
    }
  }

  Future<void> giveMePopularUsers() async {
    Map<String, dynamic> usersResponse =
    await getSthById(context, apiURLGetUser, Map.of({
      'per_page': '10',
      'sorts': '-opinions_count',
      'opinions_count_ge': '1'
    }));

    setState(() {
      listOfUsers = usersResponse['results'];
    });
    print('number of users ${listOfUsers.length}');
  }
}
