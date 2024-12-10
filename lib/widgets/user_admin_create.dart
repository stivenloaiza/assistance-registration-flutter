import 'package:flutter/material.dart';
import 'package:asia_project/models/user_model.dart';
import 'package:asia_project/controllers/users_controller.dart';

class UserForm extends StatefulWidget {
  final Function? onUserCreated;

  const UserForm({Key? key, this.onUserCreated}) : super(key: key);

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final UserController _userController = UserController();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentNumberController = TextEditingController();
  DateTime? _selectedBirthDate;
  String? _selectedDocumentType;
  String? _selectedRole;
  bool _selectedStatus = true; // Default to active

  final List<String> _documentTypes = ['CC', 'TI'];
  final List<String> _roles = ['admin', 'coder', 'postulante'];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nombre',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Ingrese nombre' : null,
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Ingrese email';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              return !emailRegex.hasMatch(value) ? 'Email inválido' : null;
            },
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Tipo de Documento',
              border: OutlineInputBorder(),
            ),
            value: _selectedDocumentType,
            items: _documentTypes
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            validator: (value) =>
                value == null ? 'Seleccione tipo de documento' : null,
            onChanged: (value) => setState(() => _selectedDocumentType = value),
          ),
          const SizedBox(height: 15),
          TextFormField(
            controller: _documentNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de Documento',
              border: OutlineInputBorder(),
            ),
            validator: (value) => value == null || value.isEmpty
                ? 'Ingrese número de documento'
                : null,
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: _presentDatePicker,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Fecha de Nacimiento',
                border: OutlineInputBorder(),
              ),
              child: Text(
                _selectedBirthDate == null
                    ? 'Seleccionar fecha'
                    : '${_selectedBirthDate!.day}/${_selectedBirthDate!.month}/${_selectedBirthDate!.year}',
              ),
            ),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Rol',
              border: OutlineInputBorder(),
            ),
            value: _selectedRole,
            items: _roles
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            validator: (value) => value == null ? 'Seleccione un rol' : null,
            onChanged: (value) => setState(() => _selectedRole = value),
          ),
          const SizedBox(height: 15),
          SwitchListTile(
            title: const Text('Estado del Usuario'),
            value: _selectedStatus,
            onChanged: (bool value) {
              setState(() {
                _selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 20),
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
        ],
      ),
    );
  }

  void _presentDatePicker() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedBirthDate = pickedDate;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Crear un nuevo objeto User
      final newUser = User(
        id: '', // Firestore generará el ID
        birthDate: _selectedBirthDate?.toIso8601String() ?? '',
        createdAt: DateTime.now().toIso8601String(),
        createdBy:
            'current_user', // Podrías reemplazar esto con el usuario actual
        deletedAt: '',
        deletedBy: '',
        documentNumber: _documentNumberController.text,
        email: _emailController.text,
        faceData: '',
        name: _nameController.text,
        otp: 0, // Valor por defecto, podrías generarlo de manera diferente
        photo: '',
        role: _selectedRole ?? '',
        status: _selectedStatus ?? true, // Usar un valor por defecto si es nulo
        terms: '', // Podrías manejar los términos de manera diferente
      );

      // Instanciar el UserController
      final userController = UserController();

      // Agregar el usuario
      userController.addUser(newUser).then((_) {
        // Cerrar el modal
        Navigator.pop(context);

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario creado exitosamente')),
        );
      }).catchError((error) {
        // Manejar cualquier error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear usuario: $error')),
        );
      });
    }
  }
}
