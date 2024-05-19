import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Icon addToFavIcon(double size) {
  return Icon(
    Icons.favorite,
    color: Colors.redAccent,
    size: size,
  );
}

Icon deleteFromFavIcon(double size) {
  return Icon(
    Icons.favorite_border,
    color: Colors.white,
    size: size,
  );
}

Icon deleteFromReadIcon(double size) {
  return Icon(
    Icons.remove_circle,
    color: Colors.redAccent,
    size: size,
  );
}

Icon addToReadIcon(double size) {
  return Icon(
    Icons.add_circle,
    color: Colors.greenAccent,
    size: size,
  );
}