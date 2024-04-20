import 'dart:convert';

import 'package:biblioteczka/LoadingScreen.dart';
import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../styles/strings.dart';
import '../main.dart';
import 'DetailsOfBookScreen.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key, required this.opinionId});

  final int opinionId;

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  Map<String, dynamic> opinionResponse = {'': ''};

  // Map<String, dynamic> index = {'':''};
  int index = -1;
  List<dynamic> opinionsDetails = [];
  String comment = '';

  @override
  void initState() {
    super.initState();
    giveMeOpinionBook();
  }

  Future<void> giveMeOpinionBook() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    opinionResponse = await getSthById(
        'pl', apiURLGetOpinionById, actualToken!, widget.opinionId);
    setState(() {
      index = opinionResponse['pagination']['count'];
      opinionsDetails = opinionResponse['results'];
      comment = opinionsDetails[index - 1]['comment'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(comment + index.toString()),
    );
  }
}
