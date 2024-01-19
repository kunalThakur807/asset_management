import 'package:flutter/material.dart';

class CustomTitleText extends StatelessWidget {
  const CustomTitleText({
    super.key,
    required this.title,
    required this.size,
    required this.color,
  });
  final String? title;
  final double? size;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title!,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: size),
      ),
    );
  }
}
