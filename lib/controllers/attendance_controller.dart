
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/ports/attendance_port.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AttendanceController implements AttendancePort{
  final AttendanceService _attendanceService;

  AttendanceController(this._attendanceService);

  @override
  Future<List<AttendanceModel>> findAllAttendance()async{
    return await _attendanceService.getAllAttendance();
  }

  @override
  Future<List<AttendanceModel>> findAttendanceByDateRange(String range, String userId)async{
    return await _attendanceService.getAttendanceByDateRange(range, userId);
  }

  @override
  Future<List<AttendanceModel>> findByProperty(String property, String valueProperty) async{
    return await _attendanceService.getAttendanceByProperty(property, valueProperty);
  }

  @override
  Future<Map<String, Map<String, dynamic>>> findAttendanceByUserAndDateRange(
      String userId,
      DateTimeRange dateRange,
      String groupId,
      ) async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('user', isEqualTo: userId)
          .where('timeStamp', isGreaterThanOrEqualTo: dateRange.start)
          .where('timeStamp', isLessThanOrEqualTo: dateRange.end)
          .where('group', isEqualTo: groupId) // Filtramos por grupo
          .get();
      print("ddd ${snapshot.docs}");

      final Map<String, Map<String, dynamic>> groupAttendance = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String status = data['attendanceStatus'];

        groupAttendance[groupId] ??= {'late': 0, 'onTime': 0, 'absent': 0};
        groupAttendance[groupId]?[status] =
            (groupAttendance[groupId]?[status] ?? 0) + 1;
      }
      print("groupAttendance -- $groupAttendance");
      return groupAttendance;
    } catch (e) {
      throw Exception("Error fetching attendance data: $e");
    }
  }


  @override
  List<ChartData> processAttendanceForWidget(Map<String, Map<String, dynamic>> groupAttendance) {
    final List<ChartData> chartData = [];
    groupAttendance.forEach((groupId, attendance) {
      final int totalRecords = attendance.values.fold<int>(
        0,
            (sum, value) => sum + (value as int),
      );
      final double absentPercentage =
          ((attendance['absent'] ?? 0) / totalRecords) * 100;
      final double onTimePercentage =
          ((attendance['onTime'] ?? 0) / totalRecords) * 100;
      final double latePercentage =
          ((attendance['late'] ?? 0) / totalRecords) * 100;

      chartData.add(ChartData(
        barTitle: groupId,
        numberFirstValue: absentPercentage,
        numberSecondValue: onTimePercentage,
        numberThirdValue: latePercentage,
      ));
    });

    return chartData;
  }

  @override
  Future<BarChartWidget> buildAttendanceWidget(
      String userId,
      DateTimeRange dateRange,
      String chartTitle,
      String groupId, // Añadimos el groupId
      ) async {
    print("""
    $userId,
    $dateRange, 
    $chartTitle,
    $groupId
    """);
    final groupAttendance = await findAttendanceByUserAndDateRange(userId, dateRange, groupId); // Filtramos por grupo
    final List<AttendanceModel> attendanceByGroup = await findByProperty("group", groupId); // Get all attendance by groupId
    attendanceByGroup.forEach((attendance){
      print("Attendance: ${attendance.toString()}");
    });
    final List<ChartData> chartData = processAttendanceForWidget(groupAttendance);

    print("groupAttendance $groupAttendance");
    print("chartDATA ${chartData}");
    return BarChartWidget(
      chartTitle: chartTitle,
      ref: {
        'titleFirstValue': 'Absent',
        'titleSecondValue': 'Present',
        'titleThirdValue': 'Delay',
      },
      data: chartData,
    );
  }

}