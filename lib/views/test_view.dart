import 'package:asia_project/models/attendance_model.dart';
import 'package:asia_project/services/attendance_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestView extends StatefulWidget {
  const TestView({super.key});

  @override
  State<TestView> createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<AttendanceModel>> _attendeceFuture;

  @override
  void initState() {
    super.initState();
    // Inicializamos la lista de asistencia al cargar la vista
    final AttendanceService attendanceService = AttendanceService(firestore: _firestore);
    _attendeceFuture = attendanceService.getAllAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Records"),
      ),
      body: FutureBuilder(
          future: _attendeceFuture,
          builder: ((context,snapshot){
            return ListView.builder(
              itemCount: snapshot.data?.length ?? 5,
              itemBuilder: (context,index){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("User: ${snapshot.data?[index].user ?? "There are not value!"}"),
                    Text("Dispositive: ${snapshot.data?[index].dispositive}")
                  ],
                );
              },
            );
          })
      ),
    );
  }
}
