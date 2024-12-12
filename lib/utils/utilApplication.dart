import 'package:asia_project/controllers/attendance_controller.dart';
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/models/group_reports_model.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UtilApplication {
  static String filterIdGroupBySelectedGroup(
      List<GroupModel> groups, String selectedGroup) {
    final filteredGroups =
        groups.where((group) => group.description == selectedGroup).toList();
    final _groupIdBySelectedGroup =
        filteredGroups.isNotEmpty ? filteredGroups.first.id : null;

    if (_groupIdBySelectedGroup != null) {
      print("ID del grupo seleccionado: $_groupIdBySelectedGroup");
      return _groupIdBySelectedGroup;
    } else {
      print("No se encontró ningún grupo con esa descripción.");
      return "There is not id";
    }
  }

  static Future<List<AttendanceModel>> attendanceFindByDateRangeInstance(
      FirebaseFirestore firestore, String range, String userId) async {
    final AttendanceService _attendanceService =
        AttendanceService(firestore: firestore);
    final AttendanceController _attendanceController =
        AttendanceController(_attendanceService);
    return await _attendanceController.findAttendanceByDateRange(range, userId);
  }

  static Future<List<AttendanceModel>> getAllAttendanceByUserIdInstance(
      FirebaseFirestore firestore, String userId) async {
    final AttendanceService _attendanceService =
        AttendanceService(firestore: firestore);
    final AttendanceController _attendanceController =
        AttendanceController(_attendanceService);
    return await _attendanceController.findByProperty("user", userId);
  }

   static Future<List<GroupModel>> getGroupsByUserId(
      FirebaseFirestore firestore, String userId) async {
    try {
      final querySnapshot = await firestore
          .collection('groups')
          .where('users_id', arrayContains: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => GroupModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching groups for userId $userId: $e");
      return [];
    }
  }

    static Future<String> getGroupTitleById(
      FirebaseFirestore firestore, String groupId) async {
    try {
      final docSnapshot = await firestore.collection('groups').doc(groupId).get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['title'] ?? 'Unknown Title';
      } else {
        return 'Group Not Found';
      }
    } catch (e) {
      print("Error fetching title for groupId $groupId: $e");
      return 'Error fetching group title';
    }
  }

}
