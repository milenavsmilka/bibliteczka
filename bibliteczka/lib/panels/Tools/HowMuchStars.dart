import 'package:flutter/material.dart';

class HowMuchStars extends StatelessWidget {
  final double rate;

  const HowMuchStars({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    String halfStarString = (rate - rate.toInt()).toStringAsPrecision(2);
    double halfStar = double.parse(halfStarString);
    print('Ile gwiazdek? $rate, jaki wynik połówki? $halfStar');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (rate == 0.0) ...[
          for (var i = 0; i < 5; i++)
            const Icon(Icons.star_border_rounded, color: Colors.yellow),
        ] else if (rate == 5.0) ...[
          for (var i = 0; i < 5; i++)
            const Icon(Icons.star_rounded, color: Colors.yellow),
        ] else ...[
          for (var i = 0; i < rate.toInt(); i++)
            const Icon(Icons.star_rounded, color: Colors.yellow),
          if (halfStar >= 0.35 && halfStar <= 0.65) ...[
            const Icon(Icons.star_half_rounded, color: Colors.yellow)
          ] else if (halfStar < 0.35) ...[
            const Icon(Icons.star_border_rounded, color: Colors.yellow)
          ] else if (halfStar > 0.65) ...[
            const Icon(Icons.star_rounded, color: Colors.yellow)
          ],
          for (var i = 0; i < 4 - rate.toInt(); i++)
            const Icon(Icons.star_border_rounded, color: Colors.yellow),
        ],
        Text(rate.toStringAsPrecision(2), style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}