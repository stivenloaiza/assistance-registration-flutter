
import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:flutter/material.dart';

abstract class AttendancePort{
  Future<List<AttendanceModel>> findAllAttendance();
  Future<List<AttendanceModel>> findAttendanceByDateRange(String range);
  Future<List<AttendanceModel>> findByProperty(String Property, String valueProperty);
  Future<Map<String, Map<String,dynamic>>> findAttendanceByUserAndDateRange(String userId, DateTimeRange dateRange);
  List<ChartData> processAttendanceForWidget(Map<String, Map<String, dynamic>> groupAttendance);
  Future<BarChartWidget> buildAttendanceWidget(String userId, DateTimeRange dateRange, String chartTitle);
}