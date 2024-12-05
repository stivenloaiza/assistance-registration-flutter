import 'package:flutter/material.dart';

class SearchInputWidget extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchInputWidget({
    Key? key,
    this.hintText = 'Search for something',
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F2FB), // Light purple background
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[400],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        ),
      ),
    );
  }
}
