

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../data/Issue.dart';
import 'issueDialogue.dart';

class issueCardDisplay extends StatefulWidget {
  final String imageUrl;
  final String title;
  final double price;
  final Issue issue;

  const issueCardDisplay({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.issue,
  });

  @override
  _issueCardDisplayState createState() => _issueCardDisplayState();
}

class _issueCardDisplayState extends State<issueCardDisplay> {
  String imageURL = "";

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    final imageRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/Covers/${widget.imageUrl}");
    print("${widget.title} -> $imageRef");
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
    String buttonActionFromIssue = "";

    return Container(
      //width: MediaQuery.of(context).size.width * 0.2, // Set image width to 20% of device width

      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: IssueDialogue(issue: widget.issue, buttonAction: "purchase"),
              );
            },
          );
        },
        child: Card(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                imageURL,
                width: MediaQuery.of(context).size.height * 0.25 * 3 / 4, // Expand the image to the card's width
                height: MediaQuery.of(context).size.height * 0.25 , // 4:3 aspect ratio
                fit: BoxFit.fitHeight, // Maintain aspect ratio and fill the available space
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset(
                    'assets/genericImages/placeholderCover.png',
                    width: MediaQuery.of(context).size.height * 0.25 * 3 / 4, // Expand the image to the card's width
                    height: MediaQuery.of(context).size.height * 0.25, // 4:3 aspect ratio
                    fit: BoxFit.cover,
                  );
                },
              ),
              SizedBox(height: 5),
              Flexible(
                child: Text(
                  modifiedTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center, // Center the text
                ),
              ),
              SizedBox(height: 5),
              Text(
                '\$${widget.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Center the text
              ),
            ],
          ),
        ),
      )
    );
  }

}
