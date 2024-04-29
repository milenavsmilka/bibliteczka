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
  final opinionTextToSend = TextEditingController();

  Map<String, dynamic> opinionResponse = {'': ''};
  int index = -1;
  List<dynamic> opinionsDetails = [];
  String comment = '';
  int profilePicture = -1;
  String username = '';

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
      return const Row(children: [Text(loading)]);
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
                    child: Image.asset(
                      setProfilePicture(profilePicture),
                      height: screenWidth * 0.13,
                      width: screenWidth * 0.13,
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
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(10)),
                            width: screenWidth * 0.05,
                            height: screenWidth * 0.08,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.70,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: widget.instruction == OpinionScreen.LOAD
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: widget.instruction == OpinionScreen.LOAD
                                ? ShowAndHideMoreText(username: username,starsRating:starsRating, comment: comment)
                                : TextFormField(
                                    maxLines: null,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: MultiValidator([
                                      MinLengthValidator(2,
                                          errorText: minLengthForComment),
                                      MaxLengthValidator(1000,
                                          errorText: maxLengthForComment),
                                    ]).call,
                                    onTap: () {
                                      setState(() {
                                        listenTextController = true;
                                      });
                                    },
                                    controller: opinionTextToSend,
                                    decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        hintText: writeOwnOpinion))),
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
                                  ? const Icon(Icons.star_rounded)
                                  : const Icon(Icons.star_border_rounded))
                        }
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(width: screenWidth * (5 / 12)),
                        Ink(
                          decoration: ShapeDecoration(
                            color: Theme.of(context).iconTheme.color,
                            shape: const CircleBorder(),
                          ),
                          height: 30,
                          width: 30,
                          child: IconButton(
                            icon: const Icon(Icons.close),
                            color: Theme.of(context).dialogTheme.backgroundColor,
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
                          decoration: ShapeDecoration(
                            color: Theme.of(context).iconTheme.color,
                            shape: const CircleBorder(),
                          ),
                          height: 30,
                          width: 30,
                          child: IconButton(
                            icon: const Icon(Icons.check),
                            color: Theme.of(context).dialogTheme.backgroundColor,
                            iconSize: 15,
                            onPressed: () async {
                              if (starsRating == 0) {
                                showSnackBar(
                                    context,
                                    rateBookByStars,
                                    errorColor);
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
                                      context, e.message, errorColor);
                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                )),
            const Row(children: [Text(' ')])
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
