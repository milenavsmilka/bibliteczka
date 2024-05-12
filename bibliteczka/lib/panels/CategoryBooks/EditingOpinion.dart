import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../styles/strings.dart';
import '../Tools/CustomPageRoute.dart';
import '../Tools/functions.dart';
import 'DetailsOfBook.dart';

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
  EditingOpinionState createState() => EditingOpinionState();
}

class EditingOpinionState extends State<EditingOpinion> {
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
                        checkIsTokenValid(
                            context,
                            Navigator.of(context).pushReplacement(CustomPageRoute(
                                child: DetailsOfBookScreen(bookId: widget.bookId),
                                chooseAnimation: CustomPageRoute.FADE)));
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
                        showSnackBar(context, rateBookByStars, Colors.redAccent);
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
                          checkIsTokenValid(
                              context,
                              Navigator.of(context)
                                  .pushReplacement(CustomPageRoute(
                                      child: DetailsOfBookScreen(bookId: widget.bookId),
                                      chooseAnimation: CustomPageRoute.FADE))
                                  .then((value) => widget.opinionTextToSend.clear()));
                        } on http.ClientException catch (e) {
                          showSnackBar(context, e.message, Colors.redAccent);
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
