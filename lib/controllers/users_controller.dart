import 'package:asia_project/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? currentUser;

  // Método para obtener los datos del usuario desde Firestore
  Future<void> fetchUserData() async {
    // Obtenemos todos los documentos de la colección 'users'
    await _db.collection('users').get().then((event) {
      for (var doc in event.docs) {
        print("${doc.id} => ${doc.data()}");

        // Suponiendo que solo hay un usuario o queremos el primer usuario en la colección
        currentUser = User.fromMap({
          'id': doc.id,  // Asignamos el ID de Firestore al objeto User
          ...doc.data() as Map<String, dynamic>,
        });
      }
    });
  }

  // Método para obtener el usuario actual
  User? getUser() {
    return currentUser;
  }

  // Método para agregar un nuevo usuario a Firestore
  Future<void> addUser(User user) async {
    await _db.collection('users').add(user.toMap()).then((docRef) {
      print('Usuario agregado con ID: ${docRef.id}');
    }).catchError((error) {
      print('Error al agregar usuario: $error');
    });
  }

  // Método para eliminar un usuario de Firestore
  Future<void> deleteUser(String userId) async {
    try {
      await _db.collection('users').doc(userId).delete();
      print("Usuario eliminado: $userId");
    } catch (e) {
      print("Error al eliminar usuario: $e");
    }
  }
}

