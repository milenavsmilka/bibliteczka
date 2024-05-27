import 'package:biblioteczka/panels/Tools/Loading.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/strings.dart';
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print(listOfUsers);
    if (listOfUsers.isEmpty) {
      return LoadingScreen(message: AppLocalizations.of(context)!.nothingHere);
    } else if (listOfUsers[0] == -1) {
      return LoadingScreen(message: AppLocalizations.of(context)!.loading);
    } else {
      return Scaffold(
        appBar: DefaultAppBar(title: AppLocalizations.of(context)!.community, automaticallyImplyLeading: true),
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
                                Text('${AppLocalizations.of(context)!.numberOfOpinions} ${listOfUsers[index]['opinions_count'].toString()}',
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
