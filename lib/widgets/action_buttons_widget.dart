import 'package:flutter/material.dart';

class ActionButtons extends StatefulWidget {
  const ActionButtons({super.key});

  @override
  State<ActionButtons> createState() => _ActionButtonsState();
}

class _ActionButtonsState extends State<ActionButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(
            Icons.edit,
            color: Color(0xFF343C6A),
          ),
          onPressed: () {},
        ),
        const SizedBox(height: 8.0),
        IconButton(
          icon: const Icon(
            Icons.delete,
            color: Color(0xFF343C6A),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}