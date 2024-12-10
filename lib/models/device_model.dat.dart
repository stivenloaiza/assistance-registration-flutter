
import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceModel{
  final String location;
  final String loginCode;
  final String name;
  final String status;

  DeviceModel({
    required this.location,
    required this.loginCode,
    required this.name,
    required this.status,
  });

  factory DeviceModel.fromMap(Map<String, dynamic> data){
    return DeviceModel(
        location: data["location"] ?? "",
        loginCode: data["loginCode"] ?? "",
        name: data["name"] ?? "",
        status: data["status"] ?? "",
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "location": location,
      "loginCode": loginCode,
      "name": name,
      "status": status,
    };
  }

}