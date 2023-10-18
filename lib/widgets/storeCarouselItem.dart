import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:indieimprint/data/bannerAds.dart';

class storeCarouselItem extends StatefulWidget {
  final String imagePath;
  final String text;
  final String link;
  final String type;

  storeCarouselItem(
      {super.key, required this.imagePath, required this.text, required this.link, required this.type});

  @override
  _storeCarouselItemState createState() => _storeCarouselItemState();

}

class _storeCarouselItemState extends State<storeCarouselItem>{

  String imageURL = "";

  @override
  void initState() {
    super.initState();
    fetchImage();
  }

  Future<void> fetchImage() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    final imageRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/banner/${widget.imagePath}");
    String image = await imageRef.getDownloadURL();
    print('$image');
    setState(() {
      imageURL = image;
    });

    //print(await imageRef.getDownloadURL());
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child:
        Image.network(
          imageURL,
         fit: BoxFit.fitWidth,

          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Image.asset(
              'assets/genericImages/comicbookshop.png',

              fit: BoxFit.fitWidth,
            );
          },

        ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}



List<storeCarouselItem> demoCarouselItem(){
  List<storeCarouselItem> sci = [];

  //sci.add(storeCarouselItem(imagePath: 'assets/genericImages/comicbookshop.png', text: "It's a Comic Book App"));
  //sci.add(storeCarouselItem(imagePath: 'assets/genericImages/two women reading.png', text: "We could be your readers"));
  //sci.add(storeCarouselItem(imagePath: 'assets/genericImages/child_in_space.png', text: "Imagine the possibilities"));

  return sci;
}





