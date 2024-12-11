import 'package:asia_project/widgets/reports_bi_widgets/header_admin_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/table_admin_reports.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
class ReportsAdmin extends StatefulWidget {
  const ReportsAdmin({super.key});

  @override
  State<ReportsAdmin> createState() => _ReportsAdminState();
}

class _ReportsAdminState extends State<ReportsAdmin> {
  Map<String, dynamic> generateChartData(
      List<Map<String, dynamic>> attendanceData) {
    // Extraer datos para los gráficos
    final List<double> onTimeData = attendanceData
        .map((entry) => entry['onTimePercentage'] as double)
        .toList();
    final List<double> absentData = attendanceData
        .map((entry) => entry['absentPercentage'] as double)
        .toList();
    final List<double> lateData = attendanceData
        .map((entry) => entry['latePercentage'] as double)
        .toList();

    // Calcular referencias para el eje X (ref)
    final int length = attendanceData.length;
    final String firstDate = attendanceData.first['date'];
    final String middleDate = attendanceData[length ~/ 2]['date'];
    final String lastDate = attendanceData.last['date'];

    return {
      'onTimeData': onTimeData,
      'absentData': absentData,
      'lateData': lateData,
      'ref': ["", firstDate, middleDate, lastDate],
    };
  }

  final AttendanceService attendanceService = AttendanceService(
    firestore: FirebaseFirestore.instance,
  );

  String? selectedGroup;
  List<Map<String, dynamic>> attendanceData = [];
  bool isLoading = false;

  Map<String, dynamic>? chartData;

  Future<void> loadAttendanceData(String groupTitle) async {
    setState(() {
      isLoading = true;
    });
    try {
      final data = await attendanceService.getAttendanceAverages(groupTitle);
      final generatedChartData = generateChartData(data);
      setState(() {
        attendanceData = data;
        chartData = generatedChartData;
        print(attendanceData);
      });
    } catch (e) {
      print("Error loading attendance data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderAdmin(),
            
            FilterAdmin(
              onGroupSelected: (groupTitle) {
                setState(() {
                  selectedGroup = groupTitle;
                });
                loadAttendanceData(groupTitle);
              },
            ),
            if (isLoading)
              const CircularProgressIndicator()
            else if (attendanceData.isNotEmpty && chartData != null) ...[
              AttendanceTable(data: attendanceData),
              const SizedBox(height: 16),
              CustomLineChart(
                data: chartData!['onTimeData'],
                ref: chartData!['ref'],
              ),
              const Text(
                "On Time Attendance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomLineChart(
                data: chartData!['absentData'],
                ref: chartData!['ref'],
              ),
              const Text(
                "Absent Attendance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomLineChart(
                data: chartData!['lateData'],
                ref: chartData!['ref'],
              ),
              const Text(
                "Late Attendance",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ] else
              const Text("No hay datos disponibles"),
          ],
        ),
      ),
    );
  }
}
