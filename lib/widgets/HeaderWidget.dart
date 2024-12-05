import 'package:flutter/material.dart';
import "widgets.dart";

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String _title = 'Overview';
  String _avatarUrl =
      'https://images.pexels.com/photos/16586552/pexels-photo-16586552/free-photo-of-mujer-camisa-camiseta-joven.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

  void _changeTitle() {
    setState(() {
      _title = _title == 'Overview' ? 'Dashboard' : 'Overview';
    });
  }

  void _changeAvatar() {
    setState(() {
      _avatarUrl = _avatarUrl ==
              'https://images.pexels.com/photos/16586552/pexels-photo-16586552/free-photo-of-mujer-camisa-camiseta-joven.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
          ? 'https://images.pexels.com/photos/16586552/pexels-photo-16586552/free-photo-of-mujer-camisa-camiseta-joven.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
          : 'https://images.pexels.com/photos/16586552/pexels-photo-16586552/free-photo-of-mujer-camisa-camiseta-joven.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconWidget(),
          TitleWidget(title: _title, onTap: _changeTitle),
          AvatarWidget(avatarUrl: _avatarUrl, onTap: _changeAvatar),
        ],
      ),
    );
  }
}
