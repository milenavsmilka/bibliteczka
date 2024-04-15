import 'package:flutter/material.dart';

class DetailsOfBookScreen extends StatefulWidget {
  const DetailsOfBookScreen(
      {super.key,
      required this.nameOfCategory,
      required this.title,
      required this.description,
      required this.isbn,
      required this.dateOfPremiere,
      required this.publishingHouse,
      required this.picture,
      required this.rate});

  final String nameOfCategory;
  final String title;
  final String description;
  final String isbn;
  final String dateOfPremiere;
  final String publishingHouse;
  final String picture;
  final double rate;

  @override
  State<DetailsOfBookScreen> createState() => _DetailsOfBookScreenState();
}

class _DetailsOfBookScreenState extends State<DetailsOfBookScreen> {
  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;
    double heightScreen = MediaQuery.of(context).size.height;
    print('${widget.nameOfCategory} ${widget.title}');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Wrap(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              children: [
                Image.network(widget.picture,
                    width: widthScreen / 2, height: heightScreen / 3),
                Text(widget.title),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(children: [Text('Tytuł: '), Text(widget.title)]),
                  Row(
                    children: [Text('Autor: '), Text('Tutaj będzie autor')],
                  ),
                  Row(children: [
                    Text('Wydawnictwo: '),
                    Text(widget.publishingHouse)
                  ]),
                  Row(
                    children: [
                      Text('Premiera: '),
                      Text(widget.dateOfPremiere.substring(5, 16))
                    ],
                  ),
                  HowMuchStars(rate: widget.rate.isNaN ? 0 : widget.rate),
                ],
              ),
            )
          ],
        ),
        Row(
          children: [
            Text(widget.description),
          ],
        )
      ]),
    );
  }
}

class HowMuchStars extends StatelessWidget {
  final double rate;

  const HowMuchStars({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    String halfStarString = (rate - rate.toInt()).toStringAsPrecision(2);
    double halfStar = double.parse(halfStarString);
    print('Ile gwiazdek? $rate, jaki wynik połówki? $halfStar');
    return Row(
      children: [
        if (rate == 0.0) ...[
          for (var i = 0; i < 5; i++) const Icon(Icons.star_border_rounded),
        ] else if (rate == 5.0) ...[
          for (var i = 0; i < 5; i++) const Icon(Icons.star_rounded),
        ] else ...[
          for (var i = 0; i < rate.toInt(); i++) Icon(Icons.star_rounded),
          if (halfStar >= 0.35 && halfStar <= 0.65) ...[
            Icon(Icons.star_half_rounded)
          ] else if (halfStar < 0.35) ...[
            Icon(Icons.star_border_rounded)
          ] else if (halfStar > 0.65) ...[
            Icon(Icons.star_rounded)
          ],
          for (var i = 0; i < 4 - rate.toInt(); i++)
            Icon(Icons.star_border_rounded),
        ],
        Text(rate.toString()),
      ],
    );
  }
}
