import 'package:asia_project/widgets/user_labels_widget.dart';
import 'package:flutter/material.dart';
class UserInformation extends StatelessWidget {
  final String name;
  final String email;
  final String documentNumber;
  final String role;   // Añadir el campo role
  final bool status;   // Añadir el campo status

  const UserInformation({
    super.key,
    required this.name,
    required this.email,
    required this.documentNumber,
    required this.role,   // Recibimos el rol
    required this.status, // Recibimos el estado
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name, // Usamos el parámetro 'name'
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 4.0),
            Text('C.C. $documentNumber'), // Usamos el parámetro 'documentNumber'
            const SizedBox(height: 4.0),
            Text(email), // Usamos el parámetro 'email'
            const SizedBox(height: 8.0),
            UserLabels(role: role, status: status),  // Pasamos el role y status a UserLabels
          ],
        ),
      ),
    );
  }
}
