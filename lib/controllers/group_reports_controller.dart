
import 'package:asia_project/models/group_reports_model.dart';
import 'package:asia_project/ports/group_port.dart';
import 'package:asia_project/services/group_service.dart';

class GroupController implements GroupPort{
  final GroupService groupService;

  GroupController(this.groupService);

  @override
  Future<List<GroupModel>> findAllGroup() async{
    return await groupService.getAllGroup();
  }
  @override
  Future<List<GroupModel>> findAllGroupByUserId(String userId) async{
    return await groupService.getAllGroupByUserId(userId);
  }
}