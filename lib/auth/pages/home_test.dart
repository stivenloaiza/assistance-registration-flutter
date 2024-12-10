import 'package:asia_project/views/qr-dinamic/generate_qr_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({Key? key}) : super(key: key);

  @override
  _HomeTestState createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  String? userId; // UID del usuario, puede ser null al inicio
  String? email; // Nombre del usuario, puede ser null al inicio

  @override
  void initState() {
    super.initState();
    _getUserId(); // Llama a la función para obtener el UID al iniciar
  }

  void _getUserId() {
    final User? user = FirebaseAuth.instance.currentUser;
    setState(() {
      userId = user?.uid; // Asigna el UID al estado si el usuario está autenticado
      email = user?.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TEST',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              userId != null ? 'Email: $email' : 'Cargando Email...', // Muestra el UID o un mensaje de carga
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (userId != null) {
            // Navegar a GenerateQRScreen solo si userId no es null
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenerateQRScreen(userId: userId!), // Pasa el UID como parámetro
              ),
            );
          } else {
            // Muestra un mensaje si el UID aún no está disponible
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('UID no disponible. Intenta de nuevo.'),
              ),
            );
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
