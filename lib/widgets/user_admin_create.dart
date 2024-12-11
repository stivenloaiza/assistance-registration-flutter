import 'package:asia_project/models/group_model.dart';
import 'package:asia_project/models/user_model.dart';
import 'package:asia_project/widgets/users_select_groups.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class GroupForm extends StatefulWidget {
  final Function? onGroupCreated;

  const GroupForm({Key? key, this.onGroupCreated}) : super(key: key);

  @override
  State<GroupForm> createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _timeToleranceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deviceIdController = TextEditingController();
  List<String> _selectedUsersId = []; // Lista de IDs de usuarios seleccionados

  List<User> _users = []; // Lista para usuarios cargados desde Firestore

  // Nuevas variables para Start/End Date y Start/End Time
  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Variable para almacenar la foto seleccionada


  @override
  void initState() {
    super.initState();
    _loadUsersData(); // Cargar usuarios desde Firestore
  }

  // Método para cargar los usuarios desde Firestore
  Future<void> _loadUsersData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();
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

  // Método para seleccionar fecha
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    DateTime initialDate = isStartDate ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ) ?? initialDate;

    if (isStartDate) {
      setState(() {
        _startDate = pickedDate;
      });
    } else {
      setState(() {
        _endDate = pickedDate;
      });
    }
  }

  // Método para seleccionar hora
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    TimeOfDay initialTime = isStartTime ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now());
    TimeOfDay pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    ) ?? initialTime;

    if (isStartTime) {
      setState(() {
        _startTime = pickedTime;
      });
    } else {
      setState(() {
        _endTime = pickedTime;
      });
    }
  }

  // Método para seleccionar una foto de la galería o cámara
 
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Campo para el título
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Nombre del Grupo',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Ingrese nombre del grupo'
                : null,
          ),
          const SizedBox(height: 15),

          // Campo para la descripción
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descripción',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese descripción' : null,
          ),
          const SizedBox(height: 15),

          // Campo para la tolerancia de tiempo (en minutos)
          TextFormField(
            controller: _timeToleranceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Tolerancia de Tiempo (min)',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Ingrese tolerancia de tiempo'
                : null,
          ),
          const SizedBox(height: 15),

          // Campo para el ID del dispositivo
          TextFormField(
            controller: _deviceIdController,
            decoration: const InputDecoration(
              labelText: 'ID del Dispositivo',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Ingrese ID del dispositivo'
                : null,
          ),
          const SizedBox(height: 15),

          // Selección de Start Date
          GestureDetector(
            onTap: () => _selectDate(context, true),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fecha de Inicio',
                border: OutlineInputBorder(),
              ),
              child: Text(_startDate == null
                  ? 'Seleccione la fecha'
                  : _startDate!.toLocal().toString().split(' ')[0]),
            ),
          ),
          const SizedBox(height: 15),

          // Selección de Start Time
          GestureDetector(
            onTap: () => _selectTime(context, true),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Hora de Inicio',
                border: OutlineInputBorder(),
              ),
              child: Text(_startTime == null
                  ? 'Seleccione la hora'
                  : _startTime!.format(context)),
            ),
          ),
          const SizedBox(height: 15),

          // Selección de End Date
          GestureDetector(
            onTap: () => _selectDate(context, false),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fecha de Fin',
                border: OutlineInputBorder(),
              ),
              child: Text(_endDate == null
                  ? 'Seleccione la fecha'
                  : _endDate!.toLocal().toString().split(' ')[0]),
            ),
          ),
          const SizedBox(height: 15),

          // Selección de End Time
          GestureDetector(
            onTap: () => _selectTime(context, false),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Hora de Fin',
                border: OutlineInputBorder(),
              ),
              child: Text(_endTime == null
                  ? 'Seleccione la hora'
                  : _endTime!.format(context)),
            ),
          ),
          const SizedBox(height: 15),

          // Muestra un listado de usuarios en un diálogo para selección múltiple
          GestureDetector(
            onTap: () async {
              final selectedIds = await showDialog<List<String>>(
                context: context,
                builder: (BuildContext context) {
                  return UserSelectDialog(
                    users: _users,
                    selectedUserIds: _selectedUsersId,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        _selectedUsersId = selectedList;
                      });
                    },
                  );
                },
              );
              if (selectedIds != null) {
                setState(() {
                  _selectedUsersId = selectedIds;
                });
              }
            },
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Seleccionar Usuarios',
                border: OutlineInputBorder(),
              ),
              child: Text(_selectedUsersId.isEmpty
                  ? 'No se seleccionaron usuarios'
                  : _selectedUsersId.join(', ')),
            ),
          ),

          const SizedBox(height: 20),


          // Botones de acción
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Guardar'),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Obtener la hora actual para el start_time si es necesario
      String startTime = DateTime.now().toIso8601String();

      // Crear un nuevo objeto Group
      final newGroup = Group(
        createdAt: DateTime.now().toIso8601String(),
        createdBy: 'current_user', // Esto puede ser reemplazado por el usuario actual
        deletedAt: '',
        deletedBy: '',
        description: _descriptionController.text,
        device: _deviceIdController.text,
        endDate: _endDate?.toIso8601String() ?? '',
        endTime: _endTime != null ? _endTime!.format(context) : '',
        startDate: _startDate?.toIso8601String() ?? '',
        startTime: _startTime != null ? _startTime!.format(context) : startTime,
        timeTolerance: int.parse(_timeToleranceController.text),
        title: _titleController.text,
        updatedAt: '',
        updatedBy: '',
        usersId: _selectedUsersId,
      );

      // Agregar el grupo a Firestore
      FirebaseFirestore.instance
          .collection('groups')
          .add(newGroup.toMap())
          .then((docRef) {
        // Una vez creado el documento, asignamos el ID generado a la propiedad id del objeto Group
        newGroup.id = docRef.id; // Asignar el id generado por Firestore

        // Actualizamos el grupo en Firestore con el ID correcto
        docRef.update({
          'id': newGroup.id, // Guardamos el id dentro del documento
        }).then((_) {
          // Llamar a onGroupCreated si es necesario
          if (widget.onGroupCreated != null) {
            widget.onGroupCreated!(newGroup);
          }
  
          // Cerrar el modal
          Navigator.pop(context);

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Grupo creado exitosamente')),
          );
        });
      }).catchError((error) {
        // Manejar error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear grupo: $error')),
        );
      });
    }
  }
}
