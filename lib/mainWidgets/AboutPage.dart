import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:indieimprint/data/Artist.dart';
import 'package:indieimprint/data/Brand.dart';
import 'package:indieimprint/data/NewsItem.dart';
import 'package:indieimprint/widgets/verticalRectBioWidget.dart';
import '../services/appConfig.dart';

class AboutPage extends StatefulWidget {

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  bool _isExpanded = false;
  late Brand brand;
  String brandName = AppConfig.shared.appOwner;
  Artist? _expandedArtist;
  List<Artist> _artists = [];
  List<NewsItem> _newsItems = [];
  ScrollController _artistScrollController = ScrollController();

  Future<void> getArtists(String brand) async{
    List<Artist> artists = await Artist.fetchArtistsByBrandFromFirebase(brand);
    setState(() {
      _artists = artists;
    });
  }

  void _loadArtists() async {
    brand = await Brand.fetchSingleBrandFromFirebase(brandName);
    print(brand.tagline);
    await getArtists(brand.brand);
  }

  void _loadNews() async {
    List<NewsItem> ni = await NewsItem.fetchfalseNewsItemData();
    setState(() {
      _newsItems = ni;
      print('${_newsItems.length} item length in actual');
    });
}

  @override
  initState() {
    super.initState();
    _loadArtists();
    _loadNews();
    print('${_newsItems.length} item length');
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40,),
              Text("Breaking News",
                textAlign: TextAlign.left,
                style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontSize: 42, ),),
              ListView.builder(
        itemCount: _newsItems.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final newsItem = _newsItems[index];
          return newsItem.buildListTile();
        }),SizedBox(height: 10,),
              Text("About Us",
                textAlign: TextAlign.left,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontSize: 42, ),),
              Text(brand.tagline,
                textAlign: TextAlign.center,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic,  fontSize: 28, ),),

              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {
                      _websiteLaunch(brand.website);

                    }, child: Text("Visit Our Website")),
                    ElevatedButton(onPressed: () {
                      _websiteLaunch('https://twitter.com/${brand.twitter.toString()}');
                    }, child: Text("Visit on Our Twitter")),
                    ElevatedButton(onPressed: () {
                      _websiteLaunch(brand.patreon);
                    }, child: Text("Visit us On Paetron")),]),
              SizedBox(height: 10),
              Text("Meet our Team",
                textAlign: TextAlign.left,
                style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.w900,  fontSize: 42, ),),
              SizedBox(height: 8,),
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                  child: ListView.builder(
                shrinkWrap: true,
                controller: _artistScrollController,
                scrollDirection: Axis.horizontal,
                itemCount: _artists.length,
                itemBuilder: (context, index) {
                  final artist = _artists[index];
                  return VerticalRectBioWidget(
                    artist: artist,
                    onToggleExpansion: () {
                      // Call the scrollToCard method from the parent widget
                      // whenever the expansion is toggled in VerticalRectBioWidget.
                      scrollToCard(index);
                    },
                  );

                },
              )),
            ]),),);





  }

  void scrollToCard(int cardIndex) {
    //TODO: Fix Scrolling affect
    // Calculate the offset of the card within the ListView based on its index and item width.
    final double screenWidth = MediaQuery.of(context).size.width;
    //final double horizontalPadding = -400; // Adjust this based on your actual padding/margins.
    final double cardWidth = 1000;
    final double offset = cardIndex * cardWidth * 2;

    // Scroll to the calculated offset using the ScrollController.
    _artistScrollController.animateTo(
      offset,
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  void _websiteLaunch(url) async {

    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url))
        : throw Exception('Not Active $url');
  }

}
