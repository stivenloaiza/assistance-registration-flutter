import 'package:flutter/material.dart';
import 'package:asia_project/utils/const_data_admin_user.dart';
class CustomDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const CustomDrawer({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required BuildContext context,
  }) {
    final bool isSelected = currentIndex == index;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 5,
            height: 50,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondary.withOpacity(0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                leading: Icon(
                  icon,
                  color: isSelected ? AppColors.secondary : Colors.grey,
                ),
                title: Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? AppColors.secondary : Colors.grey,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: () => onNavigate(index),
                hoverColor: AppColors.secondary.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDrawerHeader(),
          Column(
            children: [
              _buildDrawerItem(
                icon: Icons.stacked_line_chart_sharp,
                title: 'Stadistics',
                index: 0,
                context: context,
              ),
              _buildDrawerItem(
                icon: Icons.people,
                title: 'Users',
                index: 1,
                context: context,
              ),
              _buildDrawerItem(
                icon: Icons.groups,
                title: 'Groups',
                index: 2,
                context: context,
              ),
               _buildDrawerItem(
                icon: Icons.mobile_screen_share,
                title: 'Devices',
                index: 3,
                context: context,
              ),
            ],
          ),
          _buildDrawerItem(
            icon: Icons.dock_rounded,
            title: 'Logout',
            index: 4,
            context: context,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHj_MByJQ2VcVl4xe-gpdQFLGgMOHuoy7uyQ&s'),
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
}