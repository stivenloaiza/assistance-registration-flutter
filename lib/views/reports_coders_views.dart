import 'package:flutter/material.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart_two.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/table_coder_report.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_coder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsCoders extends StatefulWidget {
  const ReportsCoders({super.key});

  @override
  State<ReportsCoders> createState() => _ReportsCodersState();
}

class _ReportsCodersState extends State<ReportsCoders> {
  List<Map<String, dynamic>> tableData = [];
  List<ChartData> barChartData = [];
  List<double> lineChartData = [];
  List<String> lineChartRefs = [];
  bool showBarChart = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FilterCoder(
            onTableDataProcessed: (data) {
              setState(() {
                tableData = data;
              });
            },
            onBarChartDataProcessed: (data) {
              setState(() {
                barChartData = data;
              });
            },
            onLineChartDataProcessed: (data, refs) {
              setState(() {
                lineChartData = data;
                lineChartRefs = refs;
                showBarChart = false;
              });
            },
          ),
          const SizedBox(height: 16),
          AttendanceTable(data: tableData),
          const SizedBox(height: 16),
          if (showBarChart)
            Container(
              constraints: const BoxConstraints(
                minHeight: 200,
                maxHeight: 500,
                minWidth: double.infinity,
              ),
              padding: const EdgeInsets.all(16.0),
              child: barChartData.isNotEmpty
                  ? BarChartWidget(
                chartTitle: "Attendance Overview",
                data: barChartData,
                ref: {
                  'titleFirstValue': 'Absent',
                  'titleSecondValue': 'On-Time',
                  'titleThirdValue': 'Late',
                },
              )
                  : const Center(
                child: Text("No data available for the selected range."),
              ),
            )
          else
            lineChartData.isNotEmpty
                ? LineChart2(data: lineChartData, ref: lineChartRefs)
                : const Center(
              child: Text("No data available for the selected group."),
            ),
        ],
      ),
    );
  }
}
