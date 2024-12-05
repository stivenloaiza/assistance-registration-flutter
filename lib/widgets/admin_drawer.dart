import 'package:asia_project/utils/provider_nav.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:provider/provider.dart';
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
    required BuildContext context,
  }) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final bool isSelected = navigationProvider.currentIndex == index;

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
                onTap: () => navigationProvider.setIndex(index),
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
      color: Colors.white,
      child: Column(
        children: [
          _buildDrawerHeader(),
          _buildDrawerItem(
            icon: Icons.dashboard,
            title: 'Users',
            index: 0,
            context: context,
          ),
          _buildDrawerItem(
            icon: Icons.receipt_long,
            title: 'Groups',
            index: 1,
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