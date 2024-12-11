import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asia_project/models/group_reports_model.dart';
import 'package:asia_project/controllers/group_reports_controller.dart';
import 'package:asia_project/services/group_service.dart';
import 'package:asia_project/utils/utilApplication.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/models/attendance_model.dart';

class FilterCoder extends StatefulWidget {
  final Function(List<Map<String, dynamic>>) onTableDataProcessed;
  final Function(List<ChartData>) onBarChartDataProcessed;
  final Function(List<double>, List<String>) onLineChartDataProcessed;

  const FilterCoder({
    super.key,
    required this.onTableDataProcessed,
    required this.onBarChartDataProcessed,
    required this.onLineChartDataProcessed,
  });

  @override
  State<FilterCoder> createState() => _FilterCoderState();
}

class _FilterCoderState extends State<FilterCoder> {
  String? selectedGroup;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<GroupModel>> _groupFuture;
  final String userId = "gQyFZVUf8rzjlpYl1gIv";

  @override
  void initState() {
    super.initState();
    final groupService = GroupService(firestore: _firestore);
    final groupController = GroupController(groupService);
    _groupFuture = groupController.findAllGroupByUserId(userId);

    // Renderizar datos iniciales para "1 año"
    loadAndProcessAttendance("1 año");
  }

  /// Procesa la asistencia para los botones de filtrado por fecha
    /// Procesa la asistencia para los botones de filtrado por fecha
  Future<List<ChartData>> processAttendanceForBarChart(
      List<AttendanceModel> attendanceList) async {
    final Map<String, Map<String, int>> groupAttendance = {};
    final Map<String, String> groupTitlesCache = {};

    for (var attendance in attendanceList) {
      final groupId = attendance.group;
      final status = attendance.attendanceStatus;

      groupAttendance[groupId] ??= {'late': 0, 'onTime': 0, 'absent': 0};
      groupAttendance[groupId]?[status] =
          (groupAttendance[groupId]?[status] ?? 0) + 1;

      // Verificar si ya tenemos el título en caché para no repetir consultas
      if (!groupTitlesCache.containsKey(groupId)) {
        groupTitlesCache[groupId] =
            await UtilApplication.getGroupTitleById(_firestore, groupId);
      }
    }

    return groupAttendance.entries.map((entry) {
      final groupId = entry.key;
      final attendance = entry.value;

      final totalRecords = attendance.values.fold(0, (a, b) => a + b);
      final double absentPercentage =
          totalRecords > 0 ? ((attendance['absent'] ?? 0) / totalRecords) * 100 : 0.0;
      final double onTimePercentage =
          totalRecords > 0 ? ((attendance['onTime'] ?? 0) / totalRecords) * 100 : 0.0;
      final double latePercentage =
          totalRecords > 0 ? ((attendance['late'] ?? 0) / totalRecords) * 100 : 0.0;

      // Usar el título del grupo como barTitle
      return ChartData(
        barTitle: groupTitlesCache[groupId] ?? groupId,
        numberFirstValue: absentPercentage,
        numberSecondValue: onTimePercentage,
        numberThirdValue: latePercentage,
      );
    }).toList();
  }

  /// Procesa la asistencia para el filtrado por grupo
  Future<List<Map<String, dynamic>>> fetchAttendanceByGroup(String groupId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('attendance')
          .where('group', isEqualTo: groupId)
          .where('user', isEqualTo: userId)
          .get();

      List<Map<String, dynamic>> attendanceData = [];

      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String date = (data['timeStamp'] as Timestamp).toDate().toIso8601String().split('T').first;
        String status = data['attendanceStatus'] ?? "Unknown";

        attendanceData.add({
          'date': date,
          'status': status,
        });
      }

      return attendanceData;
    } catch (e) {
      print("Error fetching attendance data: $e");
      return [];
    }
  }

  void processAndSendGroupData(String groupId) async {
    final attendanceData = await fetchAttendanceByGroup(groupId);

    List<double> chartData = [];
    List<String> ref = [];

    for (var entry in attendanceData) {
      double value = (entry['status'] == 'onTime'
          ? 3.0
          : entry['status'] == 'late'
              ? 2.0
              : entry['status'] == 'absent'
                  ? 1.0
                  : 0.0);
      chartData.add(value);
      ref.add(entry['date']);
    }

    widget.onTableDataProcessed(attendanceData);
    widget.onLineChartDataProcessed(chartData, ref);
  }

    Future<void> loadAndProcessAttendance(String range) async {
    final attendanceList = await UtilApplication.attendanceFindByDateRangeInstance(
      _firestore,
      range,
      userId,
    );

    // Transformar los datos de asistencia para la tabla
    List<Map<String, dynamic>> attendanceData = attendanceList.map((e) {
      String date = (e.timeStamp as Timestamp).toDate().toIso8601String().split('T').first;
      String status = e.attendanceStatus ?? "Unknown";
      return {
        'date': date,
        'status': status,
      };
    }).toList();

    // Procesar datos para el BarChart
    final List<ChartData> barChartData =
        await processAttendanceForBarChart(attendanceList);

    widget.onTableDataProcessed(attendanceData);
    widget.onBarChartDataProcessed(barChartData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
  color: Colors.white, // Fondo blanco
  child: Column(
    children: [
      const SizedBox(height: 5),
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/filtra-logo.png',
                  width: 100.0,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FutureBuilder<List<GroupModel>>(
                    future: _groupFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No groups available');
                      } else {
                        final groups = snapshot.data!;
                        return DropdownButtonFormField<String>(
                          value: selectedGroup,
                          hint: const Text("Seleccionar grupo"),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedGroup = newValue;
                            });
                            if (newValue != null) {
                              processAndSendGroupData(newValue);
                            }
                          },
                          items: groups.map((group) {
                            return DropdownMenuItem<String>(
                              value: group.id,
                              child: Text(group.title ?? "No Title"),
                            );
                          }).toList(),
                          dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(247, 242, 250, 1),
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 15,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => loadAndProcessAttendance("1 mes"),
                  child: const Text("Month"),
                ),
                ElevatedButton(
                  onPressed: () => loadAndProcessAttendance("1 año"),
                  child: const Text("Year"),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);
  }
}
