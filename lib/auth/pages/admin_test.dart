import 'package:flutter/material.dart';
import 'package:asia_project/global_state.dart';

class AdminTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Obtiene el UID del estado global
    String? userId = GlobalState().currentUserUid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Test'),
      ),
      body: Center(
        child: Text(
          'TEST: ${userId ?? "No encontrado"}', // Muestra el UID o un mensaje alternativo
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

