
class UserModel {
  final String createdAt;
  final String createdBy;
  final String deletedAt;
  final String deletedBy;
  final String updatedAt;
  final String updatedBy;
  final String birthDate;
  final String documentNumber;
  final String documentType;
  final String email;
  final String name;
  final String faceData;
  final int  otp;
  final String photo;
  final String role;
  final bool status;
  final String terms;

  UserModel({
    required this.createdAt,
    required this.createdBy,
    required this.deletedAt,
    required this.deletedBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.birthDate,
    required this.documentNumber,
    required this.documentType,
    required this.email,
    required this.name,
    required this.faceData,
    required this.otp,
    required this.photo,
    required this.role,
    required this.status,
    required this.terms,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      createdAt: data["created_at"] ?? "1",
      createdBy: data["created_by"] ?? "1",
      deletedAt: data["deleted_at"] ?? "1",
      deletedBy: data["deleted_by"] ?? "1",
      updatedAt: data["updated_at"] ?? "1",
      updatedBy: data["updated_by"] ?? "1",
      birthDate: data["birth_date"] ?? "1",
      documentNumber: data["document_number"] ?? "1212",
      documentType: data["document_type"] ?? "documentro",
      email: data["email"] ?? "aswasa@gmail.com",
      name: data["name"] ?? "jaja",
      faceData: data["face_data"] ?? "asd",
      otp: data["otp"] ?? "1",
      photo: data["photo"] ?? "asda",
      role: data["role"] ?? "este est true ",
      status: data["status"] ?? "este",
      terms: data["terms"] ?? "asdas",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "created_at": createdAt,
      "created_by": createdBy,
      "deleted_at": deletedAt,
      "deleted_by": deletedBy,
      "updated_at": updatedAt,
      "updated_by": updatedBy,
      "birth_date": birthDate,
      "document_number": documentNumber,
      "document_type": documentType,
      "email": email,
      "name": name,
      "face_data": faceData,
      "otp": otp,
      "photo": photo,
      "role": role,
      "status": status,
      "terms": terms,
    };
  }
}
