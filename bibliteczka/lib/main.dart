import 'package:bibliteczka/LoginScreen.dart';
import 'package:bibliteczka/styles/DarkTheme.dart';
import 'package:bibliteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';

import 'MainPanelScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //  title: Text(widget.title),
      // ),
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/ekranpoczatkowy.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            children: <Widget>[
              const Spacer(
                flex: 4,
              ),
              Text("Biblioteczka",
                  style: Theme.of(context).textTheme.headline1
              ),
              const Spacer(
                flex: 1,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black))),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        colorAppBar)),
                child: Text(
                  "Start",
                  style: Theme.of(context).textTheme.headline3,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainPanelScreen()),
                  );
                },
              ),
              const Spacer(
                flex: 5,
              ),
            ],
          )),
    );
  }
}
