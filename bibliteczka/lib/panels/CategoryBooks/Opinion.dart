import 'package:biblioteczka/panels/CategoryBooks/DetailsOfBook.dart';
import 'package:biblioteczka/panels/Tools/CustomPageRoute.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:biblioteczka/styles/LightTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import '../Tools/OrdinaryOpinion.dart';
import '../Tools/Triangle.dart';

//todo edycja i usuwanie komentarzy - czekam na poprawki od Piotrka
//todo dodanie ikonek ulubione, przeczytane
//todo zaktualizować stronę top 100, kiedy wchodzę do książki, dodaję opinię i przy powrocie powinno się update robić
class OpinionScreen extends StatefulWidget {
  const OpinionScreen({super.key, this.opinionId,this.currentUsername, required this.instruction, required this.bookId});

  final int? opinionId;
  final String? currentUsername;
  final String bookId;
  final String instruction;
  static const String SEND = 'SEND';
  static const String LOAD = 'LOAD';

  @override
  State<OpinionScreen> createState() => _OpinionScreenState();
}

class _OpinionScreenState extends State<OpinionScreen> {
  final opinionTextToSend = TextEditingController();
  TextEditingController opinionTextToChange = TextEditingController();

  Map<String, dynamic> opinionResponse = {'': ''};
  List<dynamic> opinionsDetails = [];
  String comment = '';
  int profilePicture = -1;
  String username = '';

  bool listenTextController = false;
  bool listenEditingController = false;

  int starsRating = 0;
  Widget currentOpinion = TextFormField();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    opinionTextToSend.addListener(() {
      if (opinionTextToSend.text.isNotEmpty) {
        listenTextController = true;
      }
    });

    opinionTextToChange.addListener(() {
      if (opinionTextToChange.text.isNotEmpty) {
        listenEditingController = true;
      }
    });

    if (username == '') {
      return const Row(children: [Text(loading)]);
    } else {
      return Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  alignment: Alignment.center,
                  width: widthScreen * 0.20,
                  child: Image.asset(
                    setProfilePicture(profilePicture),
                    height: widthScreen * 0.13,
                    width: widthScreen * 0.13,
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
                          width: widthScreen * 0.05,
                          height: widthScreen * 0.08,
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                              width: widthScreen * 0.70,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: widget.instruction == OpinionScreen.LOAD
                                      ? Theme.of(context).primaryColor
                                      : Theme.of(context).secondaryHeaderColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: widget.instruction == OpinionScreen.LOAD
                                  ? currentOpinion
                                  : textFormField(
                                      opinionTextToSend,
                                      () {
                                        setState(() {
                                          listenTextController = true;
                                        });
                                      },
                                    )),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (username == widget.currentUsername && widget.instruction == OpinionScreen.LOAD) ...{
            SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          currentOpinion = textFormField(
                            opinionTextToChange,
                            () {
                              setState(() {
                                listenEditingController = true;
                              });
                            },
                          );
                        });
                      },
                      icon: SvgPicture.asset(
                        "assets/icons/pen.svg",
                        width: 15,
                      ),
                    ),
                    IconButton(
                        onPressed: () async {
                          try {
                            await deleteSth(apiURLGetOpinion, 'id', widget.opinionId.toString());
                            Navigator.of(context).pushReplacement(CustomPageRoute(
                                child: DetailsOfBookScreen(bookId: widget.bookId),
                                chooseAnimation: CustomPageRoute.FADE));
                          } on http.ClientException catch (e) {
                            showSnackBar(context, e.message, errorColor);
                          }
                        },
                        icon: Icon(Icons.close, size: 23)),
                  ],
                ))
          },
          EditingOpinion(
              opinionTextToSend: opinionTextToSend,
              listener: listenTextController,
              bookId: widget.bookId,
              opinionId: widget.opinionId.toString(),
              operation: 'ADD'),
          const Row(children: [Text(' ')]),
          if (username == widget.currentUsername && widget.instruction == OpinionScreen.LOAD) ...{
            EditingOpinion(
                opinionTextToSend: opinionTextToChange,
                listener: listenEditingController,
                bookId: widget.bookId,
                opinionId: widget.opinionId.toString(),
                operation: 'UPDATE'),
          }
        ],
      );
    }
  }

  Widget textFormField(TextEditingController controller, VoidCallback onTap) {
    return TextFormField(
      maxLines: null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: MultiValidator([
        MinLengthValidator(2, errorText: minLengthForComment),
        MaxLengthValidator(1000, errorText: maxLengthForComment),
      ]).call,
      onTap: onTap,
      controller: controller,
      decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: writeOwnOpinion),
    );
  }

  Future<void> giveMeOpinionBook() async {
    widget.instruction == OpinionScreen.LOAD
        ? opinionResponse =
            await getSthById(apiURLGetOpinion, Map.of({'id': widget.opinionId.toString()}))
        : opinionResponse = await getSthById(apiURLGetUser, Map.of({'get_self': true.toString()}));

    setState(() {
      opinionsDetails = opinionResponse['results'];
      profilePicture = opinionsDetails[0]['profile_picture'];
      username = opinionsDetails[0]['username'];

      if (widget.instruction == OpinionScreen.LOAD) {
        comment = opinionsDetails[0]['comment'];
        starsRating = opinionsDetails[0]['stars_count'];
      }

      currentOpinion =
          OrdinaryOpinion(username: username, starsRating: starsRating, comment: comment);
      opinionTextToChange = TextEditingController(text: comment);
    });
  }

  @override
  void initState() {
    super.initState();
    giveMeOpinionBook();
  }
}

