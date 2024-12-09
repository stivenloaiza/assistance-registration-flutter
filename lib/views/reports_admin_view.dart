import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_Admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/coder_table.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_admin_widget.dart';
import 'package:flutter/material.dart';

class ReportsAdmin extends StatefulWidget {
  const ReportsAdmin({super.key});

  @override
  State<ReportsAdmin> createState() => _ReportsAdminState();
}

class _ReportsAdminState extends State<ReportsAdmin> {
  final Map<String, String> attendanceChartRefs = {
    'titleFirstValue': 'Justified Absence',
    'titleSecondValue': 'Unjustified Absence',
    'titleThirdValue': 'On-Time Attendance',
    'titleFourthValue': 'Late Attendance',
  };

  final List<ChartData> attendanceChartData = [
    ChartData(
      barTitle: "Sandra Pérez",
      numberFirstValue: 10,
      numberSecondValue: 10,
      numberThirdValue: 10,
      numberFourthValue: 10,
      average: 10,
    ),
    ChartData(
      barTitle: "Julian Sanders",
      numberFirstValue: 12,
      numberSecondValue: 8,
      numberThirdValue: 10,
      numberFourthValue: 10,
      average: 10,
    ),
    ChartData(
      barTitle: "Mario Zapata",
      numberFirstValue: 15,
      numberSecondValue: 10,
      numberThirdValue: 10,
      numberFourthValue: 10,
      average: 40,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderAdmin(),
            const Padding(
              padding: EdgeInsets.all(16.0),
            ),
            const FilterAdmin(),
            BarChartWidget(
              chartTitle: "Attendance Chart",
              ref: attendanceChartRefs,
              data: attendanceChartData,
            ),
            StudentTable(),
          ],
        ),
      ),
    );
  }
}
