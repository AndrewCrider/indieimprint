import 'package:flutter/material.dart';

class NewsItem {
  String icon;
  String headline;
  String actionType;
  String actionLink;
  bool read;

  NewsItem({
    required this.icon,
    required this.headline,
    required this.actionType,
    required this.actionLink,
    this.read = false,
  });

  int getIconCodePoint(String icon) {
    // Remove any leading '0x' or '0X' from the hex string (if present)
    icon = icon.replaceAll('0x', '').replaceAll('0X', '');

    // Parse the icon string as a hexadecimal number and return the code point
    return int.tryParse(icon, radix: 16) ?? 0;
  }


  Widget buildListTile() {
    final int iconCodePoint = getIconCodePoint(icon);
    return Card(
        child: ListTile(
      // TODO: Fix to be dynamic
          /*leading: Icon(
        IconData(iconCodePoint, fontFamily: 'MaterialIcons'),
      ),*/
      title: Text(headline),
      subtitle: Text(actionType),
      trailing: read ? Icon(Icons.check_circle, color: Colors.green) : null,
      onTap: () {
        // Handle the tap event here, e.g., navigate to the action link
      },
    ));
  }

  static List<NewsItem> fetchfalseNewsItemData() {
    return [
      NewsItem(
        icon: '58395',
        headline: 'Breaking News',
        actionType: 'Read more',
        actionLink: 'https://example.com/news/1',
        read: false,
      ),
      NewsItem(
        icon: '58394',
        headline: 'Latest Updates',
        actionType: 'Watch video',
        actionLink: 'https://example.com/news/2',
        read: true,
      ),
// Add more NewsItem objects as needed
    ];
  }

}