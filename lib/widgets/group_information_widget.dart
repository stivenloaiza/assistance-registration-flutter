import 'package:flutter/material.dart';

class GroupInformation extends StatelessWidget {
  final String title;
  final String description;
  final String device;
  final String startDate;
  final String endDate;
  final int timeTolerance;
  final List<String> usersId;

  const GroupInformation({
    super.key,
    required this.title,
    required this.description,
    required this.device,
    required this.startDate,
    required this.endDate,
    required this.timeTolerance,
    required this.usersId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title, 
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(description, style: const TextStyle(fontSize: 16.0)),
          const SizedBox(height: 8.0),
          Text('Device: $device', style: const TextStyle(color: Colors.grey, fontSize: 14.0)),
          const SizedBox(height: 8.0),
          Text('Start: $startDate - End: $endDate', style: const TextStyle(fontSize: 14.0)),
          const SizedBox(height: 8.0),
          Text('Time Tolerance: $timeTolerance minutes', style: const TextStyle(color: Colors.grey, fontSize: 14.0)),
          const SizedBox(height: 16.0),

          // Mostrar los nombres de los usuarios
          if (usersId.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Users:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
                const SizedBox(height: 4.0),
                ...usersId.map(
                      (userId) => Text(
                    '- $userId',
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

