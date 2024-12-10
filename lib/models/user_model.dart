class User {
  String id; // Campo ID agregado
  String birthDate;
  String createdAt;
  String createdBy;
  String deletedAt;
  String deletedBy;
  String documentNumber;
  String email;
  String faceData;
  String name;
  int otp;
  String photo;
  String role;
  bool status;
  String terms;

  // Constructor
  User({
    required this.id,  // Agregamos el campo id en el constructor
    required this.birthDate,
    required this.createdAt,
    required this.createdBy,
    required this.deletedAt,
    required this.deletedBy,
    required this.documentNumber,
    required this.email,
    required this.faceData,
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
      id: map['id'] ?? '',  // Asignamos el ID desde el map
      birthDate: map['birth_date'] ?? '',
      createdAt: map['created_at'] ?? '',
      createdBy: map['created_by'] ?? '',
      deletedAt: map['deleted_at'] ?? '',
      deletedBy: map['deleted_by'] ?? '',
      documentNumber: map['document_number']?.toString() ?? '0',
      email: map['email'] ?? '',
      faceData: map['face_data'] ?? '',
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
      'id': id,  // Agregamos el id al Map
      'birth_date': birthDate,
      'created_at': createdAt,
      'created_by': createdBy,
      'deleted_at': deletedAt,
      'deleted_by': deletedBy,
      'document_number': documentNumber,
      'email': email,
      'face_data': faceData,
      'name': name,
      'otp': otp,
      'photo': photo,
      'role': role,
      'status': status,
      'terms': terms,
    };
  }
}
