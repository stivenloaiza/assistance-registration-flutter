
import 'package:asia_project/controllers/attendance_controller.dart';
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/models/group_reports_model.dart';
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

  static Future<List<AttendanceModel>> attendanceFindByDateRangeInstance(FirebaseFirestore firestore, String range, String userId)async{
    final AttendanceService _attendanceService = AttendanceService(firestore: firestore);
    final AttendanceController _attendanceController = AttendanceController(_attendanceService);
    return await _attendanceController.findAttendanceByDateRange(range, userId);
  }

  static Future<List<AttendanceModel>> getAllAttendanceByUserIdInstance(FirebaseFirestore firestore, String userId)async{
    final AttendanceService _attendanceService = AttendanceService(firestore: firestore);
    final AttendanceController _attendanceController = AttendanceController(_attendanceService);
    return await _attendanceController.findByProperty("user", userId);
  }
}