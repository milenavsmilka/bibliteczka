import 'package:bibliteczka/styles/DarkTheme.dart';
import 'package:bibliteczka/styles/LightTheme.dart';
import 'package:bibliteczka/styles/ThemeConstants.dart';
import 'package:bibliteczka/styles/ThemeManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpNav extends StatelessWidget {
  const SignUpNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home:MainPanelScreen(),
    );
  }
}

class MainPanelScreen extends StatefulWidget {
  const MainPanelScreen({Key? key}) : super(key: key);

  @override
  _MainPanelScreen createState() => _MainPanelScreen();
}

class _MainPanelScreen extends State<MainPanelScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Biblioteczka',
          style: Theme.of(context).textTheme.headline2,
        ),
        // centerTitle: true,
        // foregroundColor: Colors.black,
        // backgroundColor: Color.fromRGBO(242, 224, 157, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_sharp),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ChooseCategoryButton(nameOfCategory: "Kategoria"),
            ChooseCategoryButton(nameOfCategory: "Zapowiedzi"),
            ChooseCategoryButton(nameOfCategory: "Top 100"),
            ChooseCategoryButton(nameOfCategory: "Autorzy"),
            ChooseCategoryButton(nameOfCategory: "Społeczność"),
          ],
        ),
      ));
}

class ChooseCategoryButton extends StatelessWidget {
  final String nameOfCategory;

  const ChooseCategoryButton({
    Key? key,
    required this.nameOfCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(95),
        ),
        child: Text(
          nameOfCategory,
          style: Theme.of(context).textTheme.headline4,
        ),
        onPressed: () {},
      ),
    );
  }
}
