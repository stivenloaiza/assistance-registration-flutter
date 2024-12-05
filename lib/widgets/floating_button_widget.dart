import 'package:flutter/material.dart';

class FloatingButton extends StatefulWidget {
  const FloatingButton({super.key});

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: const Color(0xFF343C6A),
      elevation: 3.0,
      shape: const CircleBorder(),
      onPressed: () {},
      child: const Icon(
        Icons.add,
        size: 30.0,
        color: Colors.white,
      ),
    );
  }
}
