import 'package:flutter/material.dart';

class AttendanceTable extends StatefulWidget {
  final List<Map<String, dynamic>> data;

  const AttendanceTable({super.key, required this.data});

  @override
  State<AttendanceTable> createState() => _AttendanceTableState();
}

class _AttendanceTableState extends State<AttendanceTable> {
  int currentPage = 0;
  final int rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final paginatedData = widget.data.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

    return Column(
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text("Fecha")),
            DataColumn(label: Text("Registrados")),
            DataColumn(label: Text("Asistentes")),
            DataColumn(label: Text("A Tiempo")),
            DataColumn(label: Text("Tarde")),
            DataColumn(label: Text("Inasistentes")),
          ],
          rows: paginatedData.map((row) {
            return DataRow(cells: [
              DataCell(Text(row['date'])),
              DataCell(Text("${row['totalRegistered']}")),
              DataCell(Text("${row['attendees']}")),
              DataCell(Text("${row['onTime']}")),
              DataCell(Text("${row['late']}")),
              DataCell(Text("${row['absent']}")),
            ]);
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: currentPage > 0 ? () => setState(() => currentPage--) : null,
              child: const Text("Anterior"),
            ),
            TextButton(
              onPressed: (currentPage + 1) * rowsPerPage < widget.data.length
                  ? () => setState(() => currentPage++)
                  : null,
              child: const Text("Siguiente"),
            ),
          ],
        ),
      ],
    );
  }
}
