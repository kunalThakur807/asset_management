import 'package:flutter/material.dart';

class MyGridView extends StatelessWidget {
  final List<Map<String, dynamic>> items; // Sample data
  final Color bgColor;
  final double fontSize;
  const MyGridView(
      {super.key,
      required this.items,
      required this.bgColor,
      required this.fontSize});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        mainAxisSpacing: 10.0, // Spacing between rows
        crossAxisSpacing: 10.0, // Spacing between columns
        childAspectRatio: 2.5, // Width to height ratio of grid items
      ),
      itemCount: items.length, // Total number of items
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: bgColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  items[index]["num"],
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
                Text(
                  items[index]["title"],
                  style: TextStyle(fontSize: fontSize, color: Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
