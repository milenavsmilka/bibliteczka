import 'package:biblioteczka/panels/Account/MyProfile.dart';
import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../Account/ChangeTheme.dart';
import '../Account/SettingsScreen.dart';
import 'CustomPageRoute.dart';
import 'functions.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppBar(
      {super.key, required this.title, required this.automaticallyImplyLeading, this.onTap})
      : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0
  final String title;
  final bool automaticallyImplyLeading;
  final onTap;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, overflow: TextOverflow.ellipsis),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: <Widget>[
        PopupMenuButton(
          icon: const Icon(
            Icons.account_circle,
            size: 35,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
                onTap: widget.onTap ?? () {
                        checkIsTokenValid(
                            context,
                            Navigator.push(
                                context,
                                CustomPageRoute(
                                    chooseAnimation: CustomPageRoute.SLIDE,
                                    child: MyProfileScreen())));
                      },
                child: const Text('Wyświetl profil')),
            PopupMenuItem(
              child: Text(changeTheme),
              onTap: () {
                checkIsTokenValid(
                    context,
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            chooseAnimation: CustomPageRoute.SLIDE, child: const ChangeThemeScreen())));
              },
            ),
            PopupMenuItem(
              child: Text('Ustawienia'),
              onTap: () {
                checkIsTokenValid(
                    context,
                    Navigator.push(
                        context,
                        CustomPageRoute(
                            chooseAnimation: CustomPageRoute.SLIDE, child: const SettingsScreen())));
              },
            ),
            PopupMenuItem(
                child: Text(clickToLogOutButton),
                onTap: () async {
                  checkIsTokenValid(context);
                  await sendRequest(apiURLLogOut, Map(), context);
                })
          ],
        )
      ],
    );
  }
}
