import 'package:biblioteczka/panels/CategoryBooks/DetailsOfBook.dart';
import 'package:biblioteczka/panels/Tools/CustomPageRoute.dart';
import 'package:biblioteczka/panels/Tools/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import '../Tools/OrdinaryOpinion.dart';
import '../Tools/Triangle.dart';
import 'EditingOpinion.dart';

class OpinionScreen extends StatefulWidget {
  const OpinionScreen(
      {super.key,
      this.opinionId,
      this.currentUsername,
      required this.instruction,
      required this.bookId});

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
                            await deleteSth(
                                context, apiURLGetOpinion, Map.of({'id': widget.opinionId.toString()}));
                            if (!context.mounted) return;
                            checkIsTokenValid(
                                context,
                                Navigator.of(context).pushReplacement(CustomPageRoute(
                                    child: DetailsOfBookScreen(bookId: widget.bookId),
                                    chooseAnimation: CustomPageRoute.FADE)));
                          } on http.ClientException catch (e) {
                            showSnackBar(context, e.message, Theme.of(context).inputDecorationTheme.errorBorder!.borderSide.color);
                          }
                        },
                        icon: const Icon(Icons.close, size: 23)),
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
      decoration: const InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: writeOwnOpinion),
    );
  }

  Future<void> giveMeOpinionBook() async {
    widget.instruction == OpinionScreen.LOAD
        ? opinionResponse =
            await getSthById(context, apiURLGetOpinion, Map.of({'id': widget.opinionId.toString()}))
        : opinionResponse =
            await getSthById(context, apiURLGetUser, Map.of({'get_self': true.toString()}));

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
