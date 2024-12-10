import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores para email y contraseña
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _loginUser() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;

      if (user != null) {

        DocumentReference userDoc =
            _firestore.collection('users').doc(user.uid);


        DocumentSnapshot doc = await userDoc.get();
        if (doc.exists) {

          String nombre = doc['nombre'];
          print('Nombre del usuario: $nombre');
        } else {
          print('No se encontró el documento del usuario en Firestore');
        }

        if (doc.exists) {
          String role = doc['role'];

          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin_test');
          } else {
            Navigator.pushReplacementNamed(context, '/home_test');
          }
        }

        print('Usuario ha iniciado sesión: ${user.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Ocurrió un error. Inténtalo de nuevo.';

      if (e.code == 'user-not-found') {
        message = 'No se encontró ningún usuario con ese correo electrónico.';
      } else if (e.code == 'wrong-password') {
        message = 'La contraseña es incorrecta.';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(35),
            constraints: const BoxConstraints(
              maxWidth: 400,
              minHeight: 400,
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
                    'ASIA',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                // Campo Email
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon:
                        const Icon(Icons.email, color: Color(0xFF999999)),
                  ),
                ),
                const SizedBox(height: 35),
                // Campo Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    prefixIcon:
                        const Icon(Icons.lock, color: Color(0xFF999999)),
                  ),
                ),
                const SizedBox(height: 50),
                // Botón de inicio de sesión
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF007BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(
                    height:
                        20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Botón Registrarse
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegación registro
                          Navigator.pushNamed(context,
                              '/register');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Registrarse',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Navegación login
                          Navigator.pushNamed(context,
                              '/loginDevice');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007BFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Login Device',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
