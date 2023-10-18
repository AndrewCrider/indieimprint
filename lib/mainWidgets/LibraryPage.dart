import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:indieimprint/widgets/storeCarouselItem.dart';
import '../data/DatabaseWrite.dart';
import '../data/Issue.dart';
import '../data/Purchase.dart';
import '../services/retrieveIssues.dart';
import '../widgets/purchaseDisplay.dart';
import '../widgets/comicViewer.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final List<storeCarouselItem> carouselItems = demoCarouselItem();

  Set<String> headers = {};
  Set<String> filteredHeaders = {};
  List<Purchase> storeBooks = [];
  List<Purchase> searchedBooks = [];
  TextEditingController _searchController = TextEditingController();
  bool displayAsList = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    Set<String> sections = await booksToDisplay("Flatline Comics");
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
        //String publisher = issue.publisher.toLowerCase() ?? '';
        // TODO: Add Tags Search here and Artists
        return title.contains(searchQuery) ||
            //author.contains(searchQuery) ||
            series.contains(searchQuery);
        //publisher.contains(searchQuery);
      }).toList();

      filteredHeaders.clear();
      for (Purchase title in searchedBooks) {
        filteredHeaders.add(title.series);
      }
    }

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            children: [
              Image.asset(
                'assets/flatline/icon_small.png',
                width: 60,
                height: 60,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(
                      fontSize: 14), // Adjust the font size as desired
                  decoration: InputDecoration(
                    hintText: 'Search by Name or Position',
                    hintStyle: TextStyle(
                        fontSize: 12), // Adjust the font size as desired
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
              IconButton(
                onPressed: () {
                  //TODO: Handle Change to ListView
                  setState(() {
                    displayAsList = !displayAsList;
                    print('$displayAsList - after button click');
                  });
                },
                icon: displayAsList
                    ? Icon(
                        Icons.grid_view_outlined,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: displayAsList
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 3 columns
                      ),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: searchedBooks.length,
                      itemBuilder: (context, innerIndex) {
                        final section = searchedBooks.elementAt(innerIndex);
                        final filteredBooks = searchedBooks
                            .where((book) => book.series == section)
                            .toList();
                        filteredBooks.sort((a, b) => (a.purchaseDate ?? 0)
                            .compareTo(b.purchaseDate ?? 0));
                        print("${searchedBooks[0].title} = books' length");

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: purchaseCardDisplay(
                            imageUrl: section.coverImage,
                            title: section.title,
                            purchase: section,
                          ),
                        );
                      },
                    )
                  : ListView.builder(
                itemCount: filteredHeaders.length,
                itemBuilder: (context, index) {
                  final section = filteredHeaders.elementAt(index);
                  final filteredBooks = searchedBooks
                      .where((book) => book.series == section)
                      .toList();
                  filteredBooks.sort((a, b) =>
                      (a.purchaseDate ?? 0).compareTo(b.purchaseDate ?? 0));

                  return Card(
                    elevation: 2, // Adjust the card elevation as desired
                    margin: EdgeInsets.all(
                        8), // Adjust the card margin as desired
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 10,
                      child: Column(
                        children: filteredBooks.map((book) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 2, // Adjust the card elevation as desired
                              child: ListTile(
                                title: Text(
                                  book.series,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  book.title,
                                  style: TextStyle(fontSize: 14),
                                ),

                                onTap: () async {
                                  Issue chosen = await fetchIssuebyID(book.issueID);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          comicViewerPager(issue: chosen),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              )
          ),
        ],
      ),
    );
  }

  Future<Set<String>> booksToDisplay(String publisher) async {
    List<Purchase> books = await DatabaseWrite.listPurchases();
    Set<String> sections = {};
    storeBooks = books;
    searchedBooks = books;

    for (Purchase title in books) {
      print('${title.series} / ${title.issueID}');
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
        //String publisher = issue.publisher.toLowerCase() ?? '';
        // TODO: Add Tags Search here and Artists
        return title.contains(searchQuery) ||
            //author.contains(searchQuery) ||
            series.contains(searchQuery);
        //publisher.contains(searchQuery);
      }).toList();
      filteredHeaders.clear();
      for (Purchase title in searchedBooks) {
        filteredHeaders.add(title.series);
      }
    } else {
      searchedBooks = searchedBooks;
      filteredHeaders = filteredHeaders;
    }
  }
}
