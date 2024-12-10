import 'package:flutter/material.dart';
class CustomModal extends StatelessWidget {
  final Widget child;
  final String title;
  const CustomModal({
    Key? key, 
    required this.child, 
    required this.title
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive width calculation
    double modalWidth = screenWidth * 0.9; 
    if (screenWidth > 1200) {
      modalWidth = screenWidth * 0.5; 
    } else if (screenWidth > 600) {
      modalWidth = screenWidth * 0.7; 
    }
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: modalWidth,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title, 
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            Flexible(
              child: SingleChildScrollView(
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}