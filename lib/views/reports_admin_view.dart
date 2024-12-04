import 'package:asia_project/widgets/bar_chart.dart';
import 'package:asia_project/widgets/filter_admin.dart';
import 'package:asia_project/widgets/student_table.dart';
import 'package:flutter/material.dart';

class ReportsAdmin extends StatefulWidget {
  const ReportsAdmin({super.key});

  @override
  State<ReportsAdmin> createState() => _ReportsAdminState();
}

class _ReportsAdminState extends State<ReportsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FilterAdmin(),
            StudentTable(),
            BarChartWidget(
              chartTitle: "Attendance Chart",
              data: [
                ChartData(
                  barTitle: "Sandra Pérez",
                  attendanceNumber: 10,
                  absencesNumber: 10,
                  average: 10,
                ),
                ChartData(
                  barTitle: "Julian Sanders",
                  attendanceNumber: 12,
                  absencesNumber: 8,
                  average: 10,
                ),
                ChartData(
                  barTitle: "Mario Zapata",
                  attendanceNumber: 70,
                  absencesNumber: 10,
                  average: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


