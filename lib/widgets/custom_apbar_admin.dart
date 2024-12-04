import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:asia_project/widgets/search_apbar.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isMobile;
  final VoidCallback? onMenuPressed;
  final String title;
  final TextEditingController searchController;

  const CustomAppBar({
    Key? key,
    required this.isMobile,
    this.onMenuPressed,
    required this.title,
    required this.searchController,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: _buildLeading(),
      flexibleSpace: _buildFlexibleSpace(context),
    );
  }

  Widget? _buildLeading() {
    if (!isMobile) return null;
    
    return IconButton(
      icon: Icon(Icons.menu, color: Colors.black),
      onPressed: onMenuPressed,
    );
  }

  Widget _buildFlexibleSpace(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: isMobile 
          ? _buildMobileContent()
          : _buildDesktopContent(context),
    );
  }

  Widget _buildMobileContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: SearchBarWidget(
            searchController: searchController,
            isMobile: true,
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        SearchBarWidget(
          searchController: searchController,
        ),
      ],
    );
  }
}