import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;
  final String avatarImageUrl;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onAvatarPressed;

  const Header({
    Key? key,
    this.title = 'Setting',
    this.avatarImageUrl = 'https://placeholder.com/150x150',
    this.onMenuPressed,
    this.onAvatarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color(0xFF2A2F4F),
                size: 24,
              ),
              onPressed: onMenuPressed ?? () {
                Scaffold.of(context).openDrawer();
              },
            ),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2A2F4F),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: onAvatarPressed,
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[200],
                backgroundImage: NetworkImage(avatarImageUrl),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SettingsHeader(
            title: 'My Settings',
            avatarImageUrl: 'https://example.com/avatar.jpg',
            onMenuPressed: () {
              print('Menu pressed');
            },
            onAvatarPressed: () {
              print('Avatar pressed');
            },
          ),
        ],
      ),
    );
  }
}

