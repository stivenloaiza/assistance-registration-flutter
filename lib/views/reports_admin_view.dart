import 'package:asia_project/widgets/reports_bi_widgets/bar_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/filters_Admin.dart';
import 'package:asia_project/widgets/reports_bi_widgets/coder_table.dart';
import 'package:asia_project/widgets/reports_bi_widgets/header_admin_widget.dart';
import 'package:asia_project/widgets/reports_bi_widgets/line_chart.dart';
import 'package:asia_project/widgets/reports_bi_widgets/pie_chart.dart';
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
            const HeaderAdmin(),
            const FilterAdmin()
          ],
        ),
      ),
    );
  }
}
