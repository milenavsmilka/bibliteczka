import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../LoadingScreen.dart';
import '../../styles/strings.dart';
import '../Tools/ShowAndHideMoreText.dart';
import '../main.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key, required this.opinionId});

  final int opinionId;

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  Map<String, dynamic> opinionResponse = {'': ''};

  int index = -1;
  List<dynamic> opinionsDetails = [];
  String comment = '';
  String profilePicture = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    giveMeOpinionBook();
  }

  Future<void> giveMeOpinionBook() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    opinionResponse =
        await getSthById(apiURLGetOpinionById, actualToken!, widget.opinionId);
    setState(() {
      index = opinionResponse['pagination']['count'];
      opinionsDetails = opinionResponse['results'];
      comment = opinionsDetails[index - 1]['comment'];
      profilePicture = opinionsDetails[index - 1]['profile_picture'];
      username = opinionsDetails[index - 1]['username'];
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (index == -1) {
      return Row(children: [Text('Loading')]);
    } else {
      return Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.center,
                  width: screenWidth * 0.25,
                  child: Column(children: [
                    Image.network(
                      profilePicture,
                      height: 50,
                      width: 50,
                    ),
                    Text(username),
                  ]),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      ClipPath(
                        child: Container(
                          decoration: BoxDecoration(color:colorAppBar, borderRadius: BorderRadius.circular(10)),
                          width: screenWidth*0.05,
                          height: screenWidth*0.08,
                        ),
                        clipper: Triangle(),
                      ),
                      Container(
                        width: screenWidth * 0.65,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: colorAppBar, borderRadius: BorderRadius.circular(10)),
                          child: ShowAndHideMoreText(comment: comment)),
                    ],
                  ),
                  Text('')
                ],
              )
            ],
          ),
          Row(children: [Text(' ')])
        ],
      );
    }
  }
}

class Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    final path= Path();
    path.lineTo(0, size.height/2);
    path.lineTo(size.width+15, 0);
    path.lineTo(size.width+15, size.height);
    path.lineTo(0, size.height/2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;

}
