import 'package:biblioteczka/panels/ChooseCategoryScreen.dart';
import 'package:biblioteczka/panels/MainPanelScreen.dart';
import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/material.dart';


class DetailsOfBookScreen extends StatefulWidget {
  const DetailsOfBookScreen({super.key, required this.nameOfCategory});

  final String nameOfCategory;

  @override
  State<DetailsOfBookScreen> createState() => _DetailsOfBookScreenState();
}

class _DetailsOfBookScreenState extends State<DetailsOfBookScreen> {

  @override
  Widget build(BuildContext context) {
    print(widget.nameOfCategory);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testy mikrofonu"),
      ),
    );
  }


}

