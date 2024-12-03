import 'package:flutter/material.dart';
import '../models/coders_model.dart';

class StudentTable extends StatelessWidget {
  StudentTable({super.key});

  final List<Student> students = [
    Student(name: 'Caridad', clan: 'Gates', date: '2024-06-01', attended: true),
    Student(name: 'María Vanegas', clan: 'Berners-Lee', date: '2024-06-01', attended: false),
    Student(name: 'Luisa', clan: 'Gates', date: '2024-06-02', attended: true),
    Student(name: 'Ana Sofía', clan: 'Berners-Lee', date: '2024-06-02', attended: true),
    Student(name: 'Encantador', clan: 'Gates', date: '2024-06-04', attended: false),
  ];

  Color getAvatarColor(int index) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
      Colors.red,
      Colors.teal,
      Colors.cyan,
    ];
    return colors[index % colors.length];
  }

  String getInitials(String name) {
    return name.split(' ').map((word) => word[0].toUpperCase()).take(2).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Estudiantes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
                        ),
                        children: [
                          TableCell(child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                          TableCell(child: Text('Coders', style: TextStyle(fontWeight: FontWeight.bold))),
                          TableCell(child: Text('Clan', style: TextStyle(fontWeight: FontWeight.bold))),
                          TableCell(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                          TableCell(child: Text('Assisté', style: TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                      ...students.asMap().entries.map((entry) {
                        final index = entry.key;
                        final student = entry.value;
                        return TableRow(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.grey.shade50 : Colors.white,
                          ),
                          children: [
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('${index + 1}', textAlign: TextAlign.center),
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: getAvatarColor(index),
                                    child: Text(getInitials(student.name), style: TextStyle(color: Colors.white)),
                                  ),
                                  SizedBox(width: 8),
                                  Text(student.name),
                                ],
                              ),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(student.clan),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(student.date),
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: student.attended ? Colors.green.shade100 : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      student.attended ? Icons.check_circle : Icons.cancel,
                                      color: student.attended ? Colors.green : Colors.red,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      student.attended ? 'Sí' : 'No',
                                      style: TextStyle(
                                        color: student.attended ? Colors.green.shade700 : Colors.red.shade700,
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
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_back),
                    style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(12)),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('1'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('2'),
                    style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(16)),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('3'),
                    style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(16)),
                  ),
                  SizedBox(width: 8),
                  Text('...', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: Icon(Icons.arrow_forward),
                    style: ElevatedButton.styleFrom(shape: CircleBorder(), padding: EdgeInsets.all(12)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}