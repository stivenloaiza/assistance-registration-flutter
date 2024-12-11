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

Future<Map<String, Map<String, dynamic>>> fetchAttendanceData(
    String userId, DateTimeRange dateRange) async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('attendance')
        .where('user', isEqualTo: userId)
        .where('timeStamp', isGreaterThanOrEqualTo: dateRange.start)
        .where('timeStamp', isLessThanOrEqualTo: dateRange.end)
        .get();

    // Mapa para almacenar los nombres de grupos asociados a los IDs
    final Map<String, String> groupIdToTitle = {};

    // Obtener los IDs únicos de los grupos en los registros de attendance
    final Set<String> groupIds = snapshot.docs
        .map((doc) => (doc.data() as Map<String, dynamic>)['group'] as String)
        .toSet();

    // Cargar los nombres de los grupos desde la colección groups
    final QuerySnapshot groupSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where(FieldPath.documentId, whereIn: groupIds.toList())
        .get();

    for (var doc in groupSnapshot.docs) {
      groupIdToTitle[doc.id] = doc['title'];
    }

    final Map<String, Map<String, dynamic>> groupAttendance = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final String groupId = data['group'];
      final String status = data['attendanceStatus'];

      // Obtener el nombre del grupo usando el mapa creado anteriormente
      final String groupTitle = groupIdToTitle[groupId] ?? 'Unknown Group';

      groupAttendance[groupTitle] ??= {'late': 0, 'onTime': 0, 'absent': 0};
      groupAttendance[groupTitle]?[status] =
          (groupAttendance[groupTitle]?[status] ?? 0) + 1;
    }

    return groupAttendance;
  } catch (e) {
    throw Exception("Error fetching attendance data: $e");
  }
}


List<ChartData> processAttendanceForWidget(
    Map<String, Map<String, dynamic>> groupAttendance) {
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

Future<BarChartWidget> buildAttendanceWidget(
    String userId, DateTimeRange dateRange, String chartTitle) async {
  final groupAttendance = await fetchAttendanceData(userId, dateRange);
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
  late Future<BarChartWidget> _attendanceWidget;

  @override
  void initState() {
    super.initState();
    // Inicialización de servicio y controlador
    _attendanceService = AttendanceService(firestore: _firestore);
    _attendanceController = AttendanceController(_attendanceService);
    _attendanceWidget = _attendanceController.buildAttendanceWidget(
        userId, dateRange, "Visualización de Asistencia");
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
              future: _attendanceWidget,
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
            CustomLineChart(
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
