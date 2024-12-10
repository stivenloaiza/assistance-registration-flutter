
class UserModel{
  final String email;
  final String fechaNacimiento;
  final String nombre;
  final String numeroDocumento;
  final String role;
  final String status;
  final String tipoDocumento;
  final String uid;

  UserModel({
    required this.email,
    required this.fechaNacimiento,
    required this.nombre,
    required this.numeroDocumento,
    required this.role,
    required this.status,
    required this.tipoDocumento,
    required this.uid
  });

  factory UserModel.fromMap(Map<String, dynamic> data){
    return UserModel(
      email: data["email"] ?? "",
      fechaNacimiento: data["fechaNacimiento"] ?? "",
      nombre: data["nombre"] ?? "",
      numeroDocumento: data["numeroDocumento"] ?? "",
      role: data["role"] ?? "",
      status: data["status"] ?? "",
      tipoDocumento: data["tipoDocumento"] ?? "",
      uid: data["uid"] ?? "",
    );
  }

  Map<String,dynamic> toMap(){
    return {
      "email": email,
      "fechaNacimiento": fechaNacimiento,
      "nombre": nombre,
      "numeroDocumento": numeroDocumento,
      "role": role,
      "status": status,
      "tipoDocumento": tipoDocumento,
      "uid": uid,
    };
  }

}