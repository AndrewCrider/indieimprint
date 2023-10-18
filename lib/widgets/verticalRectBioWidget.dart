import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:indieimprint/data/Artist.dart';

class VerticalRectBioWidget extends StatefulWidget {
  final Artist artist;
  final VoidCallback onToggleExpansion;

  VerticalRectBioWidget({
    required this.artist,
    required this.onToggleExpansion,
  });


  @override
  _VerticalRectBioWidgetState createState() => _VerticalRectBioWidgetState();
}

class _VerticalRectBioWidgetState extends State<VerticalRectBioWidget> {
  String imageURL = '';
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  void toggleExpansion() {

    setState(() {
      isExpanded = !isExpanded;
      widget.onToggleExpansion();
      print(isExpanded);
    });
  }

  Future<void> fetchImage() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final imageRef = firebaseStorage.refFromURL(
      "gs://indieimprints.appspot.com/artists/${widget.artist.coverPhoto}",
    );
    final image = await imageRef.getDownloadURL();
    print('$image');

    setState(() {
      imageURL = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpansion,
      child: AnimatedContainer(

        duration: Duration(milliseconds: 300),
        width: isExpanded ? 800 : 491,
        child: Row(
        children: [
          Flexible(
              child: Container(
            width: 292,
            height: 400,
            child: Stack(
              children: [
                Positioned(
                  left: 15,
                  top: 0,
                  child: Container(
                    width: 202,
                    height: 400,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFF1F2326), Color(0xFC1F2326), Color(0xF51F2326), Color(0x001F2326)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 101,
                  top: 0,
                  child: Container(
                    width: 390,
                    height: 400,
                    child: Stack(
                      children: [
                        Positioned(
                          left: -150,
                          top: -07,
                          child: Container(
                            width: 380,
                            height: 400,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageURL),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 58,
                  top: 40,
                  child: Transform(
                    transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                    child: Text(
                      widget.artist.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Anton',
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 7.20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 90,
                  top: 40,
                  child: Transform(
                    transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(1.57),
                    child: Text(
                      widget.artist.brand,
                      style: TextStyle(
                        color: Color(0xFFFF4656),
                        fontSize: 24,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 2.40,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
          if(isExpanded)
            Flexible(
              child: Container(
                height: 400,
                width: 409,
                color: Colors.white,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView(

                  children: [
                    SizedBox(height: 20,),
                    Text(widget.artist.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20 ),),
                    Text(widget.artist.teaserText, style: TextStyle(fontStyle: FontStyle.italic, fontSize: 18 ),),
                    Text(widget.artist.bio),
                    SizedBox(height: 30,),
                    ElevatedButton(onPressed: (){},
                        child: Text("E-mail Me")),
                  ],
                ))
              ),),

        ],
      ),
    ),);
  }

}
