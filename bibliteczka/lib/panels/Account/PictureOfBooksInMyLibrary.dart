import 'package:biblioteczka/panels/Account/MyProfileScreen.dart';
import 'package:biblioteczka/panels/CategoryBooks/DetailsOfBookScreen.dart';
import 'package:biblioteczka/panels/Tools/CustomPageRoute.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../Tools/functions.dart';
import '../main.dart';

class PictureOfBooksInMyLibrary extends StatefulWidget {
  const PictureOfBooksInMyLibrary(
      {super.key, required this.bookId, required this.isEditingLibrary, required this.categoryUrl});

  final int bookId;
  final bool isEditingLibrary;
  final String categoryUrl;

  @override
  State<PictureOfBooksInMyLibrary> createState() =>
      _PictureOfBooksInMyLibraryState();

}

class _PictureOfBooksInMyLibraryState extends State<PictureOfBooksInMyLibrary> {
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
    double widthScreen = MediaQuery
        .of(context)
        .size
        .width;
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;

    if (bookPicture == '-1') {
      return Text('czekamy na reklamy');
    } else {
      return SizedBox(
          width: widthScreen / 5,
          height: heightScreen / 5,
          child: Stack(children: [
            IconButton(
                icon: Image.network(bookPicture,
                    fit: BoxFit.fill,
                    width: widthScreen / 3,
                    height: heightScreen / 4),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsOfBookScreen(bookId: widget.bookId,turnOpinions: true),
                      ));
                }),
            Visibility(
              visible: widget.isEditingLibrary,
              child: Align(alignment: Alignment.topRight,
                child: FloatingActionButton(
                  heroTag: DateTime.now(),
                  shape: CircleBorder(),
                  mini: true,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.close, color: Theme
                      .of(context)
                      .primaryColor),
                  onPressed: () {
                    setState(() {
                      deleteBooksFromMyLibrary(widget.categoryUrl, 'book_id',
                          widget.bookId.toString());
                      Navigator.of(context).pushReplacement(
                          CustomPageRoute(child: MyProfileScreen(), chooseAnimation: CustomPageRoute.FADE));
                    });
                  },
                ),),
            )
          ])
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