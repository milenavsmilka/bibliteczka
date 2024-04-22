import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowAndHideMoreText extends StatefulWidget {
  const ShowAndHideMoreText({super.key, required this.comment});

  final String comment;

  @override
  State<ShowAndHideMoreText> createState() => _ShowAndHideMoreTextState();
}

class _ShowAndHideMoreTextState extends State<ShowAndHideMoreText> {
  var showAll = false;
  final length = 100;

  @override
  Widget build(BuildContext context) {
    return Text.rich(TextSpan(
      children: <InlineSpan>[
        TextSpan(
            text: widget.comment.length > length && !showAll
                ? widget.comment.substring(0, length) + "..."
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
                    showAll ? 'Wyświetl mniej' : 'Wyświetl więcej',
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),
                  ),
                ),
              )
            : TextSpan(),
      ],
    ));
  }
}
