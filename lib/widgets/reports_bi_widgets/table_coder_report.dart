import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import "package:universal_html/html.dart" as html;


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
    final paginatedData =
        widget.data.skip(currentPage * rowsPerPage).take(rowsPerPage).toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateProperty.resolveWith(
                (states) => Colors.white,
              ),
              dataRowColor: MaterialStateProperty.resolveWith(
                (states) => Colors.white,
              ),
              columnSpacing: 0.0, // Elimina el espaciado adicional
              columns: [
                DataColumn(
                  label: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho
                    child: Text(
                      "Fecha",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                DataColumn(
                  label: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho
                    child: Text(
                      "Estado",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              rows: paginatedData.map((row) {
                return DataRow(cells: [
                  DataCell(
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho
                      child: Text(
                        row['date'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5, // 50% del ancho
                      child: Text(
                        row['status'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: row['status'] == "onTime"
                              ? Colors.green
                              : row['status'] == "late"
                                  ? Colors.orange
                                  : Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed:
                  currentPage > 0 ? () => setState(() => currentPage--) : null,
              child: const Text(
                "Anterior",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: (currentPage + 1) * rowsPerPage < widget.data.length
                  ? () => setState(() => currentPage++)
                  : null,
              child: const Text(
                "Siguiente",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "Descargar Información",
          style: TextStyle(
              fontSize: 14,
              color: Color(0xFF343C6A),
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF343C6A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => _downloadPDFWeb(),
              child: const Text(
                "PDF",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF343C6A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onPressed: () => _downloadExcelWeb(),
              child: const Text(
                "Excel",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _downloadPDFWeb() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Table.fromTextArray(
            headers: ["Fecha", "Estado"],
            data: widget.data.map((row) {
              return [
                row['date'],
                row['status'],
              ];
            }).toList(),
          );
        },
      ),
    );

    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'attendance_table.pdf'
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<void> _downloadExcelWeb() async {
    final excel = Excel.createExcel();
    final sheet = excel['Asistencia'];

    sheet.appendRow(["Fecha", "Estado"]);

    for (var row in widget.data) {
      sheet.appendRow([
        row['date'],
        row['status'],
      ]);
    }

    final List<int> bytes = excel.encode()!;
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'attendance_table.xlsx'
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
