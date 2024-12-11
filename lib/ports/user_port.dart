
import 'package:asia_project/models/user_reports_model.dart';

abstract class UserPort{
  Future<List<UserModel>> getAllUsers();
}