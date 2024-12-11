
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel{
  final String attendanceStatus;
  final String dispositive;
  final String group;
  final Timestamp timeStamp;
  final String type;
  final String user;

  AttendanceModel({
    required this.attendanceStatus,
    required this.dispositive,
    required this.group,
    required this.timeStamp,
    required this.type,
    required this.user
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> data){
    return AttendanceModel(
      attendanceStatus: data["attendanceStatus"] ?? "",
      dispositive: data["dispositive"] ?? "",
      group: data["group"] ?? "",
      timeStamp: data["timeStamp"] ?? "",
      type: data["type"] ?? "",
      user: data["user"] ?? ""
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "attendanceStatus": attendanceStatus,
      "dispositive": dispositive,
      "group": group,
      "timeStamp": timeStamp,
      "type": type,
      "user": user,
    };
  }
  @override
  String toString() {
    return 'AttendanceModel(user: $user, group: $group, timeStamp: $timeStamp, attendanceStatus: $attendanceStatus, dispositive: $dispositive, type: $type)';
  }

}