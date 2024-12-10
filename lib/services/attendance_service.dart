
import 'package:asia_project/models/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService{
  final FirebaseFirestore firestore;

  AttendanceService({
    required this.firestore
  });

  Future<List<AttendanceModel>> getAllAttendance()async{
    List<AttendanceModel> attendance = [];
    CollectionReference collectionReferenceAttendance = firestore.collection("attendance");
    QuerySnapshot queryAttendance = await collectionReferenceAttendance.get();
    queryAttendance.docs.forEach((document){
      var data = AttendanceModel.fromMap(document.data() as Map<String,dynamic>);
      attendance.add(data);
    });
    return attendance;
  }

  DateTime calculateStartDate(String range){
    DateTime now = DateTime.now();
    switch(range){
      case "1":
        return now.subtract(const Duration(days: 1));
      case "3":
        return now.subtract(const Duration(days: 3));
      case "7":
        return now.subtract(const Duration(days: 7));
      case "1 mes":
        return DateTime(now.year, now.month-1,now.day);
      default:
        throw Exception("Range invalid");
    }
  }

  Future<List<AttendanceModel>> getAttendanceByDateRange(String range) async{
    List<AttendanceModel> attendanceList = [];
    CollectionReference collectionReferenceAttendance = firestore.collection("attendance");

    try{
      DateTime startDate = calculateStartDate(range);
      QuerySnapshot querySnapshot = await collectionReferenceAttendance.where("timeStamp", isGreaterThanOrEqualTo:  startDate.toIso8601String()).get();
      querySnapshot.docs.forEach((document){
        var data = AttendanceModel.fromMap(document.data() as Map<String,dynamic>);
        attendanceList.add(data);
      });
    }catch(error){
      print("Error with the method getAttendanceByDateRange. Error: $error");
    }
    return attendanceList;
  }
}