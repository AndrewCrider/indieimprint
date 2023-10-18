import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/Issue.dart';

class listOfBooks extends StatefulWidget {
  final String title;
  final List<Issue> items;

  listOfBooks({required this.title, required this.items});

  @override
  _listOfBooksState createState() => _listOfBooksState();
}

class _listOfBooksState extends State<listOfBooks> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.items.length,
            itemBuilder: (context, index) {
              return Card(
                child: Container(
                  width: 200.0,
                  child: Center(
                    child: Text(
                     "Im a placeholder",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Card buildCard(String imageUrl, String title, double price) {
    return Card(
      child: Row(
        children: [
          Image.network(
            imageUrl,
            width: 150,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

