import 'package:flutter/material.dart';
import 'package:asia_project/widgets/HeaderWidget.dart';
import 'package:asia_project/widgets/SearchInputWidget.dart';
import 'package:asia_project/widgets/filter_admin.dart';
import 'package:asia_project/widgets/student_table.dart';
import 'package:asia_project/widgets/bar_chart.dart';

class ReportsAdmin extends StatefulWidget {
  const ReportsAdmin({Key? key}) : super(key: key);

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
            const HeaderWidget(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SearchInputWidget(),
            ),
            const FilterAdmin(),
            StudentTable(),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: constraints.maxWidth > 600 ? 400 : 300,
                  padding: const EdgeInsets.all(16),
                  child: BarChartSample2(
                    chartTitle: "Attendance Chart",
                    data: [
                      ChartData(
                        barTitle: "Sandra Pérez",
                        attendanceNumber: 10,
                        absencesNumber: 10,
                      ),
                      ChartData(
                        barTitle: "Julian Sanders",
                        attendanceNumber: 12,
                        absencesNumber: 8,
                      ),
                      ChartData(
                        barTitle: "Mario Zapata",
                        attendanceNumber: 70,
                        absencesNumber: 10,
                      ),
                    ],
                    backgroundColor: Colors.white,
                    attendanceColor: const Color.fromRGBO(22, 219, 204, 1),
                    absenceColor: const Color.fromRGBO(255, 130, 172, 1),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

