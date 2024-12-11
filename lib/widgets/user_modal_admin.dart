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
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            user.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          Text(
            user.email,
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 20),
          // Removed the AttendanceChartWidget
          Container(
            height: 100, // Placeholder for chart
            color: Colors.grey[200],
            child: Center(child: Text("Attendance Data Placeholder")),
          ),
          SizedBox(height: 20),
          _buildInfoRow('Document Number', user.documentNumber),
          _buildInfoRow('Birth Date', _formatDate(user.birthDate)),
          _buildInfoRow('Created At', _formatDate(user.createdAt)),
          _buildInfoRow('Role', user.role),
          _buildInfoRow('Status', user.status ? 'Active' : 'Inactive'),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value.isNotEmpty ? value : 'N/A'),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.month}/${date.day}/${date.year}';  // Simple format (MM/dd/yyyy)
    } catch (e) {
      return dateString;
    }
  }
}
