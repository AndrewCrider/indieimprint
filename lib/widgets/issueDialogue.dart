import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/DatabaseWrite.dart';
import '../data/Issue.dart';
import '../data/Purchase.dart';
import 'comicViewer.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}


class IssueDialogue extends StatefulWidget {
  final Issue issue;
  final String buttonAction;


  const IssueDialogue({required this.issue, required this.buttonAction});

  @override
  _IssueDialogueState createState() => _IssueDialogueState();
}

class _IssueDialogueState extends State<IssueDialogue> {
  String imageURL = "";
  String action = "";

  @override
  void initState() {
    super.initState();
    fetchImage();
    action = widget.buttonAction;
  }

  Future<void> fetchImage() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    final imageRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/Covers/${widget.issue.cover}");
    String image = await imageRef.getDownloadURL();
    print('$image');
    //print(await imageRef.getDownloadURL());

    setState(() {
      imageURL = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    String authorList = widget.issue.author.join('\n');
    dynamic artistData = widget.issue.artist;
    String artistNames ="";
    List<InlineSpan> formattedText = [];
    print('artist ${widget.issue.author} and artist ${widget.issue.artist.toString()}');

    if (artistData is Map<String, dynamic> && artistData.containsKey('artist')) {
      var artistValue = artistData['artist'];

      if (artistValue is List<dynamic>) {
        // Case when artist is an array, e.g., {artist: [Rich Perrotta, Yuan Cakra]}
        formattedText.add(
          TextSpan(
            text: 'Artist:\n',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
          ),
        );
        formattedText.add(
          TextSpan(
            text: artistValue.join('\n'),
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        );
      } else if (artistValue is Map<String, dynamic>) {
        // Case when artist is a map with various keys
        artistValue.forEach((key, value) {
          String formattedKey = key.substring(0, 1).toUpperCase() + key.substring(1);
          formattedText.add(
            TextSpan(
              text: '$formattedKey:\n',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black),
            ),
          );
          if (value is List<dynamic>) {
            // Handle if value is an array
            formattedText.add(
              TextSpan(
                text: value.join('\n') + '\n',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            );
          } else {
            // Handle if value is not an array
            formattedText.add(
              TextSpan(
                text: value.toString() + '\n',
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            );
          }
        });
      }
    }



    return Container(
      constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.8),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20), // Add 8 units of padding around the Column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.network(
                    imageURL,
                    width: MediaQuery.of(context).size.height * 0.35 * 3 / 4,
                    height: MediaQuery.of(context).size.height * 0.35,
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
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.issue.series,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          widget.issue.title,
                          style: TextStyle(fontSize: 24, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "$authorList",
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(children: formattedText),
                        ),
                        SizedBox(height: 10),
                        buildElevatedButtonBasedOnAction(action),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.issue.description,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget buildElevatedButtonBasedOnAction(String buttonAction) {
    switch (buttonAction) {
      case 'purchase':
        return ElevatedButton(
          onPressed: () async{
            //TODO: add purchase logic here

            Purchase newPurchase = new Purchase(issueID: widget.issue.id, title: widget.issue.title,
                series: widget.issue.series, localDownloadPath: widget.issue.bookRoot,
                purchaseDate: new DateTime.now()
                    .millisecondsSinceEpoch, status: "Paid",
                coverImage: widget.issue.cover, issueLocation: "", lastPageRead: 0);

            await DatabaseWrite.makePurchase(newPurchase);

            setState(() {
              action = "read";
            });

            Fluttertoast.showToast(
              msg: 'Thanks for your Purchase! Check your Library!',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );

          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Set the default button color
          ),
          child: Text(
            'Buy for \$${widget.issue.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.white),
          ),
        );
      case 'addToLibrary':
      // Return a different ElevatedButton widget for the 'view' action
        return ElevatedButton(
          onPressed: () {
            // Perform the desired action for 'view'
            // ...
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // Set the default button color
          ),
          child: Text('Add to Library', style: TextStyle(color: Colors.black)),
        );
    // Add more cases for other actions as needed
      case 'download':
      // Return a different ElevatedButton widget for the 'view' action
        return ElevatedButton(
          onPressed: () {
            // Perform the desired action for 'view'
            // ...
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.deepPurpleAccent, // Set the default button color
          ),
          child: Text('View', style: TextStyle(color: Colors.white)),
        );

      case 'read':
      // Return a different ElevatedButton widget for the 'view' action
        return ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => comicViewerPager(issue: widget.issue),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // Set the default button color
          ),
          child: Text('Read', style: TextStyle(color: Colors.white)),
        );

      default:
      // Return a default ElevatedButton widget if the action is not recognized
        return ElevatedButton(
          onPressed: () {
            // Perform a default action or show an error message
            // ...
          },
          child: Text('No Action Defined'),
        );
    }
  }





}
