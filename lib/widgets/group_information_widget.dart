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
          // Título del grupo
          Text(
            title, // Usamos el parámetro 'title'
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 8.0),

          // Descripción del grupo
          Text(
            description, // Usamos el parámetro 'description'
            style: const TextStyle(fontSize: 16.0),
          ),
          const SizedBox(height: 8.0),

          // Información del dispositivo
          Text(
            'Device: $device', // Usamos el parámetro 'device'
            style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
          const SizedBox(height: 8.0),

          // Rango de fechas
          Text(
            'Start: $startDate - End: $endDate', // Usamos los parámetros de fechas
            style: const TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 8.0),

          // Tolerancia de tiempo
          Text(
            'Time Tolerance: $timeTolerance minutes', // Usamos 'timeTolerance'
            style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
          const SizedBox(height: 16.0),

          // Usuarios del grupo
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
