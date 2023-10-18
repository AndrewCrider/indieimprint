import 'package:cloud_firestore/cloud_firestore.dart';
/// Represents the Issue from Firestore and is accessed from [retrieveIssues]

class Issue {
  final String id;
  final String title;
  final String publisher;
  final String cover;
  final String description;
  final String series;
  final int seriesLength;
  final int seriesNumber;
  final List<String> author;
  final Map<String, dynamic> artist;
  final int length;
  final double price;
  final List<String> keywords;
  final String bookRoot;
  final DateTime releaseDate;

  Issue({
    required this.id,
    required this.title,
    required this.publisher,
    required this.cover,
    required this.description,
    required this.series,
    required this.seriesLength,
    required this.seriesNumber,
    required this.author,
    required this.artist,
    required this.length,
    required this.price,
    required this.keywords,
    required this.bookRoot,
    required this.releaseDate,
  });

  factory Issue.fromJson(Map<String, dynamic> json) {


    return Issue(
      id: json['id'],
      title: json['title'],
      publisher: json['publisher'],
      cover: json['cover'],
      description: json['description'],
      series: json['series'],
      seriesLength: json['seriesLength'],
      seriesNumber: json['seriesNumber'],
      author: List<String>.from(json['author']),
      artist: json['artist'],
      length: json['length'],
      price: json['price'].toDouble(),
      keywords: List<String>.from(json['keywords']),
      bookRoot: json['bookRoot'],
      releaseDate: (json['releaseDate'] as Timestamp).toDate()
    );
  }

  factory Issue.fromJsonWithID(String id, Map<String, dynamic> json) {

    return Issue(
      id: id,
      title: json['title'],
      publisher: json['publisher'],
      cover: json['cover'],
      description: json['description'],
      series: json['series'],
      seriesLength: json['seriesLength'],
      seriesNumber: json['seriesNumber'],
      author: List<String>.from(json['author']),
      artist: json['artist'],
      length: json['length'],
      price: json['price'].toDouble(),
      keywords: List<String>.from(json['keywords']),
      bookRoot: json['bookRoot'],
      releaseDate: (json['releaseDate'] as Timestamp)?.toDate() ?? DateTime.now(),
    );
  }
}
