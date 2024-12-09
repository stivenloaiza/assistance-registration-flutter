import 'package:flutter/material.dart';
import 'package:asia_project/models/coders_model.dart';
import './search_input_widget.dart';
import './coder_card_widget.dart';
import './coder_pagination_widget.dart';
import '../pdf_download_button.dart';
import './student_details_modal.dart';


class StudentTable extends StatefulWidget {
  StudentTable({Key? key}) : super(key: key);

  @override
  _StudentTableState createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  final List<Student> students = [
    Student(
      name: 'Caridad',
      clan: 'Gates',
      date: '2024-06-01',
      attended: true,
      attendanceData: {'Habilidades': 80, 'Desarrollo': 90, 'Inglés': 75},
    ),
    Student(
      name: 'María Vanegas',
      clan: 'Berners-Lee',
      date: '2024-06-01',
      attended: false,
      attendanceData: {'Habilidades': 70, 'Desarrollo': 85, 'Inglés': 80},
    ),
    Student(
      name: 'Luisa',
      clan: 'Gates',
      date: '2024-06-02',
      attended: true,
      attendanceData: {'Habilidades': 85, 'Desarrollo': 95, 'Inglés': 70},
    ),
    Student(
      name: 'Ana Sofía',
      clan: 'Berners-Lee',
      date: '2024-06-02',
      attended: true,
      attendanceData: {'Habilidades': 90, 'Desarrollo': 80, 'Inglés': 85},
    ),
    Student(
      name: 'Encantador',
      clan: 'Gates',
      date: '2024-06-04',
      attended: false,
      attendanceData: {'Habilidades': 75, 'Desarrollo': 70, 'Inglés': 100},
    ),
  ];

  int currentPage = 1;
  int itemsPerPage = 2;
  String searchQuery = '';

  List<Student> get filteredStudents {
    if (searchQuery.isEmpty) {
      return students;
    }
    return students.where((student) =>
        student.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        student.clan.toLowerCase().contains(searchQuery.toLowerCase()) ||
        student.date.toLowerCase().contains(searchQuery.toLowerCase())
    ).toList();
  }

  int get totalPages {
    return (filteredStudents.length / itemsPerPage).ceil();
  }

  List<Student> get currentPageStudents {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredStudents.sublist(
        startIndex, endIndex > filteredStudents.length ? filteredStudents.length : endIndex);
  }

  void onPageChanged(int page) {
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchInputWidget(
              hintText: 'Buscar estudiantes',
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                  currentPage = 1; // Reset to first page when searching
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: PdfDownloadButton(students: filteredStudents),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Table(
                              columnWidths: const {
                                0: FixedColumnWidth(50),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(2),
                                3: FlexColumnWidth(3),
                                4: FlexColumnWidth(2),
                              },
                              children: [
                                TableRow(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey.shade300, width: 1)),
                                  ),
                                  children: const [
                                    TableCell(
                                        child: Text('#',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    TableCell(
                                        child: Text('Coders',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    TableCell(
                                        child: Text('Clan',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    TableCell(
                                        child: Text('Date',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                    TableCell(
                                        child: Text('Asistió',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                ...currentPageStudents.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final student = entry.value;
                                  return TableRow(
                                    decoration: BoxDecoration(
                                      color: index.isEven
                                          ? Colors.grey.shade50
                                          : Colors.white,
                                    ),
                                    children: [
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Text('${index + 1}',
                                              textAlign: TextAlign.center),
                                        ),
                                      ),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Row(
                                          children: [
                                            const CircleAvatar(
                                              backgroundColor: Colors.blue,
                                              child: Text('AB',
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StudentDetailsModal(student: student);
                                                  },
                                                );
                                              },
                                              child: Text(
                                                student.name,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration: TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text(student.clan)),
                                      TableCell(
                                          verticalAlignment:
                                              TableCellVerticalAlignment.middle,
                                          child: Text(student.date)),
                                      TableCell(
                                        verticalAlignment:
                                            TableCellVerticalAlignment.middle,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: student.attended
                                                ? Colors.green.shade100
                                                : Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                student.attended
                                                    ? Icons.check_circle
                                                    : Icons.cancel,
                                                color: student.attended
                                                    ? Colors.green
                                                    : Colors.red,
                                                size: 16,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                student.attended ? 'Sí' : 'No',
                                                style: TextStyle(
                                                  color: student.attended
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children:
                              currentPageStudents.asMap().entries.map((entry) {
                            final index = entry.key;
                            final student = entry.value;
                            return StudentCard(
                              student: student,
                              index: index,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StudentDetailsModal(student: student);
                                  },
                                );
                              },
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                  PaginationWidget(
                    currentPage: currentPage,
                    totalPages: totalPages,
                    onPageChanged: onPageChanged,
                  ),
                ],
              ),
            ),
          ),
        ]
      )
    );
  }
}

