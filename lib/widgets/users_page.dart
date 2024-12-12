import 'package:asia_project/controllers/users_controller.dart';
import 'package:asia_project/models/user_model.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:asia_project/widgets/custom_modal.dart';
import 'package:asia_project/widgets/edit_users_widget.dart';
import 'package:asia_project/widgets/floating_button_widget.dart';
import 'package:asia_project/widgets/user_card_widget.dart';
import 'package:asia_project/widgets/user_modal_admin.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

class UsersPage extends StatefulWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const UsersPage({
    super.key,
    required this.isMobile,
    required this.onMenuPressed,
  });

  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<User> _users = [];
  List<User> _filteredUsers = []; // Lista para usuarios filtrados
  final UserController _userController = UserController();
  final TextEditingController _searchController =
      TextEditingController(); // Controlador de búsqueda

  @override
  void initState() {
    super.initState();
    _loadUsersData();

    // Escuchar cambios en el controlador de búsqueda
    _searchController.addListener(_filterUsers);
  }

  Future<void> _loadUsersData() async {
    QuerySnapshot querySnapshot = await _db.collection('users').get();

    setState(() {
      _users = querySnapshot.docs.map((doc) {
        final user = User.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
        return user;
      }).toList();
      _filteredUsers = List.from(_users); // Inicializa la lista filtrada
    });
  }

  // Filtrar usuarios por nombre
  void _filterUsers() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _filteredUsers = _users.where((user) {
        return user.name.toLowerCase().contains(query); // Filtra por nombre
      }).toList();
    });
  }

  Future<void> _deleteUser(String userId) async {
    await _userController.deleteUser(userId);

    setState(() {
      _users.removeWhere((user) => user.id == userId);
      _filteredUsers.removeWhere(
          (user) => user.id == userId); // Actualiza la lista filtrada
    });
  }

  void _showUserModal(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UserModalWidget(user: user);
      },
    );
  }

  // Método para mostrar el modal de edición
  void _showEditModal(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return CustomModal(
          title: 'Editar Usuario',
          child: EditUserModal(
            user: user,
            onSave: (updatedUser) {
              // Actualiza el usuario en la lista
              setState(() {
                final index = _users.indexWhere((u) => u.id == updatedUser.id);
                if (index != -1) {
                  _users[index] = updatedUser;
                }
              });

              // Actualiza en Firestore
              _db
                  .collection('users')
                  .doc(updatedUser.id)
                  .update(updatedUser.toMap());
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterUsers);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: widget.isMobile,
        onMenuPressed: widget.onMenuPressed,
        title: 'Users',
        searchController: _searchController, // Pasa el controlador al AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _filteredUsers.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = _filteredUsers[index];
                  return UserCard(
                    name: user.name,
                    email: user.email,
                    documentNumber: user.documentNumber.toString(),
                    imageUrl: user.photo.isNotEmpty
                        ? user.photo
                        : 'https://riwi.io/wp-content/uploads/2023/07/favicon.png',
                    userId: user.id,
                    onDelete: () => _deleteUser(user.id),
                    onEdit: () => _showEditModal(user),
                    onTap: () => _showUserModal(user),
                    role: user.role, // Pasamos el role
                    status: user.status, // Pasamos el status
                  );
                },
              ),
      ),
    );
  }
}
