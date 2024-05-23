import 'package:biblioteczka/panels/Authors/ChooseAuthor.dart';
import 'package:biblioteczka/panels/Community/PopularUsers.dart';
import 'package:biblioteczka/panels/News/NewBooks.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../styles/ThemeProvider.dart';
import 'CategoryBooks/ChooseCategory.dart';
import 'Tools/CustomPageRoute.dart';
import 'Tools/functions.dart';
import 'TopOfTheTop/TopScreen.dart';

class MainPanelScreen extends StatefulWidget {
  const MainPanelScreen({super.key});

  @override
  _MainPanelScreen createState() => _MainPanelScreen();
}

class _MainPanelScreen extends State<MainPanelScreen> {
  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(exitFromAppTitle),
                content: const Text(exitFromAppQuestion),
                actions: [
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text(yes)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text(no),
                  ),
                ],
              );
            },
          );
          return Future.value(shouldPop);
        },
        child: const Scaffold(
            appBar: DefaultAppBar(title: library, automaticallyImplyLeading: false),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: category, widgetToRoute: ChooseCategoryScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: news, widgetToRoute: NewBooksScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: top10Books, widgetToRoute: TopScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: authors, widgetToRoute: ChooseAuthorScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: community, widgetToRoute: PopularUsersScreen()),
              ],
            )),
      );

  @override
  void initState() {
    super.initState();
    setTheme();
  }

  Future<void> setTheme() async {
    Map<String, dynamic> themeData =
        await getSthById(context, apiURLGetUser, Map.of({"get_self": true.toString()}));
    final themeState = Provider.of<ThemeProvider>(context, listen: false);
    setState(() {
      themeState.setAnotherTheme = themeData['results'][0]['theme'];
    });
  }
}

class ChooseOptionFromMenuButton extends StatelessWidget {
  final String nameOfOptionFromMenu;
  final Widget widgetToRoute;

  const ChooseOptionFromMenuButton({
    super.key,
    required this.nameOfOptionFromMenu,
    required this.widgetToRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(95),
        ),
        child: Text(
          nameOfOptionFromMenu,
        ),
        onPressed: () {
          checkIsTokenValid(
              context,
              Navigator.push(context,
                  CustomPageRoute(chooseAnimation: CustomPageRoute.SLIDE, child: widgetToRoute)));
        },
      ),
    );
  }
}
