import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import '../data/Issue.dart';

/// Fetches Issues as encapsulated in [Issue] for a particular publisher
/// 
Future<List<Issue>> fetchIssueforPublisher(String publisher) async {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  List<Issue> comics =[];
  
  final comicsForPublisher = _db.collection("issues").where('publisher', isEqualTo: publisher);
  final publisherTitles = await comicsForPublisher.get();

  final listOfIssues = publisherTitles.docs.map((doc) {
    final data = doc.data();
    //print("list of issues - ${data.toString()} ");
    return Issue(
        id: doc.id,
        title: data["title"],
        publisher: data["publisher"],
        cover: data["cover"],
        description: data["description"],
        series: data["series"],
        seriesLength: data["seriesLength"],
        seriesNumber: data["seriesNumber"],
        author: data["author"] != null ? List<String>.from(data['author']) : [],
        artist: {'artist': data['artist']},
        length: data["length"],
        price: data["price"],
        keywords: data["keywords"] != null ? List<String>.from(data['keywords']) : [],
        bookRoot: data["bookRoot"],
        releaseDate: (data?['releaseDate'] as Timestamp)?.toDate() ?? DateTime.now()
      );
    }).toList();

    comics.addAll(listOfIssues);
    return comics;

}


Future<Issue> fetchIssuebyID(String issueID) async {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final DocumentSnapshot<Map<String, dynamic>> snapshot =
  await _db.collection("issues").doc(issueID).get();

  if (snapshot.exists) {
    final Map<String, dynamic>? data = snapshot.data();
    final String id = snapshot.id;
    //print('${data?.keys} - id ');
    if (data != null) {
      return Issue.fromJsonWithID(id ,data);
    } else {
      throw Exception("Issue data is null");
    }
  } else {
    throw Exception("Issue not found");
  }
}





