
import 'package:asia_project/models/attendance_model.dart';

abstract class AttendancePort{
  Future<List<AttendanceModel>> findAllAttendance();
  Future<List<AttendanceModel>> findAttendanceByDateRange(String range);
  Future<AttendanceModel>
}