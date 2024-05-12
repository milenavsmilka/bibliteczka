import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../Tools/NetworkLoadingImage.dart';
import '../Tools/functions.dart';

class PictureOfAuthor extends StatefulWidget {
  const PictureOfAuthor(
      {super.key, required this.authorId, required this.onPressed});

  final String authorId;
  final VoidCallback onPressed;

  @override
  State<PictureOfAuthor> createState() =>
      _PictureOfAuthorState();

}

class _PictureOfAuthorState extends State<PictureOfAuthor> {
  Map<String, dynamic> authorResponse = {'': ''};
  List<dynamic> authorDetails = [];
  String authorPicture = '-1';
  String authorName = '-1';

  @override
  void initState() {
    super.initState();
    giveMeAuthorData();
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery
        .of(context)
        .size
        .height;

    if (authorPicture == '-1') {
      return Text('czekamy na reklamy');
    } else {
      return FittedBox(
        fit: BoxFit.fill,
        child: SizedBox(
          height: heightScreen/4,
          child: IconButton(
              icon: NetworkLoadingImage(pathToImage: authorPicture),
              onPressed: widget.onPressed
          ),
        ),
      );
    }
  }

  Future<void> giveMeAuthorData() async {
    authorResponse = await getSthById(
        context, apiURLGetAuthor, Map.of({'id': widget.authorId}));

    setState(() {
      authorDetails = authorResponse['results'];
      authorPicture = authorDetails[0]['picture'];
      authorName = authorDetails[0]['name'];
    });
  }
}