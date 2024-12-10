import 'package:asia_project/models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Obtener la lista de grupos
  Future<List<Group>> getGroups() async {
    QuerySnapshot querySnapshot = await _db.collection('groups').get();
    return querySnapshot.docs.map((doc) {
      return Group.fromMap({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    }).toList();
  }

  // Eliminar un grupo por su ID
  Future<void> deleteGroup(String groupId) async {
    await _db.collection('groups').doc(groupId).delete();
  }

  // Crear un grupo
  Future<void> createGroup(Group group) async {
    await _db.collection('groups').add(group.toMap());
  }

  // Actualizar un grupo
  Future<void> updateGroup(String groupId, Group group) async {
    await _db.collection('groups').doc(groupId).update(group.toMap());
  }
}
