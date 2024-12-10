
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceController{
  final AttendanceService _attendanceService;

  AttendanceController(this._attendanceService);

  Future<List<AttendanceModel>> findAllAttendance()async{
    return await _attendanceService.getAllAttendance();
  }

  Future<List<AttendanceModel>> findAttendanceByDateRange(String range)async{
    return await _attendanceService.getAttendanceByDateRange(range);
  }
}