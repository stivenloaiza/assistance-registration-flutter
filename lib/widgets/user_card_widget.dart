
import 'package:asia_project/widgets/action_buttons_widget.dart';
import 'package:asia_project/widgets/user_information_widget.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key, required String name, required String email, required String documentNumber, required String imageUrl});

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
      child: const Row(
        children: [
          CircleAvatar(
            radius: 35.0,
            backgroundImage: NetworkImage(
                'https://http2.mlstatic.com/D_NQ_NP_994009-MLU73899741687_012024-O.webp'),
          ),
          SizedBox(width: 16.0),
          UserInformation(),
          SizedBox(width: 16.0),
          ActionButtons(),
        ],
      ),
    );
  }
}