import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final bool isMobile;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(25),
      ),
      width: isMobile ? null : MediaQuery.of(context).size.width * 0.4,
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.primary),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar',
                border: InputBorder.none,
                hintStyle: TextStyle(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}