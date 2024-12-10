import 'package:asia_project/models/user_model.dart';
import 'package:asia_project/widgets/custom_apbar_admin.dart';
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
      _users = querySnapshot.docs
          .map((doc) => User.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Users List',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              // Verificamos si tenemos usuarios cargados
              if (_users.isEmpty)
                const Center(child: CircularProgressIndicator())
              else
              // Mostramos la lista de UserCards
                ..._users.map((user) {
                  return UserCard(
                    name: user.name,
                    email: user.email,
                    documentNumber: user.documentNumber.toString(),
                    imageUrl: user.photo.isNotEmpty
                        ? user.photo
                        : 'https://www.example.com/default_image.png', // Imagen por defecto
                  );
                }).toList(),
            ],
          ),
        ),
      ),
      floatingActionButton: const FloatingButton(),
    );
  }
}
