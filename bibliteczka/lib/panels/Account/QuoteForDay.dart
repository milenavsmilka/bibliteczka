import 'dart:math';

import 'package:biblioteczka/styles/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../Tools/functions.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  QuoteScreenState createState() => QuoteScreenState();
}

class QuoteScreenState extends State<QuoteScreen> {
  String quote = '';
  String author = '';
  int count = 0;
  int randomW = 1;
  int randomH = 1;

  @override
  void initState() {
    super.initState();
    getQuote();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.quoteForToday),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Column(
          children: [
            (count < 100)
                ? SizedBox(
                    height: randomH * 1.0,
                    width: randomW * 1.0,
                  )
                : const SizedBox(),
            (count < 100)
                ? Column(
                    children: [
                      IconButton(
                        padding: const EdgeInsets.all(10.0),
                        onPressed: () {
                          chooseRandom();
                          setState(() {
                            count += 20;
                          });
                          print(count);
                        },
                        icon: Image.asset('assets/images/bookToQuote.png',
                            width: 150.0, height: 150.0, fit: BoxFit.fill),
                      ),
                      Text('$count%', style: Theme.of(context).textTheme.titleMedium),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(20),
                    child: Text(quote, style: Theme.of(context).textTheme.headlineSmall)),
          ],
        ));
  }

  Future<void> getQuote() async {
    Map<String, dynamic> data = await getSthById(context, apiURLQuote, Map.of({'language': 'pl'}));
    setState(() {
      quote = data['quote'];
      author = data['author'];
    });
    print(quote);
  }

  void chooseRandom() {
    var random = Random();

    setState(() {
      randomH = random.nextInt((MediaQuery.of(context).size.height - 300).toInt()) + 1; //- iconSize
      randomW = random.nextInt((MediaQuery.of(context).size.width).toInt()) + 1;
    });
  }
}
