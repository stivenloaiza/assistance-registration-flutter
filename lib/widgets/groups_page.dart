// Controlador para manejar grupos
import 'package:asia_project/controllers/group_controller.dart';
import 'package:asia_project/models/group_model.dart'; // Modelo del grupo
import 'package:asia_project/widgets/custom_apbar_admin.dart'; // AppBar personalizado
import 'package:asia_project/widgets/floating_button_widget.dart'; // Botón flotante para agregar grupo
import 'package:asia_project/widgets/group_card_widget.dart'; // Card para mostrar cada grupo
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
  // ignore: library_private_types_in_public_api
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
    // Muestra un mensaje de SnackBar cuando se haga clic en editar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Este es el botón de actualizar')),
    );

    // Aquí puedes agregar la lógica de edición cuando implementes el formulario o la vista para editar el grupo.
    // Esto puede incluir navegar a otra pantalla o abrir un modal con los detalles del grupo.
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
              onEdit: () => _editGroup(group.id),
            );
          },
        ),
      ),
      floatingActionButton: const FloatingButton(), // Botón flotante para agregar nuevo grupo
    );
  }
}