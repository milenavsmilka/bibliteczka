import 'package:biblioteczka/styles/ThemeProvider.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemeScreen extends StatefulWidget {
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
                  },
                  child: Text(changeToLightTheme)),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      themeState.setAnotherTheme = dark;
                    });
                  },
                  child: Text(changeToDarkTheme)),
            ],
          ),
        ),
      ),
    );
  }
}