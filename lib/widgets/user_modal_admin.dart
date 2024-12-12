import 'package:asia_project/views/reports_coders_views.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/models/user_model.dart';
import 'dart:math';

class UserModalWidget extends StatelessWidget {
  final User user;

  const UserModalWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final skillsDevelopmentAttendance = (random.nextDouble() * 100).clamp(0.0, 100.0);
    final englishAttendance = (random.nextDouble() * 100).clamp(0.0, 100.0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              user.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 15),
            Text(
              user.email,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Container(
              height: 500,
              color: Colors.white,
              child: const ReportsCoders(),
            ),
            const SizedBox(height: 20),
            buildInfoRow('Document Number', user.documentNumber),
            buildInfoRow('Birth Date', formatDate(user.birthDate)),
            buildInfoRow('Created At', formatDate(user.createdAt)),
            buildInfoRow('Role', user.role),
            buildInfoRow('Status', user.status ? 'Active' : 'Inactive'),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.isNotEmpty ? value : 'N/A'),
        ],
      ),
    );
  }

  String formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}
