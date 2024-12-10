import 'package:asia_project/views/qr-dinamic/qr_scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(login_devices());
}

class login_devices extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _loginCodeController = TextEditingController();

  Future<void> _validateLoginCode(BuildContext context) async {
    final loginCode = _loginCodeController.text.trim();

    if (loginCode.isEmpty) {
      // Mostrar mensaje si el campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingresa el código de inicio de sesión.')),
      );
      return;
    }

    // Consultar Firestore para buscar el loginCode
    final querySnapshot = await FirebaseFirestore.instance
        .collection('devices')
        .where('loginCode', isEqualTo: loginCode)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // Código encontrado, navegar a la siguiente pantalla
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextScreen(),
        ),
      );
    } else {
      // Código no encontrado, mostrar un mensaje de error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Código incorrecto. Inténtalo nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Título
              const Text(
                "Iniciar Sesión",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),
              // Campo de entrada
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _loginCodeController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    hintText: 'Código de Inicio de Sesión',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 24),
              // Botón de inicio de sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _validateLoginCode(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle"),
        backgroundColor: Colors.blue,
      ),
      body: const Center(
        child: Text(
          "Acá va la cara",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navegar a QRScannerScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const QRScannerScreen(),
            ),
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.qr_code_scanner),
      ),
    );
  }
}