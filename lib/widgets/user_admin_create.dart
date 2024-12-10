import 'package:flutter/material.dart';
class UserForm extends StatefulWidget {
  const UserForm({Key? key}) : super(key: key);
  @override
  State<UserForm> createState() => _UserFormState();
}
class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentNumberController = TextEditingController();
  DateTime? _selectedBirthDate;
  String? _selectedDocumentType;
  String? _selectedRole;
  String? _selectedStatus;
  final List<String> _documentTypes = ['CC', 'TI'];
  final List<String> _roles = ['admin', 'coder', 'postulante'];
  final List<String> _status = ['activo','inactivo'];
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
              return !emailRegex.hasMatch(value) 
                ? 'Email inválido' 
                : null;
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
              .map((type) => DropdownMenuItem(
                value: type, 
                child: Text(type)
              ))
              .toList(),
            validator: (value) => 
              value == null ? 'Seleccione tipo de documento' : null,
            onChanged: (value) => 
              setState(() => _selectedDocumentType = value),
          ),
          
          const SizedBox(height: 15),
          TextFormField(
            controller: _documentNumberController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Número de Documento',
              border: OutlineInputBorder(),
            ),
            validator: (value) => 
              value == null || value.isEmpty ? 'Ingrese número de documento' : null,
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
              .map((role) => DropdownMenuItem(
                value: role, 
                child: Text(role)
              ))
              .toList(),
            validator: (value) => 
              value == null ? 'Seleccione un rol' : null,
            onChanged: (value) => 
              setState(() => _selectedRole = value),
          ),
          const SizedBox(height: 15),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Estado del Usuario',
              border: OutlineInputBorder(),
            ),
            value: _selectedStatus,
            items: _status
              .map((type) => DropdownMenuItem(
                value: type, 
                child: Text(type)
              ))
              .toList(),
            validator: (value) => 
              value == null ? 'Selecciona el rol' : null,
            onChanged: (value) => 
              setState(() => _selectedStatus = value),
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
      final userData = {
        'id':'',
        'name': _nameController.text,
        'email': _emailController.text,
        'document_type': [_selectedDocumentType],
        'document_number': _documentNumberController.text,
        'birth_date': _selectedBirthDate?.toIso8601String(),
        'role': [_selectedRole],
        'created_at': DateTime.now().toIso8601String(),
        'created_by': 'current_user',
        'status': [_selectedStatus],
        'terms': '',
        'face_data': '',
        'photo': '',
        'otp': '',
      };
      print('Datos de usuario: $userData');
      Navigator.pop(context);
    }
  }
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _documentNumberController.dispose();
    super.dispose();
  }
}