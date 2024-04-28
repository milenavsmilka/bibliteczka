import 'package:flutter/material.dart';

import '../../styles/strings.dart';

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
  final length = lengthToShow;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.username,
              style: Theme.of(context).textTheme.titleMedium),
          Text('${widget.starsRating}/5',
              style: Theme.of(context).textTheme.titleMedium)
        ]),
        Row(
          children: [
            Flexible(
              child: Text.rich(TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                      text: widget.comment.length > length && !showAll
                          ? "${widget.comment.substring(0, length)}..."
                          : widget.comment,style: Theme.of(context).textTheme.titleSmall),
                  widget.comment.length > length
                      ? WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showAll = !showAll;
                              });
                            },
                            child: Text(
                              showAll ? showLess : showMore,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        )
                      : const TextSpan(),
                ],
              )),
            ),
          ],
        ),
      ],
    );
  }
}
