import 'package:biblioteczka/panels/Account/MyProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../styles/strings.dart';
import '../Account/QuoteForDay.dart';
import '../Account/Settings.dart';
import 'CustomPageRoute.dart';
import 'Search.dart';
import 'functions.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppBar(
      {super.key,
      required this.title,
      required this.automaticallyImplyLeading,
      this.onTap,
      this.turnSearch})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0
  final String title;
  final bool automaticallyImplyLeading;
  final dynamic turnSearch;
  final dynamic onTap;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, overflow: TextOverflow.ellipsis),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: <Widget>[
        if (widget.turnSearch != null) ...{
          IconButton(
            icon: const Icon(
              Icons.search,
              size: 35,
            ),
            onPressed: () {
              checkIsTokenValid(
                  context,
                  Navigator.push(
                      context,
                      CustomPageRoute(
                          chooseAnimation: CustomPageRoute.FADE,
                          child: SearchScreen(whatSearch: widget.turnSearch))));
            },
          ),
        },
        PopupMenuButton(
          icon: const Icon(
            Icons.account_circle,
            size: 35,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              onTap: widget.onTap ??
                  () {
                    checkIsTokenValid(
                        context,
                        Navigator.push(
                            context,
                            CustomPageRoute(
                                chooseAnimation: CustomPageRoute.SLIDE,
                                child: const MyProfileScreen())));
                  },
              child: Text(AppLocalizations.of(context)!.showProfile,
                  style: Theme.of(context).popupMenuTheme.textStyle),
            ),
            PopupMenuItem(
              child: Text(AppLocalizations.of(context)!.quoteForToday,
                  style: Theme.of(context).popupMenuTheme.textStyle),
              onTap: () {
                checkIsTokenValid(
                    context,
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            chooseAnimation: CustomPageRoute.SLIDE, child: const QuoteScreen())));
              },
            ),
            PopupMenuItem(
              child: Text(AppLocalizations.of(context)!.settings,
                  style: Theme.of(context).popupMenuTheme.textStyle),
              onTap: () {
                checkIsTokenValid(
                    context,
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            chooseAnimation: CustomPageRoute.SLIDE,
                            child: const SettingsScreen())));
              },
            ),
            PopupMenuItem(
                child: Text(AppLocalizations.of(context)!.clickToLogOutButton,
                    style: Theme.of(context).popupMenuTheme.textStyle),
                onTap: () async {
                  checkIsTokenValid(context);
                  await sendRequest(apiURLLogOut, Map.of({}), context);
                })
          ],
        ),
      ],
    );
  }
}
