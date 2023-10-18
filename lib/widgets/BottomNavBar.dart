import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavBarItem(Icon(Icons.shopping_bag, color: currentIndex == 0 ? Colors.blue : Colors.grey), 'Store', 0, currentIndex, onTap),
          _buildNavBarItem(Icon(Icons.menu_book, color: currentIndex == 1 ? Colors.blue : Colors.grey), 'Library', 1, currentIndex, onTap),
          _buildMiddleNavItem(),
          _buildNavBarItem(Image.asset('assets/genericImages/icon_small.png'), 'About', 3, currentIndex, onTap),
          _buildNavBarItem(Icon(Icons.settings, color: currentIndex == 4 ? Colors.blue : Colors.grey), 'Settings', 4, currentIndex, onTap),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
      Widget iconData,
      String label,
      int index,
      int currentIndex,
      Function(int) onTap,
      ) {
    return GestureDetector(
      onTap: () {
        onTap(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            child: iconData,
            width: currentIndex == index ? 28.0 : 24.0,
            height: currentIndex == index ? 28.0 : 24.0,

          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.0,
              color: currentIndex == index ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiddleNavItem() {
    return Container(
      width: 80.0,
      height: 100.0,
      child: Center(
        child: Image.asset(
          'assets/genericImages/testCover.png',
          width: 60.0,
          height: 80.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}