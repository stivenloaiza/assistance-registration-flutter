import 'package:asia_project/controllers/users_controller.dart';
import 'package:asia_project/models/user_model.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:asia_project/widgets/custom_modal.dart';
import 'package:asia_project/widgets/edit_users_widget.dart';
import 'package:asia_project/widgets/single_user_card.dart';
import 'package:asia_project/widgets/user_card_widget.dart';
import 'package:asia_project/widgets/user_modal_admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SingleUserView extends StatefulWidget {
  final String documentId; // Unique identifier for the user
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const SingleUserView({
    super.key,
    required this.documentId,
    required this.isMobile,
    required this.onMenuPressed,
  });

  @override
  _SingleUserViewState createState() => _SingleUserViewState();
}

class _SingleUserViewState extends State<SingleUserView> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? _user;
  bool _isLoading = true;
  final UserController _userController = UserController();
  final TextEditingController _searchController =
  TextEditingController(); // Controlador de búsqueda

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Fetch the specific user document by its ID
      DocumentSnapshot documentSnapshot = await _db
          .collection('users')
          .doc(widget.documentId)
          .get();

      if (documentSnapshot.exists) {
        setState(() {
          _user = User.fromMap({
            'id': documentSnapshot.id,
            ...documentSnapshot.data() as Map<String, dynamic>,
          });
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not found')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user: $e')),
      );
    }
  }

  void _showUserModal() {
    if (_user != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return UserModalWidget(user: _user!);
        },
      );
    }
  }

  void _showEditModal() {
    if (_user != null) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomModal(
            title: 'Editar Usuario',
            child: EditUserModal(
              user: _user!,
              onSave: (updatedUser) {
                // Actualiza el usuario en Firestore
                _db
                    .collection('users')
                    .doc(updatedUser.id)
                    .update(updatedUser.toMap())
                    .then((_) {
                  setState(() {
                    _user = updatedUser;
                  });
                });
              },
            ),
          );
        },
      );
    }
  }

  Future<void> _deleteUser() async {
    if (_user != null) {
      await _userController.deleteUser(_user!.id);
      // Opcional: navegar de vuelta o mostrar un mensaje de confirmación
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: widget.isMobile,
        onMenuPressed: widget.onMenuPressed,
        title: 'User Details',
        searchController: _searchController,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _user == null
          ? Center(child: Text('No user found'))
          : Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleUserCard(
          name: _user!.name,
          email: _user!.email,
          documentNumber: _user!.documentNumber.toString(),
          imageUrl: _user!.photo.isNotEmpty
              ? _user!.photo
              : 'https://riwi.io/wp-content/uploads/2023/07/favicon.png',
          userId: _user!.id,
          onTap: _showUserModal,
        ),
      ),
    );
  }
}