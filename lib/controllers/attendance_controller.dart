
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
  Future<List<AttendanceModel>> findAttendanceByDateRange(String range)async{
    return await _attendanceService.getAttendanceByDateRange(range);
  }

  @override
  Future<List<AttendanceModel>> findByProperty(String property, String valueProperty) async{
    return await _attendanceService.getAttendanceByProperty(property, valueProperty);
  }

  @override
  Future<Map<String, Map<String, dynamic>>> findAttendanceByUserAndDateRange(String userId, DateTimeRange dateRange) async{
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('attendance')
          .where('user', isEqualTo: userId)
          .where('timeStamp', isGreaterThanOrEqualTo: dateRange.start)
          .where('timeStamp', isLessThanOrEqualTo: dateRange.end)
          .get();

      final Map<String, Map<String, dynamic>> groupAttendance = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final String groupId = data['group'];
        final String status = data['attendanceStatus'];

        groupAttendance[groupId] ??= {'late': 0, 'onTime': 0, 'absent': 0};
        groupAttendance[groupId]?[status] =
            (groupAttendance[groupId]?[status] ?? 0) + 1;
      }

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
  Future<BarChartWidget> buildAttendanceWidget(String userId, DateTimeRange dateRange, String chartTitle) async{
    final groupAttendance = await findAttendanceByUserAndDateRange(userId, dateRange);
    final List<ChartData> chartData = processAttendanceForWidget(groupAttendance);

    return BarChartWidget(
      chartTitle: chartTitle,
      ref: {
        'titleFirstValue': 'Absent',
        'titleSecondValue': 'On-Time',
        'titleThirdValue': 'Late',
      },
      data: chartData,
    );
  }
}