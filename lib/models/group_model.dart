
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel{
  final String created_at;
  final String created_by;
  final String deleted_at;
  final String deleted_by;
  final String updated_at;
  final String updated_by;
  final String description;
  final String device;
  final String end_date;
  final String end_time;
  final String start_date;
  final int time_tolerance;
  final String title;
  final List<String> users_id;

  GroupModel({
    required this.created_at,
    required this.created_by,
    required this.deleted_at,
    required this.deleted_by,
    required this.updated_at,
    required this.updated_by,
    required this.description,
    required this.device,
    required this.end_date,
    required this.end_time,
    required this.start_date,
    required this.time_tolerance,
    required this.title,
    required this.users_id,
  });

  factory GroupModel.fromMap(Map<String, dynamic> data){
    return GroupModel(
      created_at: data["created_at"] ?? "",
      created_by: data["created_by"] ?? "",
      deleted_at: data["deleted_at"] ?? "",
      deleted_by: data["deleted_by"] ?? "",
      updated_at: data["updated_at"] ?? "",
      updated_by: data["updated_by"] ?? "",
      description: data["description"] ?? "",
      device: data["device"] ?? "",
      end_date: data["end_date"] ?? "",
      end_time: data["end_time"] ?? "",
      start_date: data["start_date"] ?? "",
      time_tolerance: data["time_tolerance"] ?? "",
      title: data["title"] ?? "",
      users_id: data["user_id"] ?? "",
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "created_at": created_at,
      "created_by": created_by,
      "updated_at": updated_at,
      "updated_by": updated_by,
      "deleted_at": deleted_at,
      "deleted_by": deleted_by,
      "description": description,
      "device": device,
      "end_date": end_date,
      "end_time": end_time,
      "start_date": start_date,
      "time_tolerance": time_tolerance,
      "title": title,
      "users_id": users_id,
    };
  }

}