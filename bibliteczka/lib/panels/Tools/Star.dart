import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  Star(this.j);

  int j;

  int get j1 => j;
  final Map<int, bool> starsFilled = {
    1: false,
    2: false,
    3: false,
    4: false,
    5: false
  };

  @override
  Widget build(BuildContext context) {
    double widthScreen = MediaQuery.of(context).size.width;

    return Row(
      children: [
        SizedBox(width: widthScreen * (1 / 3)),
        for(int i=1;i<6;i++)...{
          IconButton(
              onPressed: () {
                // setState(() {
                  starsFilled.updateAll((key, value) => false);
                  starsFilled.update(i, (value) => true);
                  fillStars();
                // });
              },
              icon: (i <= j)
                  ? Icon(Icons.star_rounded)
                  : Icon(Icons.star_border_rounded))
        }
      ],
    );
  }

  void fillStars() {
    j = starsFilled.keys.lastWhere((k) => starsFilled[k] == true);
  }
}


// class Star extends StatefulWidget{
//   const Star({super.key});
//
//   @override
//   State<Star> createState() => StarState();
//
// }

// class StarState extends State<Star> {
//   int _j = 0;
//   int get j => _j;
//
//   Map<int, bool> stars_count = {
//     1: false,
//     2: false,
//     3: false,
//     4: false,
//     5: false
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     double widthScreen = MediaQuery.of(context).size.width;
//
//     return Row(
//       key: widget.key,
//       children: [
//         SizedBox(width: widthScreen * (1 / 3)),
//         for(int i=1;i<6;i++)...{
//           IconButton(
//               onPressed: () {
//                 setState(() {
//                   stars_count.updateAll((key, value) => false);
//                   stars_count.update(i, (value) => true);
//                   fillStars();
//                 });
//               },
//               icon: (i <= _j)
//                   ? Icon(Icons.star_rounded)
//                   : Icon(Icons.star_border_rounded))
//         }
//       ],
//     );
//   }
//
//   void fillStars() {
//     _j = stars_count.keys.lastWhere((k) => stars_count[k] == true);
//   }
// }