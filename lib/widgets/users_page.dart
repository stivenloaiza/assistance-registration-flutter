import 'package:asia_project/controllers/users_controller.dart';
import 'package:asia_project/models/user_model.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:asia_project/widgets/custom_modal.dart';
import 'package:asia_project/widgets/edit_users_widget.dart';
import 'package:asia_project/widgets/floating_button_widget.dart';
import 'package:asia_project/widgets/user_card_widget.dart';
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
  // ignore: library_private_types_in_public_api
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<User> _users = [];
  final UserController _userController =
      UserController(); // Instanciamos el controlador

  @override
  void initState() {
    super.initState();
    _loadUsersData(); // Cargar los usuarios al iniciar
  }

  // Método para cargar los datos desde Firestore
  Future<void> _loadUsersData() async {
    QuerySnapshot querySnapshot = await _db.collection('users').get();

    // Convertimos los documentos a objetos User
    setState(() {
      _users = querySnapshot.docs.map((doc) {
        final user = User.fromMap({
          'id': doc.id, // Aseguramos de asignar el ID del documento
          ...doc.data() as Map<String, dynamic>,
        });
        return user;
      }).toList();
    });
  }

  // Método para eliminar un usuario
  Future<void> _deleteUser(String userId) async {
    await _userController.deleteUser(
        userId); // Llamamos a la función de eliminar en el controlador

    setState(() {
      // Actualizamos la lista de usuarios
      _users.removeWhere((user) => user.id == userId);
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: widget.isMobile,
        onMenuPressed: widget.onMenuPressed,
        title: 'Users',
        searchController: TextEditingController(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _users.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return UserCard(
                    name: user.name,
                    email: user.email,
                    documentNumber: user.documentNumber.toString(),
                    imageUrl: user.photo.isNotEmpty
                        ? user.photo
                        : 'https://riwi.io/wp-content/uploads/2023/07/favicon.png',
                    userId: user.id,
                    onDelete: () => _deleteUser(user.id),
                    onEdit: () => _showEditModal(
                        user), // Llama al método para mostrar el modal
                  );
                },
              ),
      ),
      floatingActionButton: const FloatingButton(),
    );
  }
}
