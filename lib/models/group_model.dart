class Group {
  final String id;
  final String createdAt;
  final String createdBy;
  final String? deletedAt;
  final String? deletedBy;
  final String description;
  final String device;
  final String endDate;
  final String endTime;
  final String startDate;
  final int timeTolerance;
  final String title;
  final String? updatedAt;
  final String? updatedBy;
  final List<String> usersId;

  Group({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    this.deletedAt,
    this.deletedBy,
    required this.description,
    required this.device,
    required this.endDate,
    required this.endTime,
    required this.startDate,
    required this.timeTolerance,
    required this.title,
    this.updatedAt,
    this.updatedBy,
    required this.usersId,
  });

  /// Crear un método para convertir desde un Map (desde Firestore o cualquier otro origen)
  factory Group.fromMap(Map<String, dynamic> map, {String? id}) {
    return Group(
      id: id ?? '',
      createdAt: map['created_at'] ?? '',
      createdBy: map['created_by'] ?? '',
      deletedAt: map['deleted_at'],
      deletedBy: map['deleted_by'],
      description: map['description'] ?? '',
      device: map['device'] ?? '',
      endDate: map['end_date'] ?? '',
      endTime: map['end_time'] ?? '',
      startDate: map['start_date'] ?? '',
      timeTolerance: map['time_tolerance'] ?? 0,
      title: map['title'] ?? '',
      updatedAt: map['updated_at'],
      updatedBy: map['updated_by'],
      usersId: List<String>.from(map['users_id'] ?? []),
    );
  }

  /// Convertir el objeto de Dart a un Map (para subir a Firestore u otra base de datos)
  Map<String, dynamic> toMap() {
    return {
      'created_at': createdAt,
      'created_by': createdBy,
      'deleted_at': deletedAt,
      'deleted_by': deletedBy,
      'description': description,
      'device': device,
      'end_date': endDate,
      'end_time': endTime,
      'start_date': startDate,
      'time_tolerance': timeTolerance,
      'title': title,
      'updated_at': updatedAt,
      'updated_by': updatedBy,
      'users_id': usersId,
    };
  }
}
