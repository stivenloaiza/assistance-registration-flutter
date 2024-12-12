import 'package:flutter/material.dart';
import 'package:asia_project/models/group_model.dart';
import 'package:asia_project/controllers/group_controller.dart';
import 'package:asia_project/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Para acceder a la base de datos

class EditGroupModal extends StatefulWidget {
  final Group group; // El grupo que vamos a editar

  const EditGroupModal({Key? key, required this.group}) : super(key: key);

  @override
  _EditGroupModalState createState() => _EditGroupModalState();
}

class _EditGroupModalState extends State<EditGroupModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _deviceController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _timeToleranceController;

  List<User> _users = []; // Lista para usuarios cargados desde Firestore
  List<String> _selectedUserIds = []; // Lista de IDs de usuarios seleccionados

  @override
  void initState() {
    super.initState();
    // Inicializamos los controladores con los valores actuales del grupo
    _titleController = TextEditingController(text: widget.group.title);
    _descriptionController =
        TextEditingController(text: widget.group.description);
    _deviceController = TextEditingController(text: widget.group.device);
    _startDateController = TextEditingController(text: widget.group.startDate);
    _endDateController = TextEditingController(text: widget.group.endDate);
    _startTimeController = TextEditingController(text: widget.group.startTime);
    _endTimeController = TextEditingController(text: widget.group.endTime);
    _timeToleranceController =
        TextEditingController(text: widget.group.timeTolerance.toString());
    _selectedUserIds = List.from(
        widget.group.usersId); // Cargar los usuarios del grupo al iniciar
    _loadUsersData(); // Cargar usuarios desde Firebase
  }

  Future<void> _loadUsersData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _users = querySnapshot.docs.map((doc) {
          final user = User.fromMap({
            'id': doc.id,
            ...doc.data() as Map<String, dynamic>,
          });
          return user;
        }).toList();
      });
    } catch (e) {
      print("Error al cargar los usuarios: $e");
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _deviceController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _timeToleranceController.dispose();
    super.dispose();
  }

  Future<void> _saveGroup() async {
    if (_formKey.currentState!.validate()) {
      final updatedGroup = Group(
        id: widget.group.id, // Mantenemos el ID del grupo
        createdAt: widget.group.createdAt, // No lo modificamos
        createdBy: widget.group.createdBy, // No lo modificamos
        description: _descriptionController.text,
        device: _deviceController.text,
        endDate: _endDateController.text,
        endTime: _endTimeController.text,
        startDate: _startDateController.text,
        startTime: _startTimeController.text,
        timeTolerance: int.parse(_timeToleranceController.text),
        title: _titleController.text,
        usersId: _selectedUserIds, // Usamos los usuarios seleccionados
        updatedAt:
            DateTime.now().toString(), // Actualizamos la fecha de modificación
        updatedBy: widget.group.createdBy, // Podemos asignar el mismo creador
      );

      // Usamos el controlador para actualizar el grupo en Firebase
      final groupController = GroupController();
      await groupController.updateGroup(widget.group.id, updatedGroup);

      // Cerramos el modal después de la actualización
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ],
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Editar Grupo',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 15),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Título'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El título es obligatorio';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _deviceController,
                decoration: InputDecoration(labelText: 'Dispositivo'),
              ),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(labelText: 'Fecha de inicio'),
              ),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(labelText: 'Fecha de fin'),
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: 'Hora de inicio'),
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: 'Hora de fin'),
              ),
              TextFormField(
                controller: _timeToleranceController,
                decoration: InputDecoration(labelText: 'Tolerancia de tiempo'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'La tolerancia es obligatoria';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Campo de selección de usuarios
              GestureDetector(
                onTap: () async {
                  final selectedIds = await showDialog<List<String>>(
                    context: context,
                    builder: (BuildContext context) {
                      return UserSelectDialog(
                        users: _users,
                        selectedUserIds: _selectedUserIds,
                        onSelectionChanged: (selectedList) {
                          setState(() {
                            _selectedUserIds = selectedList;
                          });
                        },
                      );
                    },
                  );
                  if (selectedIds != null) {
                    setState(() {
                      _selectedUserIds = selectedIds;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar Usuarios',
                    border: OutlineInputBorder(),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.horizontal, // Hacemos scroll horizontal
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context)
                              .size
                              .width), // Limitar el ancho al tamaño de la pantalla
                      child: Text(
                        _selectedUserIds.isEmpty
                            ? 'No se seleccionaron usuarios'
                            : _selectedUserIds.join(', '),
                        overflow: TextOverflow
                            .ellipsis, // Si el texto es muy largo, se corta con "..."
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _saveGroup,
                child: Text('Guardar cambios'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserSelectDialog extends StatefulWidget {
  final List<User> users;
  final List<String> selectedUserIds;
  final Function(List<String>) onSelectionChanged;

  const UserSelectDialog({
    Key? key,
    required this.users,
    required this.selectedUserIds,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _UserSelectDialogState createState() => _UserSelectDialogState();
}

class _UserSelectDialogState extends State<UserSelectDialog> {
  late List<String> _selectedUsers;

  @override
  void initState() {
    super.initState();
    _selectedUsers = List.from(
        widget.selectedUserIds); // Inicializa con los usuarios seleccionados
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccionar Usuarios'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.users.map((user) {
            return CheckboxListTile(
              title: Text(user.name), // Mostrar el nombre del usuario
              value: _selectedUsers.contains(user.id),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedUsers.add(user.id);
                  } else {
                    _selectedUsers.remove(user.id);
                  }
                });
                widget.onSelectionChanged(
                    _selectedUsers); // Notificar a la pantalla principal
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selectedUsers),
          child: Text('Aceptar'),
        ),
      ],
    );
  }
}
