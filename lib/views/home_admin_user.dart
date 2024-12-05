import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:asia_project/utils/provider_nav.dart';
import 'package:asia_project/widgets/admin_drawer.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppDimensions.mobileBreakpoint;
    final navigationProvider = Provider.of<NavigationProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? SizedBox(
              width: screenWidth * 0.5,
              child: Drawer(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                backgroundColor: AppColors.background,
                child: const AppDrawer(),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            const SizedBox(
              width: AppDimensions.drawerWidth,
              child: AppDrawer(),
            ),
          Expanded(
            child: IndexedStack(
              index: navigationProvider.currentIndex,
              children: [
                _buildMainContent(isMobile, 'Users'),
                _buildMainContent(isMobile, 'Groups'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, String title) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: isMobile,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        title: title,
        searchController: TextEditingController(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              '$title List',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}