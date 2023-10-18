

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../data/Issue.dart';
import '../data/Purchase.dart';
import 'issueDialogue.dart';
import '../services/retrieveIssues.dart';
import '../widgets/comicViewer.dart';

class purchaseCardDisplay extends StatefulWidget {
  final String imageUrl;
  final String title;
  final Purchase purchase;

  purchaseCardDisplay({
    required this.imageUrl,
    required this.title,
    required this.purchase,
  });

  @override
  _purchaseCardDisplayState createState() => _purchaseCardDisplayState();
}

class _purchaseCardDisplayState extends State<purchaseCardDisplay> {
  String imageURL = "";

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    final imageRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/Covers/${widget.imageUrl}");
    String image = await imageRef.getDownloadURL();
    print('$image');
    //print(await imageRef.getDownloadURL());

    setState(() {
      imageURL = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    String modifiedTitle = widget.title.replaceAll(": ", ":\n");
    modifiedTitle = modifiedTitle.replaceAll(" ", "\n");

    return Container(


      child: GestureDetector(
        onTap: () async{
          Issue chosen = await fetchIssuebyID(widget.purchase.issueID);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => comicViewerPager(issue: chosen),
            ),
          );
        },
        child: Card(

          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                imageURL,
                width: MediaQuery.of(context).size.height * 0.26 * 3 / 4, // Expand the image to the card's width
                height: MediaQuery.of(context).size.height * 0.26,
                fit: BoxFit.scaleDown,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset(
                    'assets/genericImages/placeholderCover.png',
                    width: MediaQuery.of(context).size.height * 0.26 * 3 / 4, // Expand the image to the card's width
                    height: MediaQuery.of(context).size.height * 0.26,
                    fit: BoxFit.scaleDown,
                  );
                },
              ),
              SizedBox(height: 10),
              Flexible(
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 5),
            ],
          ),

        ),
      ),
    );
  }
}
