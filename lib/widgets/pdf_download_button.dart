import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/coders_model.dart';

class PdfDownloadButton extends StatelessWidget {
  final List<Student> students;

  const PdfDownloadButton({Key? key, required this.students}) : super(key: key);

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Text('#'),
                  pw.Text('Coders'),
                  pw.Text('Clan'),
                  pw.Text('Date'),
                  pw.Text('Asistió'),
                ],
              ),
              ...students.asMap().entries.map((entry) {
                final index = entry.key;
                final student = entry.value;
                return pw.TableRow(
                  children: [
                    pw.Text('${index + 1}'),
                    pw.Text(student.name),
                    pw.Text(student.clan),
                    pw.Text(student.date),
                    pw.Text(student.attended ? 'Sí' : 'No'),
                  ],
                );
              }).toList(),
            ],
          );
        },
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'estudiantes.pdf');
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.download),
      label: Text('Descargar PDF'),
      onPressed: () => _generatePdf(context),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
