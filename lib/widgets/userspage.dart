import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:asia_project/widgets/user_card_widget.dart';
import 'package:flutter/material.dart';

class UsersPage extends StatelessWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const UsersPage({
    super.key,
    required this.isMobile,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          isMobile: isMobile,
          onMenuPressed: onMenuPressed,
          title: 'Users',
          searchController: TextEditingController(),
        ),
        body: const Padding(
          padding: EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Users List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16),
                UserCard(),
                UserCard(),
                UserCard(),
                UserCard(),
                UserCard(),
                UserCard()
              ],
            ),
          ),
        ));
  }
}
