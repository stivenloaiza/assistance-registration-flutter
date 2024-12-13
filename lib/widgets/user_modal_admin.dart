import 'package:asia_project/global_user.dart';
import 'package:asia_project/views/reports_coders_modal.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/models/user_model.dart';
import 'dart:math';

class UserModalWidget extends StatelessWidget {
  final User user;

  const UserModalWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Guardar el usuario en el estado global
    GlobalStateUser().currentUser = user;
    print(user.id);
    print("${GlobalStateUser().currentUser}");

    final random = Random();
    final skillsDevelopmentAttendance = (random.nextDouble() * 100).clamp(0.0, 100.0);
    final englishAttendance = (random.nextDouble() * 100).clamp(0.0, 100.0);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

 Widget contentBox(BuildContext context) {
  final mediaQuery = MediaQuery.of(context).size;

  return Center(
    child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: mediaQuery.width * 0.9, // Máximo 90% del ancho de la pantalla
          maxHeight: mediaQuery.height * 0.9, // Máximo 90% del alto de la pantalla
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 15),
              Text(
                user.email,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),
              // ReportsCoders ajustable
              Flexible(
                child: Container(
                  color: Colors.white,
                  child: const ReportsCodersModal(),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close', style: TextStyle(fontSize: 18)),
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