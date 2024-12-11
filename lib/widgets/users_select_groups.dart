import 'package:asia_project/models/user_model.dart';
import 'package:flutter/material.dart';

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
    _selectedUsers = List.from(widget.selectedUserIds); // Inicializa con los usuarios seleccionados
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
                  if (selected != null) {
                    if (selected) {
                      _selectedUsers.add(user.id);
                    } else {
                      _selectedUsers.remove(user.id);
                    }
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onSelectionChanged(_selectedUsers); // Pasar la selección al controlador
            Navigator.pop(context); // Cerrar el diálogo
          },
          child: const Text('Aceptar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context), // Cerrar el diálogo sin hacer cambios
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
