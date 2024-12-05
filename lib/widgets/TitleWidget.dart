import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const TitleWidget({Key? key, required this.title, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}