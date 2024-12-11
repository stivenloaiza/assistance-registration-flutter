import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:html' as html;
import 'package:pdf/pdf.dart';



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
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
  onPressed: () => _downloadPDFWeb(), // Usa la versión web
  child: const Text("Descargar PDF"),
),

            const SizedBox(width: 16),
            ElevatedButton(
  onPressed: () => _downloadExcelWeb(),
  child: const Text("Descargar Excel"),
),

          ],
        ),
      ],
    );
  }

  Future<void> _downloadExcelWeb() async {
  final excel = Excel.createExcel();
  final sheet = excel['Asistencia'];

  // Agregar encabezados
  sheet.appendRow(["Fecha", "Registrados", "Asistentes", "A Tiempo", "Tarde", "Inasistentes"]);

  // Agregar datos
  for (var row in widget.data) {
    sheet.appendRow([
      row['date'],
      row['totalRegistered'],
      row['attendees'],
      row['onTime'],
      row['late'],
      row['absent']
    ]);
  }

  // Convertir el archivo Excel a bytes
  final List<int> bytes = excel.encode()!;

  // Crear un Blob y una URL
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Descargar el archivo
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = 'attendance_table.xlsx'
    ..click();

  // Liberar la URL
  html.Url.revokeObjectUrl(url);
}

// Para guardar archivos
Future<void> _downloadPDFWeb() async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Table.fromTextArray(
          headers: ["Fecha", "Registrados", "Asistentes", "A Tiempo", "Tarde", "Inasistentes"],
          data: widget.data.map((row) {
            return [
              row['date'],
              row['totalRegistered'],
              row['attendees'],
              row['onTime'],
              row['late'],
              row['absent']
            ];
          }).toList(),
        );
      },
    ),
  );

  // Convertir el PDF a bytes
  final bytes = await pdf.save();

  // Crear un Blob y una URL
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Descargar el archivo
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = 'attendance_table.pdf'
    ..click();

  // Liberar la URL
  html.Url.revokeObjectUrl(url);
}
Future<void> _downloadPDF() async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Table.fromTextArray(
          headers: ["Fecha", "Registrados", "Asistentes", "A Tiempo", "Tarde", "Inasistentes"],
          data: widget.data.map((row) {
            return [
              row['date'],
              row['totalRegistered'],
              row['attendees'],
              row['onTime'],
              row['late'],
              row['absent']
            ];
          }).toList(),
        );
      },
    ),
  );

  try {
    // Obtener el directorio de almacenamiento
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/attendance_table.pdf";

    // Guardar el archivo PDF
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Archivo PDF guardado en: $filePath")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al guardar el archivo PDF: $e")),
    );
  }
}


 Future<void> _downloadExcel() async {
  final excel = Excel.createExcel();
  final sheet = excel['Asistencia'];

  // Agregar encabezados
  sheet.appendRow(["Fecha", "Registrados", "Asistentes", "A Tiempo", "Tarde", "Inasistentes"]);

  // Agregar datos
  for (var row in widget.data) {
    sheet.appendRow([
      row['date'],
      row['totalRegistered'],
      row['attendees'],
      row['onTime'],
      row['late'],
      row['absent']
    ]);
  }

  try {
    // Obtener el directorio de almacenamiento
    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/attendance_table.xlsx";

    // Guardar el archivo Excel
    final file = File(filePath);
    final bytes = Uint8List.fromList(excel.encode()!);
    await file.writeAsBytes(bytes);

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Archivo Excel guardado en: $filePath")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error al guardar el archivo Excel: $e")),
    );
  }
}



}
