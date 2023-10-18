import 'dart:math';
import 'package:flutter/material.dart';

class Genre {
  final String name;
  final Color color;

  Genre({required this.name, required this.color});
}

class FakeData {
  static final List<String> comicStyles = [
    'Action',
    'Adventure',
    'Fantasy',
    'Sci-Fi',
    'Superhero',
    'Mystery',
    'Horror',
    'Romance',
    'Comedy',
    'Historical',
    'Drama',
  ];

  static final List<Color> genreColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.indigo,
    Colors.pink,
    Colors.cyan,
  ];

  static List<Genre> generateGenres() {
    List<Genre> genres = [];
    final random = Random();

    for (int i = 0; i < comicStyles.length; i++) {
      final name = comicStyles[i];
      final color = genreColors[random.nextInt(genreColors.length)];
      final genre = Genre(name: name, color: color);
      genres.add(genre);
    }

    return genres;
  }
}
