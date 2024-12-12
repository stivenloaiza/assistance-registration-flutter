import 'package:asia_project/controllers/group_controller.dart';
import 'package:asia_project/models/group_model.dart'; // Modelo del grupo
import 'package:asia_project/widgets/custom_apbar_admin.dart'; // AppBar personalizado
import 'package:asia_project/widgets/floating_button_widget.dart'; // Botón flotante para agregar grupo
import 'package:asia_project/widgets/group_card_widget.dart'; // Card para mostrar cada grupo
import 'package:asia_project/widgets/groups_modal.widget.dart'; // Modal para editar el grupo
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore

class GroupsPage extends StatefulWidget {
  final bool isMobile;
  final VoidCallback onMenuPressed;

  const GroupsPage({
    super.key,
    required this.isMobile,
    required this.onMenuPressed,
  });

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  List<Group> _groups = [];
  final GroupController _groupsController = GroupController(); // Controlador para grupos
  Map<String, String> _usersMap = {}; // Mapa para almacenar los IDs de usuarios y sus nombres

  @override
  void initState() {
    super.initState();
    _loadGroupsData(); // Cargar los grupos al iniciar
  }

  // Método para cargar los datos de los grupos y los usuarios
  Future<void> _loadGroupsData() async {
    QuerySnapshot querySnapshot = await _db.collection('groups').get();

    List<Group> loadedGroups = querySnapshot.docs.map((doc) {
      final group = Group.fromMap(
        doc.data() as Map<String, dynamic>,
        id: doc.id,
      );
      return group;
    }).toList();

    // Obtener los IDs de los usuarios de todos los grupos
    Set<String> userIds = {};
    for (var group in loadedGroups) {
      userIds.addAll(group.usersId);
    }

    // Cargar los nombres de los usuarios
    await _loadUsersNames(userIds);

    setState(() {
      _groups = loadedGroups;
    });
  }

  // Método para cargar los nombres de los usuarios
  Future<void> _loadUsersNames(Set<String> userIds) async {
    Map<String, String> userNames = {};
    for (String userId in userIds) {
      DocumentSnapshot userDoc = await _db.collection('users').doc(userId).get();
      if (userDoc.exists) {
        userNames[userId] = userDoc['name'] ?? 'Unknown User';
      }
    }
    setState(() {
      _usersMap = userNames; // Guardamos los nombres de los usuarios en el mapa
    });
  }

  // Método para eliminar un grupo
  Future<void> _deleteGroup(String groupId) async {
    await _groupsController.deleteGroup(groupId); // Llamamos al controlador para eliminar

    setState(() {
      _groups.removeWhere((group) => group.id == groupId); // Eliminamos de la lista
    });
  }

  // Método para editar un grupo
  Future<void> _editGroup(String groupId) async {
    // Buscar el grupo por su ID
    final group = _groups.firstWhere(
      (g) => g.id == groupId, 
      orElse: () => Group(id: '', createdAt: '', createdBy: '', description: '', device: '', endDate: '', endTime: '', startDate: '', startTime: '', timeTolerance: 0, title: '', usersId: []), 
    );

    // Verificar si el grupo existe antes de abrir el modal
    if (group.id.isNotEmpty) {
      final updatedGroup = await showDialog<Group>(
        context: context,
        builder: (context) => EditGroupModal(group: group),
      );

      if (updatedGroup != null) {
        setState(() {
          final index = _groups.indexWhere((g) => g.id == updatedGroup.id);
          if (index != -1) {
            _groups[index] = updatedGroup; // Reemplazar el grupo editado
          }
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Grupo no encontrado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isMobile: widget.isMobile,
        onMenuPressed: widget.onMenuPressed,
        title: 'Groups',
        searchController: TextEditingController(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _groups.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _groups.length,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  return GroupCard(
                    title: group.title,
                    description: group.description,
                    device: group.device,
                    startDate: group.startDate,
                    endDate: group.endDate,
                    timeTolerance: group.timeTolerance,
                    usersId: group.usersId
                        .map((userId) => _usersMap[userId] ?? 'Unknown User')
                        .toList(),
                    groupId: group.id,
                    onDelete: () => _deleteGroup(group.id),
                    onEdit: () => _editGroup(group.id),
                  );
                },
              ),
      ),
      floatingActionButton: const FloatingButton(),
    );
  }
}





