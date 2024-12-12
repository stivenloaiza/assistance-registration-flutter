import 'package:asia_project/global_state.dart';
import 'package:asia_project/utils/const_data_admin_user.dart';
import 'package:asia_project/views/CustomDrawerCoder.dart';
import 'package:asia_project/views/qr-dinamic/generate_qr_widget.dart';
import 'package:asia_project/views/userOnly_view.dart';
import 'package:asia_project/widgets/logout_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeCoderView extends StatefulWidget {
  const HomeCoderView({super.key});

  @override
  State<HomeCoderView> createState() => _HomeCoderViewState();
}

class _HomeCoderViewState extends State<HomeCoderView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();
  final String userId = GlobalState().currentUserUid ?? "x3UhGMh6KhawmMZAVUEj9ttvpkw1";
  int _currentPage = 0;
  String? useId; // UID del usuario, puede ser null al inicio

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

  void _getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      useId = user?.uid; // Asigna el UID al estado si el usuario está autenticado
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
                child: Column(
                  children: [
                    Expanded(
                      child: CustomDrawerCoder(
                        currentIndex: _currentPage,
                        onNavigate: _navigateToPage,
                      ),
                    ),
                    LogoutWidget(
                      onLogoutComplete: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            SizedBox(
              width: AppDimensions.drawerWidth,
              child: Column(
                children: [
                  Expanded(
                    child: CustomDrawerCoder(
                      currentIndex: _currentPage,
                      onNavigate: _navigateToPage,
                    ),
                  ),
                  LogoutWidget(
                    onLogoutComplete: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenerateQRScreen(userId: userId),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('UID no disponible. Intenta de nuevo.'),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF343C6A),
        child: const Icon(
          Icons.qr_code_scanner,
          color: Colors.white,
        ),
      ),
    );
  }
}
