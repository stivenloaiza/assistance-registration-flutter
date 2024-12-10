import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:flutter/material.dart';

class  DashboardPage extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const  DashboardPage({
    Key? key,
    required this.isMobile,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: isMobile,
        onMenuPressed: onMenuPressed,
        title: 'stadistiscs',
        searchController: TextEditingController(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            const Text(
              'Stadistiscs List',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}




