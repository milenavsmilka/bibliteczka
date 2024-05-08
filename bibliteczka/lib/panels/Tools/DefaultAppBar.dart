import 'package:biblioteczka/panels/Account/MyProfileScreen.dart';
import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../Account/ChangeThemeScreen.dart';
import '../Account/SettingsScreen.dart';
import 'functions.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  DefaultAppBar({super.key, required this.title, required this.automaticallyImplyLeading}) : preferredSize = Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0
  final String title;
  final bool automaticallyImplyLeading;

  @override
  _DefaultAppBarState createState() => _DefaultAppBarState();
}

class _DefaultAppBarState extends State<DefaultAppBar>{

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title, overflow: TextOverflow.ellipsis),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.account_circle,
            size: 35,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Wyświetl profil'),
              onTap: () {
                checkIsTokenValid(context, MyProfileScreen());
              },
            ),
            PopupMenuItem(
              child: Text(changeTheme),
              onTap: () {
                checkIsTokenValid(context, ChangeThemeScreen());
              },
            ),
            PopupMenuItem(
              child: Text('Ustawienia'),
              onTap: () {
                checkIsTokenValid(context, SettingsScreen());
              },
            ),
            PopupMenuItem(
                child: Text(clickToLogOutButton),
                onTap: () async {
                  checkIsTokenValid(context);
                  await sendRequest(apiURLLogOut,Map(),context);
                })
          ],
        )
      ],
    );
  }
}