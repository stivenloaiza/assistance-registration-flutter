import 'package:asia_project/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Group? currentGroup;

  // Método para obtener la lista de grupos
  Future<List<Group>> getGroups() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection('groups').get();
      return querySnapshot.docs.map((doc) {
        return Group.fromMap({
          'id': doc.id, // Asignar el ID del documento
          ...doc.data() as Map<String, dynamic>,
        });
      }).toList();
    } catch (e) {
      print('Error al obtener grupos: $e');
      return [];
    }
  }

  // Método para obtener los datos de un grupo específico
  Future<void> fetchGroupData(String groupId) async {
    try {
      DocumentSnapshot doc = await _db.collection('groups').doc(groupId).get();
      if (doc.exists) {
        print("Datos del grupo (${doc.id}): ${doc.data()}");
        currentGroup = Group.fromMap({
          'id': doc.id,
          ...doc.data() as Map<String, dynamic>,
        });
      } else {
        print('El grupo con ID $groupId no existe.');
      }
    } catch (e) {
      print('Error al obtener los datos del grupo: $e');
    }
  }

  // Método para obtener el grupo actual
  Group? getGroup() {
    return currentGroup;
  }

  // Método para crear un nuevo grupo
  Future<void> createGroup(Group group) async {
    try {
      DocumentReference docRef = await _db.collection('groups').add(group.toMap());
      print('Grupo creado con ID: ${docRef.id}');
    } catch (e) {
      print('Error al crear grupo: $e');
    }
  }

  // Método para actualizar un grupo
  Future<void> updateGroup(String groupId, Group group) async {
    try {
      await _db.collection('groups').doc(groupId).update(group.toMap());
      print('Grupo actualizado con ID: $groupId');
    } catch (e) {
      print('Error al actualizar grupo: $e');
    }
  }

  // Método para eliminar un grupo por su ID
  Future<void> deleteGroup(String groupId) async {
    if (groupId.isEmpty) {
      print('Error: El ID del grupo no puede estar vacío.');
      return;
    }
    try {
      await _db.collection('groups').doc(groupId).delete();
      print('Grupo eliminado con ID: $groupId');
    } catch (e) {
      print('Error al eliminar grupo: $e');
    }
  }
}