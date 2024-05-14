import 'package:biblioteczka/panels/Account/MyProfile.dart';
import 'package:biblioteczka/panels/Tools/CustomPageRoute.dart';
import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../Tools/NetworkLoadingImage.dart';
import '../Tools/functions.dart';

class PictureOfBooksInMyLibrary extends StatefulWidget {
  const PictureOfBooksInMyLibrary(
      {super.key,
      required this.bookId,
      required this.isEditingLibrary,
      required this.categoryUrl,
      required this.onPressed});

  final String bookId;
  final bool isEditingLibrary;
  final String categoryUrl;
  final VoidCallback onPressed;

  @override
  State<PictureOfBooksInMyLibrary> createState() => _PictureOfBooksInMyLibraryState();
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
  void didUpdateWidget(PictureOfBooksInMyLibrary oldWidget) {
    super.didUpdateWidget(oldWidget);

    if(widget.bookId!=oldWidget.bookId){
      giveMeBookData();
    }
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
          child: Stack(children: [
            SizedBox(
              width: widthScreen / 3,
              height: heightScreen / 4,
              child: FittedBox(
                fit: BoxFit.fill,
                child: IconButton(
                    icon: NetworkLoadingImage(pathToImage: bookPicture),
                    onPressed: widget.onPressed),
              ),
            ),
            Visibility(
              visible: widget.isEditingLibrary,
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  heroTag: DateTime.now(),
                  shape: CircleBorder(),
                  mini: true,
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.close, color: Theme.of(context).primaryColor),
                  onPressed: () {
                    setState(() {
                      checkIsTokenValid(
                          context,
                          deleteSth(
                              context,
                              widget.categoryUrl,
                              Map.of({
                                'book_id': widget.bookId
                              })));
                      Navigator.of(context).pushReplacement(CustomPageRoute(
                          child: MyProfileScreen(), chooseAnimation: CustomPageRoute.FADE));
                    });
                  },
                ),
              ),
            )
          ]));
    }
  }

  Future<void> giveMeBookData() async {
    bookResponse = await getSthById(context, apiURLGetBooks, Map.of({'id': widget.bookId}));

    setState(() {
      bookDetails = bookResponse['results'];
      bookPicture = bookDetails[0]['picture'];
    });
  }
}
