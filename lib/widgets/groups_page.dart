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

  @override
  void initState() {
    super.initState();
    _loadGroupsData(); // Cargar los grupos al iniciar
  }

  // Método para cargar los datos desde Firestore
  Future<void> _loadGroupsData() async {
    QuerySnapshot querySnapshot = await _db.collection('groups').get();

    setState(() {
      _groups = querySnapshot.docs.map((doc) {
        final group = Group.fromMap(
          doc.data() as Map<String, dynamic>,
          id: doc.id,
        );
        print("Group ID: ${group.id}"); // Debug para verificar
        return group;
      }).toList();
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
      // Abrir el modal de edición para ese grupo
      final updatedGroup = await showDialog<Group>(
        context: context,
        builder: (context) => EditGroupModal(group: group), // Pasa el grupo al modal
      );

      // Si el grupo fue editado (no es null), actualizamos la lista
      if (updatedGroup != null) {
        setState(() {
          // Reemplazamos el grupo editado en la lista de grupos
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
                    usersId: group.usersId,
                    groupId: group.id,
                    onDelete: () => _deleteGroup(group.id),
                    onEdit: () => _editGroup(group.id), // Llamamos a _editGroup
                  );
                },
              ),
      ),
      floatingActionButton: const FloatingButton(), // Botón flotante para agregar nuevo grupo
    );
  }
}




