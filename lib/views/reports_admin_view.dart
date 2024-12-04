import 'package:asia_project/widgets/bar_chart.dart';
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
            StudentTable(),
            BarChartWidget(
              chartTitle: "Attendance Chart",
              data: [
                ChartData(
                  barTitle: "CLAN GATES",
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
                  barTitle: "January",
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


