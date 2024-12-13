import 'package:asia_project/models/user_model.dart';

class GlobalStateUser {
  static final GlobalStateUser _instance = GlobalStateUser._internal();

  // Constructor privado para implementar el patrón singleton
  GlobalStateUser._internal();

  // Acceso al único punto de instancia
  factory GlobalStateUser() => _instance;

  // Variable para almacenar el uid
  User? currentUser;
}