import 'package:asia_project/models/attendance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceService {
  final FirebaseFirestore firestore;

  AttendanceService({required this.firestore});

  Future<List<AttendanceModel>> getAllAttendance() async {
    List<AttendanceModel> attendance = [];
    CollectionReference collectionReferenceAttendance =
        firestore.collection("attendance");
    QuerySnapshot queryAttendance = await collectionReferenceAttendance.get();
    queryAttendance.docs.forEach((document) {
      var data =
          AttendanceModel.fromMap(document.data() as Map<String, dynamic>);
      attendance.add(data);
    });
    return attendance;
  }


  DateTime calculateStartDate(String range) {
    DateTime now = DateTime.now();
    switch (range) {
      case "1":
        return now.subtract(const Duration(days: 1));
      case "7":
        return now.subtract(const Duration(days: 7));
      case "1 mes":
        return DateTime(now.year, now.month - 1, now.day);
      case "1 año":
        return DateTime(now.year - 1, now.month, now.day);
      default:
        throw Exception("Range invalid");
    }
  }

  Future<List<AttendanceModel>> getAttendanceByDateRange(String range, String userId) async {
    List<AttendanceModel> attendanceList = [];
    CollectionReference collectionReferenceAttendance =
        firestore.collection("attendance");

    try {
      DateTime startDate = calculateStartDate(range);
      print("startDate ${startDate}");
      QuerySnapshot querySnapshot = await collectionReferenceAttendance
          .where("timeStamp",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .where("user", isEqualTo: userId)
          .get();
      print("query ${querySnapshot}");
      querySnapshot.docs.forEach((document) {
        var data =
            AttendanceModel.fromMap(document.data() as Map<String, dynamic>);
        attendanceList.add(data);
      });
    } catch (error) {
      print("Error with the method getAttendanceByDateRange. Error: $error");
    }
    return attendanceList;
  }

  Future<List<AttendanceModel>> getAttendanceByProperty(
      String property, String valueProperty) async {
    List<AttendanceModel> attendanceList = [];
    CollectionReference collectionReferenceAttendance =
        firestore.collection("attendance");

    try {
      QuerySnapshot querySnapshot = await collectionReferenceAttendance
          .where(property, isEqualTo: valueProperty)
          .get();

      attendanceList = querySnapshot.docs.map((document) {
        return AttendanceModel.fromMap(document.data() as Map<String, dynamic>);
      }).toList();

    } catch (error) {
      print("Error with the method getAttendanceByProperty. Error: $error");
    }
    return attendanceList;
  }

  Future<List<Map<String, dynamic>>> getAttendanceAverages(
      String groupTitle) async {
    List<Map<String, dynamic>> result = [];
    try {
      // Paso 1: Obtener el ID del grupo basado en su título
      QuerySnapshot groupSnapshot = await firestore
          .collection('groups')
          .where('title', isEqualTo: groupTitle)
          .get();

      if (groupSnapshot.docs.isEmpty) {
        print("No se encontró ningún grupo con el título: $groupTitle");
        return [];
      }

      DocumentSnapshot groupDoc = groupSnapshot.docs.first;
      String groupId = groupDoc.id; // ID del grupo encontrado
      List<dynamic> users = groupDoc['users_id'] ?? [];
      int totalRegistered =
          users.length; // Total de personas registradas en el grupo
      print("ID del grupo: $groupId, Total registrados: $totalRegistered");

      // Paso 2: Consultar las asistencias con el ID del grupo
      QuerySnapshot attendanceSnapshot = await firestore
          .collection('attendance')
          .where('group', isEqualTo: groupId)
          .get();

      print(
          "Documentos encontrados en attendance: ${attendanceSnapshot.docs.length}");

      Map<String, List<String>> attendanceByDate = {};

      for (var doc in attendanceSnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        String date = (data['timeStamp'] as Timestamp)
            .toDate()
            .toIso8601String()
            .split('T')
            .first;
        String status = data['attendanceStatus'] ?? 'absent';

        attendanceByDate.putIfAbsent(date, () => []);
        attendanceByDate[date]?.add(status);
      }

      // Calcular métricas y agregar detalles
      attendanceByDate.forEach((date, statuses) {
        int attendees = statuses.length;
        int onTime = statuses.where((status) => status == 'onTime').length;
        int late = statuses.where((status) => status == 'late').length;
        int absent = totalRegistered - attendees;

        double attendancePercentage = (attendees / totalRegistered) * 100;
        double onTimePercentage = (onTime / totalRegistered) * 100;
        double latePercentage = (late / totalRegistered) * 100;
        double absentPercentage = (absent / totalRegistered) * 100;

        result.add({
          'date': date,
          'attendees': attendees,
          'totalRegistered': totalRegistered,
          'onTime': onTime,
          'late': late,
          'absent': absent,
          'attendancePercentage': attendancePercentage,
          'onTimePercentage': onTimePercentage,
          'latePercentage': latePercentage,
          'absentPercentage': absentPercentage,
        });
      });

      // Ordenar las fechas de la más reciente a la más antigua
      result.sort((a, b) => b['date'].compareTo(a['date']));
    } catch (error) {
      print("Error calculating attendance averages: $error");
    }

    print("Resultados procesados: $result");
    return result;
  }

  Map<String, dynamic> generateChartData(
      List<Map<String, dynamic>> attendanceData) {
    // Extraer datos para los gráficos
    final List<double> onTimeData = attendanceData
        .map((entry) => entry['onTimePercentage'] as double)
        .toList();
    final List<double> absentData = attendanceData
        .map((entry) => entry['absentPercentage'] as double)
        .toList();
    final List<double> lateData = attendanceData
        .map((entry) => entry['latePercentage'] as double)
        .toList();

    // Calcular referencias para el eje X (ref)
    final int length = attendanceData.length;
    final String firstDate = attendanceData.first['date'];
    final String middleDate = attendanceData[length ~/ 2]['date'];
    final String lastDate = attendanceData.last['date'];

    return {
      'onTimeData': onTimeData,
      'absentData': absentData,
      'lateData': lateData,
      'ref': [firstDate, middleDate, lastDate],
    };
  }

  Future<int> getTotalAttendanceByUser(String userId)async{
    String userCurrent = "ZlVXfzUz94Ks25eFUfGp";
    List<AttendanceModel> attendanceModels = [];

    CollectionReference collectionReferenceAttendance =
    firestore.collection("attendance");
    QuerySnapshot queryAttendance = await collectionReferenceAttendance.where("user", isEqualTo: userId ?? userCurrent).get();
    queryAttendance.docs.forEach((document) {
      var data =
      AttendanceModel.fromMap(document.data() as Map<String, dynamic>);
      attendanceModels.add(data);
    });
    return attendanceModels.length;
  }

  Future<int> getTotalAttendanceByUserGroup(String? userId, String group)async{
    String userCurrent = "ZlVXfzUz94Ks25eFUfGp";
    List<AttendanceModel> attendanceModels = [];

    CollectionReference collectionReferenceAttendance = firestore.collection("attendance");
    QuerySnapshot queryAttendance = await collectionReferenceAttendance.where("user", isEqualTo: userId ?? userCurrent).where("group", isEqualTo: group).get();
    queryAttendance.docs.forEach((document){
      var data = AttendanceModel.fromMap(document.data() as Map<String,dynamic>);
      attendanceModels.add(data);
    });
    return attendanceModels.length;
  }
}
