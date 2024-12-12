import 'package:asia_project/widgets/custom_apbar_admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/card.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_admin_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/search_input_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/table_admin_reports.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
 // Importación del CustomAppBar

class DashboardPage extends StatefulWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const DashboardPage({
    Key? key,
    required this.isMobile,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
    final TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: CustomAppBar( 
        isMobile: widget.isMobile,
        onMenuPressed: widget.onMenuPressed,
        title: "Stadistics",
        searchController: searchController,
      ),
      body: SingleChildScrollView( // Envolvemos el cuerpo en un SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                const Column(
                  children: [
                    SizedBox(height: 16),
                    Text("No hay datos seleccionados."),
                    SizedBox(height: 16),
                    TipsCards()
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}

