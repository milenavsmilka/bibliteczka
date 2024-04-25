import 'dart:convert';

import 'package:biblioteczka/panels/CategoryBooks/DetailsOfBookScreen.dart';
import 'package:biblioteczka/panels/functions.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../Tools/ShowAndHideMoreText.dart';
import '../main.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen(
      {super.key,
      this.opinionId,
      required this.instruction,
      required this.bookId});

  final int? opinionId;
  final int bookId;
  final String instruction;
  static const String SEND = 'SEND';
  static const String LOAD = 'LOAD';

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
  final opinionTextToSend = TextEditingController();
  bool listen = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    opinionTextToSend.addListener(() {
      if (opinionTextToSend.text.isNotEmpty) {
        listen = true;
      } else {
        listen = false;
      }
    });

    if (index == -1) {
      return const Row(children: [Text('Loading')]);
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
                        clipper: Triangle(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: widget.instruction == OpinionScreen.LOAD
                                  ? colorAppBar
                                  : Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          width: screenWidth * 0.05,
                          height: screenWidth * 0.08,
                        ),
                      ),
                      Container(
                          width: screenWidth * 0.65,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: widget.instruction == OpinionScreen.LOAD
                                  ? colorAppBar
                                  : Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: widget.instruction == OpinionScreen.LOAD
                              ? ShowAndHideMoreText(comment: comment)
                              : TextFormField(
                                  maxLines: null,
                                  //todo nie dopuścić do wysyłania komentarza jeżeli jest powyżej 1000 znaków
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: MaxLengthValidator(1000, errorText: 'Max 1000 znaków'),
                                  onTap: () {
                                    setState(() {
                                      listen = true;
                                    });
                                  },
                                  controller: opinionTextToSend,
                                  decoration: InputDecoration(
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      hintText: 'Napisz swoją opinię...'))),
                    ],
                  ),
                  const Text('')
                ],
              ),
            ],
          ),
          Visibility(
              visible: listen,
              child: Row(
                children: [
                  SizedBox(width: screenWidth * (5 / 12)),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.black,
                      shape: CircleBorder(),
                    ),
                    height: 30,
                    width: 30,
                    child: IconButton(
                      icon: Icon(Icons.close),
                      color: Colors.white,
                      iconSize: 15,
                      onPressed: () {
                        opinionTextToSend.clear();
                      },
                    ),
                  ),
                  SizedBox(width: screenWidth * (5 / 12) - 60),
                  Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.black,
                      shape: CircleBorder(),
                    ),
                    height: 30,
                    width: 30,
                    child: IconButton(
                      icon: Icon(Icons.check),
                      color: Colors.white,
                      iconSize: 15,
                      onPressed: () async {
                        try {
                         await sendOpinion(
                              opinionTextToSend.text, widget.bookId.toString());
                          // Navigator.pop(context);
                          // Navigator.push(context, MaterialPageRoute(builder: (context) =>
                          //     DetailsOfBookScreen(bookId: widget.bookId, turnOpinions: true)));
                          // setState(() {
                          //   opinionTextToSend.clear();
                          // });
                        } on http.ClientException catch (e){
                          showSnackBar(context, e.message, Colors.redAccent);
                        }
                      },
                    ),
                  )
                ],
              )),
          Row(children: [Text(' ')])
        ],
      );
    }
  }

  Future<void> giveMeOpinionBook() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    widget.instruction == OpinionScreen.LOAD
        ? opinionResponse = await getSthById(
            apiURLGetOpinion, actualToken!, 'id', widget.opinionId.toString())
        : opinionResponse = await getSthById(
            apiURLGetUser, actualToken!, 'get_self', true.toString());

    setState(() {
      index = opinionResponse['pagination']['count'];
      opinionsDetails = opinionResponse['results'];
      profilePicture = opinionsDetails[index - 1]['profile_picture'];
      username = opinionsDetails[index - 1]['username'];

      if (widget.instruction == OpinionScreen.LOAD) {
        comment = opinionsDetails[index - 1]['comment'];
        opinionsDetails = opinionResponse['results'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    giveMeOpinionBook();
  }


  Future<void> sendOpinion(String comment, String bookId) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    String? actualToken = sharedPreferences.getString(MyHomePageState.TOKEN);

    const String apiUrl = apiURLGetOpinion;
    final Map<String, dynamic> requestBody = {
      'book_id': bookId,
      'stars_count': '4',
      'comment': comment
    };
    String requestBodyJson = jsonEncode(requestBody);

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $actualToken',
      },
      body: requestBodyJson,
    );

    Map<String, dynamic> data = jsonDecode(response.body);
    var message = data['message'];
    if (message == 'object_created') {
      print("Okej :D");
    } else if(message == 'opinion_already_exists'){
      message = 'Możesz wystawić tylko jedną opinię dla danej książki';
      throw http.ClientException(message);
    }
    //todo dodać łapanie opinia za długa
    else if(message == 'opinion_already_exists'){
      message = 'Komentarz może mieć max 1000 znaków';
      throw http.ClientException(message);
    }
  }
}

class Triangle extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height / 2);
    path.lineTo(size.width + 15, 0);
    path.lineTo(size.width + 15, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
