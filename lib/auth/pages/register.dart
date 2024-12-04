import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _nombre;
  String? _tipoDocumento;
  String? _numeroDocumento;

  // Controladores para email y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _registerUser() async {
    try {
      // Registro con email y contraseña
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Obtén el usuario registrado
      User? user = userCredential.user;

      if (user != null) {
        // Guarda los datos adicionales en Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'nombre': _nombre,
          'tipoDocumento': _tipoDocumento,
          'numeroDocumento': _numeroDocumento,
          'email': user.email,
          'uid': user.uid,
        });

        print('Usuario registrado: ${user.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario registrado exitosamente')),
        );
        // Puedes redirigir al usuario a otra pantalla si es necesario
      }
    } on FirebaseAuthException catch (e) {
      // Manejo de errores comunes
      String message;
      if (e.code == 'weak-password') {
        message = 'La contraseña es demasiado débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Este correo ya está registrado.';
      } else if (e.code == 'invalid-email') {
        message = 'Correo electrónico no válido.';
      } else {
        message = 'Error: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Fondo claro
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(35),
            constraints: const BoxConstraints(
              maxWidth: 400,
              minHeight: 500,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),
                // Campo Nombre
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nombre = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                // Campo Tipo de documento
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Tipo de documento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'CC',
                      child: Text('Cédula de ciudadanía'),
                    ),
                    DropdownMenuItem(
                      value: 'TI',
                      child: Text('Tarjeta de identidad'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _tipoDocumento = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                // Campo Número de documento
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Número de documento',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (value) {
                    setState(() {
                      _numeroDocumento = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                // Campo Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 25),
                // Campo Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 40),
                // Botón de registro
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

