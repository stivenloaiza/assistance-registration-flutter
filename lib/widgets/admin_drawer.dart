import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
    final Function(int)? onPageSelected;
  final int selectedIndex;

  const AppDrawer({
    Key? key, 
    this.onPageSelected,
    this.selectedIndex = 0,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
         _buildDrawerHeader(),
          _buildDrawerItem(Icons.dashboard, 'Dashboard', selectedIndex == 0, () => onPageSelected?.call(0)),
          _buildDrawerItem(Icons.receipt_long, 'Transactions', selectedIndex == 1, () => onPageSelected?.call(1)),
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

  Widget _buildDrawerItem(IconData icon, String title, bool isSelected, VoidCallback? onTap) {
    return Row(
      children: [
        Container(
          width: 5,
          height: 50,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.secondary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        Expanded(
          child: ListTile(
            leading: Icon(
              icon,
              color: isSelected
                  ? AppColors.secondary
                  : Colors.grey,
            ),
            title: Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? AppColors.secondary
                    : Colors.grey,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            selected: isSelected,
            onTap: () {
              // Implementar la lógica de selección aquí
            },
          ),
        ),
      ],
    );
  }
}