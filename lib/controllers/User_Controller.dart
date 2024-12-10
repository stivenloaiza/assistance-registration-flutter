import '../services/user_service.dart';
import '../models/user_model.dart';

class UserController {
  final UserService _userService;

  UserController(this._userService);

  // Obtener todos los usuarios
  Future<List<UserModel>> getAllUsers() async {
    try {
      return await _userService.getAllUsers();
    } catch (error) {
      throw Exception("Error al obtener usuarios: $error");
    }
  }

  // Obtener usuarios por una propiedad (por ejemplo, 'email')
  Future<List<UserModel>> getUsersByProperty(String property, String value) async {
    try {
      return await _userService.getByProperty(property, value);
    } catch (error) {
      throw Exception("Error al obtener usuarios por propiedad: $error");
    }
  }
}
