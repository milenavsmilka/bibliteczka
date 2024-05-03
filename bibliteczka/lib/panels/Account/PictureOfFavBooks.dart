import 'package:biblioteczka/panels/CategoryBooks/DetailsOfBookScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../functions.dart';
import '../main.dart';

class PictureOfFavBooks extends StatefulWidget {
  const PictureOfFavBooks({super.key, required this.bookId});

  final int bookId;

  @override
  State<PictureOfFavBooks> createState() => _PictureOfFavBooksState();
}

class _PictureOfFavBooksState extends State<PictureOfFavBooks> {
  Map<String, dynamic> bookResponse = {'': ''};
  List<dynamic> bookDetails = [];
  String bookPicture = '-1';

  @override
  void initState() {
    super.initState();
    giveMeBookData();
  }

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;

    if (bookPicture == '-1') {
      return Text('czekamy na reklamy');
    } else {
      return SizedBox(
        width: widthScreen / 5,
        height: heightScreen / 5,
        child: IconButton(
            icon: Image.network(bookPicture,
                fit: BoxFit.fill,
                width: widthScreen / 3,
                height: heightScreen / 4),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DetailsOfBookScreen(bookId: widget.bookId),
                  ));
            }),
      );
    }
  }

  Future<void> giveMeBookData() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    bookResponse = await getSthById(
        apiURLGetBooks, actualToken!, 'id', widget.bookId.toString());

    setState(() {
      bookDetails = bookResponse['results'];
      bookPicture = bookDetails[0]['picture'];
    });
  }
}
