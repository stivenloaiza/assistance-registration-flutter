import 'package:asia_project/views/devicemanagementapp.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:flutter/material.dart';

class DevicePage extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const DevicePage({
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
        title: 'Devices',
        searchController: TextEditingController(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DeviceManagementScreen(), 
      ),
    );
  }
}
