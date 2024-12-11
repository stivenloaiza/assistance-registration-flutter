import 'package:asia_project/controllers/attendance_controller.dart';
import 'package:asia_project/ports/attendance_port.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_coder.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_coder_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsCoders extends StatefulWidget {
  const ReportsCoders({super.key});

  @override
  State<ReportsCoders> createState() => _ReportsCodersState();
}

class _ReportsCodersState extends State<ReportsCoders> {
  final String userId = "gQyFZVUf8rzjlpYl1gIv";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AttendanceController _attendanceController;
  late AttendanceService _attendanceService;

  late Future<BarChartWidget> _attendanceWidget;
  String selectedGroupId = 'dd'; // Almacenamos el grupo seleccionado

  final DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _attendanceService = AttendanceService(firestore: _firestore);
    _attendanceController = AttendanceController(_attendanceService);
    print("selectedGroup $selectedGroupId");
    _attendanceWidget = _attendanceController.buildAttendanceWidget(
        userId, dateRange, "Attendance overview", selectedGroupId);
  }

  // Callback para manejar el grupo seleccionado
  void _onGroupSelected(String groupId) {
    setState(() {
      selectedGroupId = groupId;
    });
    _updateAttendanceWidget();
  }

  // Método para actualizar las estadísticas (gráfico)
  void _updateAttendanceWidget() {
    setState(() {
      _attendanceWidget = _attendanceController.buildAttendanceWidget(
        userId,
        dateRange,
        "Attendance overview",
        selectedGroupId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderCoder(),
            FilterCoder(onGroupSelected: _onGroupSelected), // Pasamos el callback aquí

            FutureBuilder<BarChartWidget>(
              future: _attendanceWidget,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return snapshot.data!; // Aquí mostramos el gráfico
                }
              },
            ),
            CustomLineChart(
              data: [30, 60, 90, 70, 50],
              ref: ['', 'Jan', 'May', 'Sep'],
            ),
          ],
        ),
      ),
    );
  }
}
