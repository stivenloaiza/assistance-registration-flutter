class Student {
  final String name;
  final String clan;
  final String date;
  final bool attended;
  

  Student({required this.name, required this.clan, required this.date, required this.attended, required Map<String, int> attendanceData});
}