import 'package:biblioteczka/panels/Tools/DefaultAppBar.dart';
import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({Key? key}) : super(key: key);

  @override
  _TopScreen createState() => _TopScreen();
}

class _TopScreen extends State<TopScreen> {
  Genres? genres = Genres.all;

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: DefaultAppBar(title: titleOfApp, automaticallyImplyLeading: true),
      body: Column(
        children: [
          SizedBox(
            height: heightScreen / 7,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: heightScreen / 4,
                  mainAxisSpacing: 1),
              scrollDirection: Axis.horizontal,
              children: [
                for (int i = 0; i < Genres.values.length; i++) ...{
                  RadioListTile(
                      title: Text(Genres.values[i].name),
                      value: Genres.values[i],
                      groupValue: genres,
                      onChanged: (Genres? value) {
                        setState(() {
                          genres = value;
                        });
                      }),
                },
                RadioListTile(
                    title: Text(Genres.children.name),
                    value: Genres.children,
                    groupValue: genres,
                    onChanged: (Genres? value) {
                      setState(() {
                        genres = value;
                      });
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum Genres {
  all(name: allG),
  romance(name: romanceG),
  children(name: childrenG),
  history(name: historyG),
  science(name: scienceG),
  poetry(name: poetryG),
  youngAdult(name: youngAdultG),
  fantasy(name: fantasyG),
  bio(name: bioG),
  adventure(name: adventureG),
  comics(name: comicsG),
  thriller(name: thrillerG);

  const Genres({
    required this.name,
  });

  final String name;
}