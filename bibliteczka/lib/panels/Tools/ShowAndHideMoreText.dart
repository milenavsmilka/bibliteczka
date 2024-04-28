import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowAndHideMoreText extends StatefulWidget {
  const ShowAndHideMoreText(
      {super.key,
      required this.comment,
      required this.username,
      required this.starsRating});

  final String comment;
  final String username;
  final int starsRating;

  @override
  State<ShowAndHideMoreText> createState() => _ShowAndHideMoreTextState();
}

class _ShowAndHideMoreTextState extends State<ShowAndHideMoreText> {
  var showAll = false;
  final length = 110;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.username,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
          Text('${widget.starsRating}/5',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600))
        ]),
        Row(
          children: [
            Flexible(
              child: Text.rich(TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                      text: widget.comment.length > length && !showAll
                          ? "${widget.comment.substring(0, length)}..."
                          : widget.comment),
                  widget.comment.length > length
                      ? WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showAll = !showAll;
                              });
                            },
                            child: Text(
                              showAll ? ' Wyświetl mniej' : 'Wyświetl więcej',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        )
                      : TextSpan(),
                ],
              )),
            ),
          ],
        ),
      ],
    );
  }
}
