import 'package:asia_project/global_state.dart';
import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:asia_project/views/CustomDrawerCoder.dart';
import 'package:asia_project/views/userOnly_view.dart';
import 'package:flutter/material.dart';

class HomeCoderView extends StatefulWidget {
  const HomeCoderView({super.key});

  @override
  State<HomeCoderView> createState() => _HomeCoderViewState();
}

class _HomeCoderViewState extends State<HomeCoderView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  final String userId = GlobalState().currentUserUid ?? "gQyFZVUf8rzjlpYl1gIv";
  int _currentPage = 0;

  void _navigateToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPage = index;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < AppDimensions.mobileBreakpoint;

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
          child: CustomDrawerCoder(
            currentIndex: _currentPage,
            onNavigate: _navigateToPage,
          ),
        ),
      )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            SizedBox(
              width: AppDimensions.drawerWidth,
              child: CustomDrawerCoder(
                currentIndex: _currentPage,
                onNavigate: _navigateToPage,
              ),
            ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                SingleUserView(
                  documentId: userId,
                  isMobile: isMobile,
                  onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}