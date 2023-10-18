import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';


import 'package:indieimprint/widgets/storeCarouselItem.dart';

import '../data/Issue.dart';
import '../services/retrieveIssues.dart';
import '../widgets/issueDisplay.dart';
import '../data/bannerAds.dart';
import '../data/Series.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  List<storeCarouselItem> carouselItems = [];

  Set<String> headers = {};
  Set<String> filteredHeaders = {};
  List<Issue> storeBooks = [];
  List<Issue> searchedBooks = [];
  List<Series> series = [];
  String troubleshooting = "";
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Set<String> sections = await booksToDisplay("Flatline Comics");

    carouselItems = await getBannerAds("Flatline Comics");
    series = Series.fetchBrandSeriesData();

    setState(() {
      headers = sections;
      filteredHeaders = sections;
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchQuery = _searchController.text.toLowerCase();

    if (searchQuery.isNotEmpty) {
      searchedBooks = storeBooks.where((issue) {
        String title = issue.title.toLowerCase() ?? '';
        //String author = issue.author.toLowerCase() ?? '';
        String series = issue.series.toLowerCase() ?? '';
        String publisher = issue.publisher.toLowerCase() ?? '';

        // TODO: Add Tags Search here and Artists
        return title.contains(searchQuery) ||
            //author.contains(searchQuery) ||
            series.contains(searchQuery) ||
            publisher.contains(searchQuery);
      }).toList();

      filteredHeaders.clear();

      for (Issue title in searchedBooks) {
        filteredHeaders.add(title.series);
      }
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Container(
            color: Colors.black,
            child: CarouselSlider(
              items: carouselItems,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.15,
                // Height of the carousel (20% of the screen)
                autoPlay: true,
                viewportFraction: 1,
                enlargeCenterPage: false,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              //TODO:  See why switching to flatline as a root doesn't work
              Image.asset(
                'assets/genericImages/icon_small.png',
                width: 60,
                height: 60,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(fontSize: 14),
                  // Adjust the font size as desired
                  decoration: InputDecoration(
                    hintText: 'Search by Name or Position',
                    hintStyle: TextStyle(fontSize: 12),
                    // Adjust the font size as desired
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the border radius as desired
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the border radius as desired
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(
                          20), // Adjust the border radius as desired
                    ),
                    suffixIcon: null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      filterItems(value);
                    });
                  },
                ),
              ),
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          //TODO: Remove
          /*Text("${carouselItems.length} => Carousel Items / ${filteredHeaders.length} - $troubleshooting", style: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white)),*/
          Container(
            height: MediaQuery.of(context).size.height * .6,
            child: searchQuery.isEmpty
                ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 columns
                    ),
                    itemCount: series.length, // Replace with your list of image URLs or assets
                    itemBuilder: (context, index) {
                      final imageUrl = series[index].gridValueAsset; // Replace with your image URL or asset path
                      return GestureDetector(
                        onTap: () {
                          String currentQuery = _searchController.text.toLowerCase();

                          // Add to the current query (e.g., concatenate with a space)
                          currentQuery += series[index].seriesName; // Replace "additional text" with your desired text

                          // Set the updated query back to the search controller
                          _searchController.text = currentQuery;

                          // Trigger the onChanged callback to update the UI based on the updated query
                          filterItems(currentQuery);
                          setState(() {

                          });
                        },
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          height: 200,
                          image: AssetImage(imageUrl),

                          fit: BoxFit
                              .fitHeight, // BoxFit property to control the image fit
                        ),
                      ),);
                    },
                  )
                : Expanded(
                    child: ListView.builder(
                        itemCount: filteredHeaders.length,
                        itemBuilder: (context, index) {
                          final section = filteredHeaders.elementAt(index);
                          final filteredBooks = searchedBooks
                              .where((book) => book.series == section)
                              .toList();
                          filteredBooks.sort((a, b) => (a.seriesNumber ?? 0)
                              .compareTo(b.seriesNumber ?? 0));

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  section,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              Container(

                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 2 columns
                                  ),
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(), // Disable scrolling of the inner GridView
                                  itemCount: filteredBooks.length,
                                  itemBuilder: (context, innerIndex) {
                                    final book = filteredBooks[innerIndex];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        //width: 500,
                                        child: issueCardDisplay(
                                          imageUrl: book.cover,
                                          title: book.title,
                                          price: book.price,
                                          issue: book,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                           ],
                          );
                        })),
          ),
        ],
      ),
    );
  }

  Future<Set<String>> booksToDisplay(String publisher) async {
    List<Issue> books = await fetchIssueforPublisher(publisher);
    Set<String> sections = {};
    storeBooks = books;
    searchedBooks = books;

    for (Issue title in books) {
      sections.add(title.series);
    }

    return sections;
  }

  double _calculateOpacity() {
    // Calculate the opacity based on the scroll position
    final double scrollOffset =
        MediaQuery.sizeOf(context).height * .2; // Height of the carousel slider
    final ScrollController scrollController =
        PrimaryScrollController.of(context)!;
    final double offset =
        scrollController.hasClients ? scrollController.offset : 0.0;
    double opacity = 1.0 - (offset / scrollOffset);
    opacity = opacity.clamp(0.0, 1.0); // Ensure opacity is within valid range
    return opacity;
  }

  void filterItems(String searchQuery) {
    searchQuery = searchQuery.toLowerCase();

    if (searchQuery.isNotEmpty) {
      searchedBooks = storeBooks.where((issue) {
        String title = issue.title.toLowerCase() ?? '';
        //String author = issue.author.toLowerCase() ?? '';
        String series = issue.series.toLowerCase() ?? '';
        String publisher = issue.publisher.toLowerCase() ?? '';
        // TODO: Add Tags Search here and Artists
        return title.contains(searchQuery) ||
            //author.contains(searchQuery) ||
            series.contains(searchQuery) ||
            publisher.contains(searchQuery);
      }).toList();
      filteredHeaders.clear();
      for (Issue title in searchedBooks) {
        filteredHeaders.add(title.series);
      }
    } else {
      searchedBooks = searchedBooks;
      filteredHeaders = filteredHeaders;
    }
  }

  Future<List<storeCarouselItem>> getBannerAds(String brand) async {
    List<storeCarouselItem> sci = [];
    List<bannerAds> bannerAdsList =
        await bannerAds.fetchBannerAdsByBrandFromFirebase(brand);
    print("${bannerAdsList.length} # of ads");
    for (bannerAds b in bannerAdsList) {
      print("${b.tagline} - ad time");
      DateTime now = DateTime.timestamp();

      print('$now - DateTime in getBannerAds');

      if (b.startDate.isBefore(now) && b.endDate.isAfter(now)) {
        sci.add(storeCarouselItem(
          imagePath: b.image,
          text: b.tagline,
          link: b.link,
          type: b.type,
        ));
      }
    }

    return sci;
  }
}
