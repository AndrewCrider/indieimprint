import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../data/Issue.dart';

class comicViewerPager extends StatefulWidget {
  final Issue issue;

  const comicViewerPager({
    required this.issue
});

  @override
  _comicViewerPagerState createState() => _comicViewerPagerState();
}

class _comicViewerPagerState extends State<comicViewerPager> {
  List<String> imageUrls = [];
  List<NetworkImage> pageImages = [];
  int currentIndex = 0;
  String coverImage = "";
  bool isIconRowVisible = false; // Track the visibility of IconRow


  @override
  void initState() {
    super.initState();
    fetchCover();
    fetchPages();

   /* for (NetworkImage i in pageImages){
      precacheImage(NetworkImage(i.url), context);
    }*/
  }

  Future<void> fetchCover() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

    final imageRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/Covers/${widget.issue.cover}");
    String image = await imageRef.getDownloadURL();
    print('$image');
    //print(await imageRef.getDownloadURL());

    setState(() {
      coverImage = image;
      imageUrls.add(image);
     // pageImages.add(NetworkImage(image));

    });
  }

  Future<void> fetchPages() async {
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    List<String> pages = [];
    List<NetworkImage> images = [];

    //final imageDirRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/inversePress/LR4H 4/");
    //TODO: Replace with live Data
    final imageDirRef = firebaseStorage.refFromURL("gs://indieimprints.appspot.com/${widget.issue.bookRoot}/");
    final result = await imageDirRef.listAll();

    for (final ref in result.items){
      final downloadURL = await ref.getDownloadURL();
      pages.add(downloadURL);
      //images.add(NetworkImage(ref.toString()));
    }
    print(' pages before sort-> ${pages.toString()}');
    pages.sort((a, b) => a.compareTo(b));
    images.sort((a, b) => a.url.compareTo(b.url));
    print(' pages after sort-> ${pages.toString()}');

    setState(() {
      imageUrls.addAll(pages);
     // pageImages.addAll(images);

    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isIconRowVisible = !isIconRowVisible;
            });
          },
          onVerticalDragUpdate: (details) {
            // If user drags down, set isIconRowVisible to true
            if (details.primaryDelta! > 0) {
              setState(() {
                isIconRowVisible = true;
              });
            }
          },
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: imageUrls.length,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(imageUrls[index]),
                    initialScale: PhotoViewComputedScale.contained,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                enableRotation: true,
              ),
              Visibility(
                visible: isIconRowVisible,
                child: IconRow(),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

class IconRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.transparent], // Black gradient background
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    iconSize: 36,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.share),
                    color: Colors.white,
                    iconSize: 36,
                    onPressed: () {
                      // Implement your share functionality
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.star_outline),
                    color: Colors.white,
                    iconSize: 36,
                    onPressed: () {
                      // Implement your favorite functionality
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}


