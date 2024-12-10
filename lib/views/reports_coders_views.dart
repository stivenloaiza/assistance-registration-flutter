import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_coder.dart';
import 'package:asia_project/widgets/reports_bi_widgets/coder_table.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_coder_widget.dart';
import 'package:flutter/material.dart';

class ReportsCoders extends StatefulWidget {
  const ReportsCoders({super.key});

  @override
  State<ReportsCoders> createState() => _ReportsCodersState();
}

class _ReportsCodersState extends State<ReportsCoders> {
  final Map<String, String> attendanceChartRefs = {
    'titleFirstValue': 'Absence',
    'titleSecondValue': 'Attendance',
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
            const HeaderCoder(),
            const FilterCoder(),
            BarChartWidget(
              chartTitle: "Attendance Chart",
              ref: attendanceChartRefs,
              data: attendanceChartData,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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

class CustomFABLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    double x = scaffoldGeometry.scaffoldSize.width - 65;
    double y = scaffoldGeometry.scaffoldSize.height - 155;
    return Offset(x, y);
  }
}
