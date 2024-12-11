import 'package:flutter/material.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart_two.dart';
import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/table_coder_report.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_coder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_coder_widget.dart';
import 'package:flutter/material.dart';

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

  /// Callback para manejar los datos procesados de la tabla y BarChart
  void _onTableAndBarChartDataProcessed(
      List<Map<String, dynamic>> tableData, List<ChartData> barChartData) {
    setState(() {
      this.tableData = tableData;
      this.barChartData = barChartData;
      showBarChart = true; // Mostrar el BarChart al filtrar por fecha
    });
  }

  /// Callback para manejar los datos procesados de LineChart2
  void _onLineChartDataProcessed(List<double> lineChartData, List<String> refs) {
    setState(() {
      this.lineChartData = lineChartData;
      this.lineChartRefs = refs;
      showBarChart = false; // Mostrar el LineChart al filtrar por grupo
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderCoder(),
            FilterCoder(
              onTableDataProcessed: (data) {
                _onTableAndBarChartDataProcessed(data, barChartData);
              },
              onBarChartDataProcessed: (data) {
                _onTableAndBarChartDataProcessed(tableData, data);
              },
              onLineChartDataProcessed: _onLineChartDataProcessed,
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
              Container(
                constraints: const BoxConstraints(
                  minHeight: 200,
                  maxHeight: 500,
                  minWidth: double.infinity,
                ),
                padding: const EdgeInsets.all(16.0),
                child: lineChartData.isNotEmpty
                    ? LineChart2(data: lineChartData, ref: lineChartRefs)
                    : const Center(
                        child: Text("No data available for the selected group."),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
