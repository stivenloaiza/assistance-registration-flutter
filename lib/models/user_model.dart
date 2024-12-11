class User {
  String id; // Campo ID obligatorio
  String birthDate;
  String createdAt;
  String createdBy;
  String? deletedAt; // Campo opcional
  String? deletedBy; // Campo opcional
  String documentNumber;
  String email;
  String? faceData; // Campo opcional
  String name;
  int otp;
  String photo;
  String role;
  bool status;
  String terms;

  // Constructor
  User({
    required this.id,
    required this.birthDate,
    required this.createdAt,
    required this.createdBy,
    this.deletedAt, // Campo opcional
    this.deletedBy, // Campo opcional
    required this.documentNumber,
    required this.email,
    this.faceData, // Campo opcional
    required this.name,
    required this.otp,
    required this.photo,
    required this.role,
    required this.status,
    required this.terms,
  });

  // Método para convertir de un Map a un objeto User
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      birthDate: map['birth_date'] ?? '',
      createdAt: map['created_at'] ?? '',
      createdBy: map['created_by'] ?? '',
      deletedAt: map['deleted_at'], // Puede ser null
      deletedBy: map['deleted_by'], // Puede ser null
      documentNumber: map['document_number']?.toString() ?? '0',
      email: map['email'] ?? '',
      faceData: map['face_data'], // Puede ser null
      name: map['name'] ?? '',
      otp: (map['otp'] != null) ? int.tryParse(map['otp'].toString()) ?? 0 : 0,
      photo: map['photo'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] is String
          ? (map['status'] == 'true')
          : (map['status'] ?? false),
      terms: map['terms'] ?? '',
    );
  }

  // Método para convertir de un objeto User a un Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'birth_date': birthDate,
      'created_at': createdAt,
      'created_by': createdBy,
      'deleted_at': deletedAt, // Puede ser null
      'deleted_by': deletedBy, // Puede ser null
      'document_number': documentNumber,
      'email': email,
      'face_data': faceData, // Puede ser null
      'name': name,
      'otp': otp,
      'photo': photo,
      'role': role,
      'status': status,
      'terms': terms,
    };
  }
}
