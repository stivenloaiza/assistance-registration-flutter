import 'package:asia_project/widgets/action_buttons_widget.dart';
import 'package:asia_project/widgets/user_information_widget.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String email;
  final String documentNumber;
  final String imageUrl;

  // Constructor para recibir los parámetros
  const UserCard({
    super.key,
    required this.name,
    required this.email,
    required this.documentNumber,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(imageUrl), // Usamos el parámetro imageUrl
          ),
          SizedBox(width: 16.0),
          UserInformation(name: name, email: email, documentNumber: documentNumber), // Pasamos los parámetros
          SizedBox(width: 16.0),
          ActionButtons(),
        ],
      ),
    );
  }
}
