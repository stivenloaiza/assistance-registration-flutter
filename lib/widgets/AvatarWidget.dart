import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final String avatarUrl;
  final VoidCallback onTap;

  const AvatarWidget({Key? key, required this.avatarUrl, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
        radius: 20,
      ),
    );
  }
}
