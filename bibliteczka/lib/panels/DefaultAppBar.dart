import 'package:flutter/material.dart';

import '../styles/strings.dart';
import 'ChangeThemeScreen.dart';
import 'SettingsScreen.dart';
import 'apiRequests.dart';

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
      title: Text(widget.title),
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      actions: <Widget>[
        PopupMenuButton(
          icon: Icon(
            Icons.account_circle,
            color: Colors.black,
            size: 35,
          ),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: Text('Wyświetl profil'),
              onTap: () {
                // checkIsTokenValid(context, );
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
                  // await logOut();//todo logout, dodać strzałkę powrotną
                })
          ],
        )
      ],
    );
  }
}