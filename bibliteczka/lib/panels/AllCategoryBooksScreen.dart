import 'package:biblioteczka/panels/ChooseCategoryScreen.dart';
import 'package:biblioteczka/panels/DetailsOfBookScreen.dart';
import 'package:biblioteczka/panels/MainPanelScreen.dart';
import 'package:biblioteczka/panels/apiRequests.dart';
import 'package:flutter/material.dart';


class TestScreen extends StatefulWidget {
  const TestScreen({super.key, required this.nameOfCategory, required this.listOfBooks});

  final String nameOfCategory;
  final List<dynamic> listOfBooks;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  @override
  Widget build(BuildContext context) {
    print(widget.nameOfCategory);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testy mikrofonu"),
      ),
      body: ListView.builder(
          itemCount: widget.listOfBooks.length, itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => checkIsTokenValid(context,DetailsOfBookScreen(nameOfCategory: widget.nameOfCategory)),
              child: Card(
                key: ValueKey(widget.listOfBooks[index]['id']),
                margin: EdgeInsets.all(10),
                color: Colors.amber.shade50,
                child: ListTile(
                  leading: Image.network(widget.listOfBooks[index]['picture']),
                  title: Text(widget.listOfBooks[index]['title']),
                  subtitle: Text(widget.listOfBooks[index]['isbn']),
                ),
              ),
            );
      }),
    );
  }


}

