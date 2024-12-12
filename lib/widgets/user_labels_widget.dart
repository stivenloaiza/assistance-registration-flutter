import 'package:flutter/material.dart';
class UserLabels extends StatelessWidget {
  final String role;
  final bool status;

  const UserLabels({
    super.key,
    required this.role,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Label for Role (e.g., "Coder")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: const Color(0xFFE8E8E8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            role,  // Display role dynamically
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12.0,
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        // Label for Status (e.g., "Active")
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: status ? const Color(0xFFD6FFE8) : const Color(0xFFF1C6C6), // Green for active, red for inactive
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            status ? 'Active' : 'Inactive',  // Dynamically display 'Active' or 'Inactive'
            style: TextStyle(
              color: status ? const Color(0xFF00B074) : const Color(0xFFB30000), // Green for active, red for inactive
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}
