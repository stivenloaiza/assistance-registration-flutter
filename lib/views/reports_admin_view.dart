import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_Admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/coder_table.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_admin_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class ReportsAdmin extends StatefulWidget {
  const ReportsAdmin({super.key});

  @override
  State<ReportsAdmin> createState() => _ReportsAdminState();
}

class _ReportsAdminState extends State<ReportsAdmin> {
  final Map<String, String> attendanceChartRefs = {

    'titleFirstValue': 'Absent',
    'titleSecondValue': 'Present'

  };

  final List<ChartData> attendanceChartData = [
    ChartData(
      barTitle: "Sandra Pérez",
      numberFirstValue: 10,
      numberSecondValue: 10,
    ),
    ChartData(
      barTitle: "Julian Sanders",
      numberFirstValue: 12,
      numberSecondValue: 8,
    ),
    ChartData(
      barTitle: "Mario Zapata",
      numberFirstValue: 15,
      numberSecondValue: 10,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderAdmin(),
            const FilterAdmin(),
            BarChartWidget(
              chartTitle: "Attendance Overview",
              ref: attendanceChartRefs,
              data: attendanceChartData,
            ),

            StudentTable(),
            CustomPieChart(
              chartTitle: 'Attendance Overview',
              data: [
                PieData(pieTitle: 'Present', pieValue: 70, color: Colors.blue),
                PieData(pieTitle: 'Absent', pieValue: 20, color: Colors.red),
              ],
            ),
            const CustomLineChart(
              data: [30, 60, 90, 70, 50],
              ref: ['', 'Jan', 'May', 'Sep'],
            ),


          ],
        ),
      ),
    );
  }
}
