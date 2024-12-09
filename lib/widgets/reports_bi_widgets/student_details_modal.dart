import 'package:asia_project/widgets/reports_bi_widgets/attendance_graph.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/models/coders_model.dart';

class StudentDetailsModal extends StatelessWidget {
  final Student student;

  const StudentDetailsModal({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            student.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 15),
          Text(
            "Clan: ${student.clan}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Date: ${student.date}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            "Attended: ${student.attended ? 'Yes' : 'No'}",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Text(
            "Subjects:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          SubjectButton(
            subject: "Habilidades para la vida",
            onPressed: () => _showAttendanceModal(context, "Habilidades para la vida"),
          ),
          SubjectButton(
            subject: "Desarrollo",
            onPressed: () => _showAttendanceModal(context, "Desarrollo"),
          ),
          SubjectButton(
            subject: "Inglés",
            onPressed: () => _showAttendanceModal(context, "Inglés"),
          ),
          SizedBox(height: 22),
          Align(
            alignment: Alignment.bottomRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ),
        ],
      ),
    );
  }

  void _showAttendanceModal(BuildContext context, String subject) {
    // Placeholder attendance data
    Map<String, int> attendanceData = {
      'Habilidades para la vida': 80,
      'Desarrollo': 85,
      'Inglés': 75,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "$subject Attendance",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                AttendanceGraph(attendanceData: attendanceData),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SubjectButton extends StatelessWidget {
  final String subject;
  final VoidCallback onPressed;

  const SubjectButton({Key? key, required this.subject, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(subject),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 40),
        ),
      ),
    );
  }
}
