import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../LoadingScreen.dart';
import '../../styles/strings.dart';
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

    opinionResponse = await getSthById(apiURLGetOpinionById, actualToken!, widget.opinionId);
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
    if (index == -1) {
      return Row(children: [Text('Loading')]);
    } else {
      return Row(
        children: [
          Flexible(
            child: Column(children: [
              Image.network(
                profilePicture,
                height: 50,
                width: 50,
              ),
              Text(username),
            ]),
          ),
          Flexible(
            child: Container(
                child: Text(comment),
                decoration: BoxDecoration(color: Colors.grey.shade50)),
          )
        ],
      );
    }
  }
}
