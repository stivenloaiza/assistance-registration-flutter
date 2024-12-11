import 'package:asia_project/controllers/attendance_controller.dart';
import 'package:asia_project/ports/attendance_port.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_coder.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_coder_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
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
