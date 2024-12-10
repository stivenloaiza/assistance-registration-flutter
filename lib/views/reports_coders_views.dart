import 'package:asia_project/controllers/attendance_controller.dart';
import 'package:asia_project/ports/attendance_port.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_coder.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_coder_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/pie_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsCoders extends StatefulWidget {
  const ReportsCoders({super.key});

  @override
  State<ReportsCoders> createState() => _ReportsCodersState();
}

class _ReportsCodersState extends State<ReportsCoders> {
  // Variables principales
  final String userId = "gQyFZVUf8rzjlpYl1gIv";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late AttendanceController _attendanceController;
  late AttendanceService _attendanceService;

  // Rango de fechas
  final DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  // Widget futuro para gráficos
  late Future<BarChartWidget> attendanceWidget;

  @override
  void initState() {
    super.initState();
    // Inicialización de servicio y controlador
    _attendanceService = AttendanceService(firestore: _firestore);
    _attendanceController = AttendanceController(_attendanceService);

    // Inicializa el widget futuro
    attendanceWidget = Future.value(BarChartWidget(
      userId: userId,
      dateRange: dateRange,
      chartTitle: "Attendance Overview",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderCoder(),
            const FilterCoder(),
            // Builder para el gráfico de barras
            FutureBuilder<BarChartWidget>(
              future: attendanceWidget,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return snapshot.data!;
                }
              },
            ),
            // Gráfico de pastel
            CustomPieChart(
              chartTitle: 'Attendance Overview',
              data: [
                PieData(pieTitle: 'Present', pieValue: 70, color: Colors.blue),
                PieData(pieTitle: 'Absent', pieValue: 20, color: Colors.red),
              ],
            ),
            // Gráfico de línea
            const CustomLineChart(
              data: [30, 60, 90, 70, 50],
              ref: ['', 'Jan', 'May', 'Sep'],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción del botón flotante
        },
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: CustomFABLocation(),
    );
  }
}

// Clase personalizada para la posición del botón flotante
class CustomFABLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    double x = scaffoldGeometry.scaffoldSize.width - 65;
    double y = scaffoldGeometry.scaffoldSize.height - 155;
    return Offset(x, y);
  }
}
