import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../styles/strings.dart';

class OrdinaryOpinion extends StatefulWidget {
  const OrdinaryOpinion(
      {super.key, required this.comment, required this.username, required this.starsRating});

  final String comment;
  final String username;
  final int starsRating;

  @override
  State<OrdinaryOpinion> createState() => _OrdinaryOpinionState();
}

class _OrdinaryOpinionState extends State<OrdinaryOpinion> {
  var showAll = false;
  final length = lengthToShow;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(widget.username, style: Theme.of(context).textTheme.titleMedium),
              Text('${widget.starsRating}/5', style: Theme.of(context).textTheme.titleMedium),
            ]),
            Row(
              children: [
                Flexible(
                  child: Text.rich(TextSpan(
                    children: <InlineSpan>[
                      TextSpan(
                          text: widget.comment.length > length && !showAll
                              ? "${widget.comment.substring(0, length)}..."
                              : widget.comment,
                          style: Theme.of(context).textTheme.titleSmall),
                      widget.comment.length > length
                          ? WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAll = !showAll;
                                  });
                                },
                                child: Text(
                                  showAll ? AppLocalizations.of(context)!.showLess : AppLocalizations.of(context)!.showMore,
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
        ),
      ],
    );
  }
}
