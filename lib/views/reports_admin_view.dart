import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_Admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/coder_table.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_admin_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/pie_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/search_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            HeaderAdmin(),
            SearchInputWidget(),
            FilterAdmin(),
            // Gráfico de línea
            CustomLineChart(
              data: [30, 60, 90, 70, 50],
              ref: ['', 'Jan', 'May', 'Sep'],
            ),
            CustomPieChart(
              chartTitle: 'Visualización de Asistencia',
              data: [
                PieData(
                    pieTitle: 'Ausencia',
                    pieValue: 70,
                    color: Color.fromRGBO(252, 121, 0, 1)),
                PieData(
                    pieTitle: 'Retraso',
                    pieValue: 70,
                    color: Color.fromARGB(255, 125, 194, 237)),
                PieData(
                    pieTitle: 'Presente',
                    pieValue: 20,
                    color: Color.fromRGBO(24, 20, 243, 1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
