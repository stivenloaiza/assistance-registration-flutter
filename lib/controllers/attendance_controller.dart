
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/ports/attendance_port.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceController implements AttendancePort{
  final AttendanceService _attendanceService;

  AttendanceController(this._attendanceService);

  @override
  Future<List<AttendanceModel>> findAllAttendance()async{
    return await _attendanceService.getAllAttendance();
  }

  @override
  Future<List<AttendanceModel>> findAttendanceByDateRange(String range)async{
    return await _attendanceService.getAttendanceByDateRange(range);
  }
}