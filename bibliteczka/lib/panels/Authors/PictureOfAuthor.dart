import 'package:flutter/material.dart';

import '../../styles/strings.dart';
import '../Account/MyProfile.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/NetworkLoadingImage.dart';
import '../Tools/functions.dart';

class PictureOfAuthor extends StatefulWidget {
  const PictureOfAuthor(
      {super.key, required this.authorId, required this.isEditingLibrary, required this.onPressed,
      this.userId});

  final String authorId;
  final int? userId;
  final bool isEditingLibrary;
  final VoidCallback onPressed;

  @override
  State<PictureOfAuthor> createState() => _PictureOfAuthorState();
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
    double heightScreen = MediaQuery.of(context).size.height;
    double widthScreen = MediaQuery.of(context).size.width;

    if (authorPicture == '-1') {
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
                    icon: NetworkLoadingImage(pathToImage: authorPicture),
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
                          deleteSth(context, apiURLFan,
                              Map.of({'user_id': widget.userId, 'author_id': widget.authorId})));
                      Navigator.of(context).pushReplacement(CustomPageRoute(
                          child: MyProfileScreen(), chooseAnimation: CustomPageRoute.FADE));
                    });
                  },
                ),
              ),
            )
          ]));
      //   FittedBox(
      //   fit: BoxFit.fill,
      //   child: SizedBox(
      //     height: heightScreen/4,
      //     child: IconButton(
      //         icon: NetworkLoadingImage(pathToImage: authorPicture),
      //         onPressed: widget.onPressed
      //     ),
      //   ),
      // );
    }
  }

  Future<void> giveMeAuthorData() async {
    authorResponse = await getSthById(context, apiURLGetAuthor, Map.of({'id': widget.authorId}));

    setState(() {
      authorDetails = authorResponse['results'];
      authorPicture = authorDetails[0]['picture'];
      authorName = authorDetails[0]['name'];
    });
  }
}
