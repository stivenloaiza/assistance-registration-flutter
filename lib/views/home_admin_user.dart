import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:asia_project/widgets/admin_drawer.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  void _onPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppDimensions.mobileBreakpoint;

    return Scaffold(
      key: _scaffoldKey,
      drawer: isMobile
          ? Container(
              width: screenWidth * 0.7,
              child: Drawer(
                backgroundColor: AppColors.background,
                elevation: 0,
                child: AppDrawer(selectedIndex: _selectedIndex,
                  onPageSelected: _onPageSelected,),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            SizedBox(
              width: AppDimensions.drawerWidth,
              child: AppDrawer( selectedIndex: _selectedIndex,
                onPageSelected: _onPageSelected,),
            ),
          Expanded(
            child: _buildMainContent(isMobile),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: isMobile,
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        title: 'Users',
        searchController: _searchController,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return const Padding(
      padding: EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),
          Text(
            'Users List',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16),
          // Aquí irá la lista de usuarios
        ],
      ),
    );
  }
}