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

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _loginCodeController = TextEditingController();
  int _failedAttempts = 0;

  Future<void> _validateLoginCode(BuildContext context) async {
    final loginCode = _loginCodeController.text.trim();

    if (loginCode.isEmpty) {
      // Mostrar mensaje si el campo está vacío
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingresa el código de inicio de sesión.')),
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
      setState(() {
        _failedAttempts = 0;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NextScreen(),
        ),
      );
    } else {
      // Código no encontrado, mostrar un mensaje de error
      setState(() {
        _failedAttempts++;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código incorrecto. Inténtalo nuevamente.')),
      );

      if (_failedAttempts >= 3) {
        await _registerFailedAccessNotification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Se ha registrado un intento fallido en las notificaciones.')),
        );

        setState(() {
          _failedAttempts = 0;
        });
      }
    }
  }

  Future<void> _registerFailedAccessNotification() async {
    final timestamp = DateTime.now();
    final loginCode = _loginCodeController.text;
    await FirebaseFirestore.instance.collection('notifications_device').add({
      'type': 'failed_access',
      'title': 'Acceso fallido',
      'subtitle': 'Se realizaron múltiples intentos fallidos con un código $loginCode, el cual es incorrecto.',
      'timestamp': timestamp.toIso8601String(),
    });
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
              Text(
                "Iniciar Sesión",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 24),
              // Campo de entrada
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _loginCodeController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    border: InputBorder.none,
                    hintText: 'Código de Inicio de Sesión',
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 24),
              // Botón de inicio de sesión
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _validateLoginCode(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Text(
          "Acá va la cara",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}