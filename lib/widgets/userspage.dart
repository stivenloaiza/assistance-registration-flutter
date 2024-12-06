
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const UsersPage({
    super.key,
    required this.isMobile,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: isMobile,
        onMenuPressed: onMenuPressed,
        title: 'Users',
        searchController: TextEditingController(),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text(
              'Users List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}