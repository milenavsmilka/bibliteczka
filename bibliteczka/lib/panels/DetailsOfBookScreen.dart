import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../styles/strings.dart';
import 'main.dart';


class DetailsOfBookScreen extends StatefulWidget {
  const DetailsOfBookScreen({super.key, required this.nameOfCategory,
    required this.title, required this.description,
    required this.isbn, required this.dateOfPremiere, required this.publishingHouse,
    required this.picture});

  final String nameOfCategory;
  final String title;
  final String description;
  final String isbn;
  final String dateOfPremiere;
  final String publishingHouse;
  final String picture;

  @override
  State<DetailsOfBookScreen> createState() => _DetailsOfBookScreenState();
}

class _DetailsOfBookScreenState extends State<DetailsOfBookScreen> {



  @override
  Widget build(BuildContext context) {
    print(widget.nameOfCategory);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Column(
            children: [
              Image.network(widget.picture),
              Text(widget.title),
            ],
          ),
          Column(
            children: [
              Text(widget.dateOfPremiere),
              Text(widget.publishingHouse)
            ],
          )
        ],
      ),
    );
  }
}

