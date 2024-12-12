import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:asia_project/global_state.dart';

class LogoutWidget extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final VoidCallback? onLogoutComplete;

  LogoutWidget({super.key, this.onLogoutComplete});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showLogoutConfirmationDialog(context),
      child: const Text(
        'Cerrar Sesión',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Cerrar Sesión'),
              onPressed: () async {
                try {
                  await _auth.signOut();
                  // Si usas algún estado global, asegúrate de limpiar el estado
                  GlobalState().currentUserUid = null;

                  Navigator.of(context).pop(); // Cierra el diálogo

                  // Si se pasa la función onLogoutComplete, ejecutarla
                  if (onLogoutComplete != null) {
                    onLogoutComplete!(); // Redirige al login, por ejemplo
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sesión cerrada exitosamente'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  print('Error al cerrar sesión: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ocurrió un error al cerrar sesión'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
