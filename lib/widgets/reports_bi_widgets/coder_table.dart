import 'package:flutter/material.dart';
import 'package:asia_project/controllers/user_controller.dart'; // Asegúrate de que la ruta sea correcta
import 'package:asia_project/services/user_service.dart'; // Asegúrate de que la ruta sea correcta
import 'package:cloud_firestore/cloud_firestore.dart'; // Asegúrate de que la ruta sea correcta
import 'package:asia_project/models/user_reports_model.dart'; // Asegúrate de que la ruta sea correcta

class UserListScreen extends StatefulWidget {
  const UserListScreen({Key? key}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late UserController _userController;
  late Future<List<UserModel>> _userFuture;

  @override
  void initState() {
    super.initState();
    // Inicializar UserController con el servicio
    UserService _userService = UserService(firestore: _firestore);
    _userController = UserController(_userService);
    // Obtener todos los usuarios
    _userFuture = _userController.getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron usuarios.'));
          }

          List<UserModel> users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.role),
                onTap: () {
                  // Acción cuando se hace clic en un usuario (por ejemplo, mostrar más detalles)
                },
              );
            },
          );
        },
      ),
    );
  }
}
