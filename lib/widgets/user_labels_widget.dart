import 'package:flutter/material.dart';

class UserLabels extends StatelessWidget {
  const UserLabels({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Coder',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color(0xFFD6FFE8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Text(
            'Active',
            style: TextStyle(
              color: Color(0xFF00B074),
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}