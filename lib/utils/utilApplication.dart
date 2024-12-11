
import 'package:asia_project/controllers/attendance_controller.dart';
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/models/group_model.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UtilApplication{

  static String filterIdGroupBySelectedGroup (List<GroupModel> groups, String selectedGroup){
    final filteredGroups = groups.where((group) => group.description == selectedGroup).toList();
    final _groupIdBySelectedGroup = filteredGroups.isNotEmpty ? filteredGroups.first.id : null;

    if (_groupIdBySelectedGroup != null) {
      print("ID del grupo seleccionado: $_groupIdBySelectedGroup");
      return _groupIdBySelectedGroup;
    } else {
      print("No se encontró ningún grupo con esa descripción.");
      return "There is not id";
    }
  }

  static Future<List<AttendanceModel>> attendanceFindByDateRangeInstance(FirebaseFirestore firestore, String range)async{
    final AttendanceService _attendanceService = AttendanceService(firestore: firestore);
    final AttendanceController _attendanceController = AttendanceController(_attendanceService);
    return await _attendanceController.findAttendanceByDateRange(range);
  }

  static Future<List<AttendanceModel>> getAllAttendanceInstance(FirebaseFirestore firestore)async{
    final AttendanceService _attendanceService = AttendanceService(firestore: firestore);
    final AttendanceController _attendanceController = AttendanceController(_attendanceService);
    return await _attendanceController.findAllAttendance();
  }
}