import 'package:flutter/material.dart';
import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawerCoder extends StatelessWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const CustomDrawerCoder({
    super.key,
    required this.currentIndex,
    required this.onNavigate,
  });

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
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
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                onTap: onTap,
                hoverColor: AppColors.secondary.withOpacity(0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop(); // Cierra el diálogo
                  Navigator.pushReplacementNamed(context, '/login'); // Redirige a login
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al cerrar sesión'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: AppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDrawerHeader(),
            Column(
              children: [
                _buildDrawerItem(
                  icon: Icons.people,
                  title: 'Users',
                  isSelected: currentIndex == 0,
                  onTap: () => onNavigate(0),
                ),
              ],
            ),
            _buildDrawerItem(
              icon: Icons.dock_rounded,
              title: 'Logout',
              isSelected: false, // No requiere un índice porque no navega
              onTap: () => _showLogoutConfirmationDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHj_MByJQ2VcVl4xe-gpdQFLGgMOHuoy7uyQ&s'),
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
