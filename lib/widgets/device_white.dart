import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:flutter/material.dart';

class  DevicePage extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const  DevicePage({
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
        title: 'devices',
        searchController: TextEditingController(),
      ),
      body: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text(
              'Devices List',
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
