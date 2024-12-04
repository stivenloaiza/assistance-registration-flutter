import 'package:asia_project/models/model_admin_user.dart';
import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final List<PageConfig> pages;
  
  const AppDrawer({
    Key? key,
    required this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          _buildDrawerHeader(),
          ...pages.map((page) => _buildDrawerItem(page)).toList(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.network(
            'https://lasletras.org/wp-content/uploads/a.jpg',
            height: 30,
          ),
          SizedBox(width: 8),
          Text(
            'ASIA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(PageConfig page) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 50,
          decoration: BoxDecoration(
            color: page.isSelected ? AppColors.secondary : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(
              page.icon,
              color: page.isSelected ? AppColors.secondary : Colors.grey,
            ),
            title: Text(
              page.title,
              style: TextStyle(
                color: page.isSelected ? AppColors.secondary : Colors.grey,
                fontWeight: page.isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            selected: page.isSelected,
            onTap: page.onTap,
          ),
        ),
      ],
    );
  }
}
