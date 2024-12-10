import 'package:asia_project/ports/user_port.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';

class UserController implements UserPort {
  final UserService _userService;

  UserController(this._userService);

  // Get all users
  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      return await _userService.getAllUsers();
    } catch (error) {
      throw Exception("Error to get users: $error");
    }
  }
  // Get users by property
  @override
  Future<List<UserModel>> getUsersByProperty(String property, String value) async {
    try {
      return await _userService.getByProperty(property, value);
    } catch (error) {
      throw Exception("Error to get users by property: $error");
    }
  }

}
