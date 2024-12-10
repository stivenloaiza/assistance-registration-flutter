
import 'package:asia_project/models/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AttendanceModel>> getAllAttendance()async{
    List<AttendanceModel> attendance = [];
    CollectionReference collectionReferenceAttendance = _firestore.collection("attendance");
    QuerySnapshot queryAttendance = await collectionReferenceAttendance.get();
    queryAttendance.docs.forEach((document){
      var data = AttendanceModel.fromMap(document.data() as Map<String,dynamic>);
      attendance.add(data);
    });
    return attendance;
  }
}