class EditingOpinion extends StatefulWidget {
  const EditingOpinion(
      {super.key,
      required this.opinionTextToSend,
      required this.listener,
      required this.bookId,
      required this.opinionId,
      required this.operation});

  final TextEditingController opinionTextToSend;
  final bool listener;
  final String bookId;
  final String opinionId;
  final String operation;

  @override
  _EditingOpinionState createState() => _EditingOpinionState();
}

class _EditingOpinionState extends State<EditingOpinion> {
  final Map<int, bool> starsFilledStatus = {1: false, 2: false, 3: false, 4: false, 5: false};
  int starsRating = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return Visibility(
      visible: widget.listener,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(width: widthScreen * (1 / 4)),
                for (int i = 1; i < 6; i++) ...{
                  IconButton(
                      onPressed: () {
                        setState(() {
                          starsFilledStatus.updateAll((key, value) => false);
                          starsFilledStatus.update(i, (value) => true);
                          starsRating =
                              starsFilledStatus.keys.lastWhere((k) => starsFilledStatus[k] == true);
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
                SizedBox(width: widthScreen * (4 / 12)),
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
                        Navigator.of(context).pushReplacement(CustomPageRoute(
                            child: DetailsOfBookScreen(bookId: widget.bookId),
                            chooseAnimation: CustomPageRoute.FADE));
                      });
                    },
                  ),
                ),
                SizedBox(width: widthScreen * (5 / 12) - 60),
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
                        showSnackBar(context, rateBookByStars, errorColor);
                      } else if (_formKey.currentState!.validate()) {
                        try {
                          widget.operation == 'ADD'
                              ? await sendRequest(
                                  apiURLGetOpinion,
                                  Map.of({
                                    'book_id': widget.bookId,
                                    'stars_count': starsRating,
                                    'comment': widget.opinionTextToSend.text
                                  }))
                              : await changeSthInMyAccount(
                                  apiURLGetOpinion,
                                  Map.of({
                                    'id': widget.opinionId,
                                    'stars_count': starsRating,
                                    'comment': widget.opinionTextToSend.text
                                  }));
                          Navigator.of(context)
                              .pushReplacement(CustomPageRoute(
                                  child: DetailsOfBookScreen(bookId: widget.bookId),
                                  chooseAnimation: CustomPageRoute.FADE))
                              .then((value) => widget.opinionTextToSend.clear());
                        } on http.ClientException catch (e) {
                          showSnackBar(context, e.message, errorColor);
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
