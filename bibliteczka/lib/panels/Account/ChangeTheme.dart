import 'package:biblioteczka/styles/ThemeProvider.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Tools/functions.dart';

class ChangeThemeScreen extends StatefulWidget {
  const ChangeThemeScreen({super.key});

  @override
  _ChangeThemeScreenState createState() => _ChangeThemeScreenState();
}

class _ChangeThemeScreenState extends State<ChangeThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(changeTheme),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      themeState.setAnotherTheme = light;
                    });
                    changeSthInMyAccount(context, apiURLChangeTheme, Map.of({"theme": "light"}));
                  },
                  child: Text(changeToLightTheme)),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      themeState.setAnotherTheme = dark;
                    });
                    changeSthInMyAccount(context, apiURLChangeTheme, Map.of({"theme": "dark"}));
                  },
                  child: Text(changeToDarkTheme)),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      themeState.setAnotherTheme = special;
                    });
                    changeSthInMyAccount(context, apiURLChangeTheme, Map.of({"theme": "special"}));
                  },
                  child: Text(changeToSpecialTheme)),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      themeState.setAnotherTheme = daltonism;
                    });
                    try {
                      await changeSthInMyAccount(
                          context, apiURLChangeTheme, Map.of({"theme": "daltonism"}));
                    } on http.ClientException {
                      showSnackBar(context, 'Wybrano obecny motyw', Theme.of(context).cardColor);
                    }
                  },
                  child: Text(changeToDaltonismTheme))
            ],
          ),
        ),
      ),
    );
  }
}
