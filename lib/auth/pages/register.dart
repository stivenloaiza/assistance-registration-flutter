import 'package:asia_project/auth/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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
  DateTime? _fechaNacimiento;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _acceptTerms = false;

  Future<void> _selectFechaNacimiento() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != _fechaNacimiento) {
      setState(() {
        _fechaNacimiento = pickedDate;
      });
    }
  }

  Future<bool> _registerUser() async {
  if (!_acceptTerms) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Debes aceptar los términos y condiciones para registrarte.'),
      ),
    );
    return false; // Devuelve false si no se aceptaron los términos.
  }

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    User? user = userCredential.user;

    if (user != null) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'id': user.uid,
        'name': _nombre,
        'type_Doc': _tipoDocumento,
        'document_number': _numeroDocumento,
        'birth_date': _fechaNacimiento?.toIso8601String(),
        'email': user.email,
        'photo': '',
        'role': 'postulante',
        'status': 'inactivo',
        'face_data': '',
        'otp': 0,
        'terms': '',
        'created_by': '',
        'created_at': DateTime.now().toIso8601String(),
        'deleted_at': '',
        'deleted_by': '',
        'updated_at': '',
        'updated_by': '',
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuario registrado exitosamente')),
      );

      return true; // Devuelve true si el registro es exitoso.
    }
  } on FirebaseAuthException catch (e) {
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

  return false; // Devuelve false si ocurrió algún error.
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
                TextField(
  readOnly: true,
  decoration: InputDecoration(
    labelText: _fechaNacimiento == null
        ? 'Fecha de nacimiento'
        : 'Fecha: ${DateFormat('dd/MM/yyyy').format(_fechaNacimiento!)}',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    filled: true,
    fillColor: Colors.grey[100],
  ),
  onTap: _selectFechaNacimiento,
),
                const SizedBox(height: 25),
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
                const SizedBox(height: 25),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      onChanged: (bool? value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Acepto los términos y condiciones',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {
      // Llamar a la función de registro
      bool isRegistered = await _registerUser();

      if (isRegistered) {
        // Si el registro es exitoso, redirigir al login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Mostrar un mensaje de error si el registro falla
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al registrarse. Inténtalo nuevamente.')),
        );
      }
    },
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


