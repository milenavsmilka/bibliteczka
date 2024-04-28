import 'package:biblioteczka/panels/CategoryBooks/DetailsOfBookScreen.dart';
import 'package:biblioteczka/panels/functions.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../styles/strings.dart';
import '../Tools/ShowAndHideMoreText.dart';
import '../Tools/Triangle.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> opinionResponse = {'': ''};

  int index = -1;
  List<dynamic> opinionsDetails = [];
  String comment = '';
  String profilePicture = '';
  String username = '';

  final opinionTextToSend = TextEditingController();
  bool listenTextController = false;
  final Map<int, bool> starsFilledStatus = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false
  };
  int starsRating = 0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    opinionTextToSend.addListener(() {
      if (opinionTextToSend.text.isNotEmpty) {
        listenTextController = true;
      }
    });

    if (index == -1) {
      return const Row(children: [Text('Loading')]);
    } else {
      return Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.20,
                    child: Image.network(
                      profilePicture,
                      height: 50,
                      width: 50,
                    ),
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
                            width: screenWidth * 0.70,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: widget.instruction == OpinionScreen.LOAD
                                    ? colorAppBar
                                    : Colors.black12,
                                borderRadius: BorderRadius.circular(10)),
                            child: widget.instruction == OpinionScreen.LOAD
                                ? ShowAndHideMoreText(username: username,starsRating:starsRating, comment: comment)
                                : TextFormField(
                                    maxLines: null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: MultiValidator([
                                      MinLengthValidator(2,
                                          errorText: 'Min 2 znaki'),
                                      MaxLengthValidator(1000,
                                          errorText: 'Max 1000 znaków'),
                                    ]).call,
                                    onTap: () {
                                      setState(() {
                                        listenTextController = true;
                                      });
                                    },
                                    controller: opinionTextToSend,
                                    decoration: InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintText: 'Napisz swoją opinię...'))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
                visible: listenTextController,
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(width: screenWidth * (1 / 3)),
                        for (int i = 1; i < 6; i++) ...{
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  starsFilledStatus
                                      .updateAll((key, value) => false);
                                  starsFilledStatus.update(i, (value) => true);
                                  starsRating = starsFilledStatus.keys
                                      .lastWhere(
                                          (k) => starsFilledStatus[k] == true);
                                });
                              },
                              icon: (i <= starsRating)
                                  ? Icon(Icons.star_rounded)
                                  : Icon(Icons.star_border_rounded))
                        }
                      ],
                    ),
                    Row(
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
                              setState(() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailsOfBookScreen(
                                                bookId: widget.bookId,
                                                turnOpinions: true)));
                              });
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
                              if (starsRating == 0) {
                                showSnackBar(
                                    context,
                                    'Oceń książkę ilością gwiazdek!',
                                    Colors.redAccent);
                              } else if (_formKey.currentState!.validate()) {
                                try {
                                  await sendOpinion(opinionTextToSend.text,
                                      starsRating, widget.bookId.toString());
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DetailsOfBookScreen(
                                                  bookId: widget.bookId,
                                                  turnOpinions: true)));
                                  opinionTextToSend.clear();
                                } on http.ClientException catch (e) {
                                  showSnackBar(
                                      context, e.message, Colors.redAccent);
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            Row(children: [Text(' ')])
          ],
        ),
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
        starsRating = opinionsDetails[index - 1]['stars_count'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    giveMeOpinionBook();
  }
}
