import 'package:biblioteczka/panels/Authors/ChooseAuthor.dart';
import 'package:biblioteczka/panels/Community/PopularUsers.dart';
import 'package:biblioteczka/panels/News/NewBooks.dart';
import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                title: Text(AppLocalizations.of(context)!.exitFromAppTitle),
                content: Text(AppLocalizations.of(context)!.exitFromAppQuestion),
                actions: [
                  TextButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: Text(AppLocalizations.of(context)!.yes)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text(AppLocalizations.of(context)!.no),
                  ),
                ],
              );
            },
          );
          return Future.value(shouldPop);
        },
        child: Scaffold(
            appBar: DefaultAppBar(title: AppLocalizations.of(context)!.library, automaticallyImplyLeading: false),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: AppLocalizations.of(context)!.category, widgetToRoute: ChooseCategoryScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: AppLocalizations.of(context)!.news, widgetToRoute: NewBooksScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: AppLocalizations.of(context)!.top10Books, widgetToRoute: TopScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: AppLocalizations.of(context)!.authors, widgetToRoute: ChooseAuthorScreen()),
                ChooseOptionFromMenuButton(
                    nameOfOptionFromMenu: AppLocalizations.of(context)!.community, widgetToRoute: PopularUsersScreen()),
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
