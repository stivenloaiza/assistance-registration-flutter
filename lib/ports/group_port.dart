
import 'package:asia_project/models/group_model.dart';

abstract class GroupPort{
  Future<List<GroupModel>> findAllGroup();
  Future<List<GroupModel>> findAllGroupByUserId(String userId);
}