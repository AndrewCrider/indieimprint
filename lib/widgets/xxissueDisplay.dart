

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

    return Container(
      height: 210,
      width: 500,
      child: GestureDetector(
        onTap: (){
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

          child: Row(
            children: [
              Image.network(
                imageURL,
                width: 150,
                height: 200,
                fit: BoxFit.scaleDown,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Image.asset(
                    'assets/genericImages/placeholderCover.png',
                    width: 150,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  );
                },

              ),
              SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      modifiedTitle,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),),
                  SizedBox(height: 5),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
