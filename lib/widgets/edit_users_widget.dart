import 'package:flutter/material.dart';
import '../models/user_model.dart'; // Importa el modelo User desde su ubicación

class EditUserModal extends StatefulWidget {
  final User user;
  final Function(User updatedUser) onSave;

  const EditUserModal({
    Key? key,
    required this.user,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditUserModalState createState() => _EditUserModalState();
}

class _EditUserModalState extends State<EditUserModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _documentNumberController;
  late TextEditingController _birthDateController;
  late TextEditingController _roleController;
  late TextEditingController _photoController;
  late TextEditingController _createdByController;
  late TextEditingController _termsController;

  bool _status = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _documentNumberController =
        TextEditingController(text: widget.user.documentNumber);
    _birthDateController = TextEditingController(text: widget.user.birthDate);
    _roleController = TextEditingController(text: widget.user.role);
    _photoController = TextEditingController(text: widget.user.photo);
    _createdByController = TextEditingController(text: widget.user.createdBy);
    _termsController = TextEditingController(text: widget.user.terms);
    _status = widget.user.status;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _documentNumberController.dispose();
    _birthDateController.dispose();
    _roleController.dispose();
    _photoController.dispose();
    _createdByController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final updatedUser = User(
        id: widget.user.id,
        birthDate: _birthDateController.text,
        createdAt: widget.user.createdAt,
        createdBy: _createdByController.text,
        deletedAt: widget.user.deletedAt,
        deletedBy: widget.user.deletedBy,
        documentNumber: _documentNumberController.text,
        email: _emailController.text,
        faceData: widget.user.faceData,
        name: _nameController.text,
        otp: widget.user.otp,
        photo: _photoController.text,
        role: _roleController.text,
        status: _status,
        terms: _termsController.text,
      );

      widget.onSave(updatedUser);
      Navigator.of(context).pop();
    }
  }

  // Navegar a la nueva página
  void _navigateToNewPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Email no válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _documentNumberController,
                decoration:
                    const InputDecoration(labelText: 'Número de Documento'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _birthDateController,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Nacimiento'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _photoController,
                decoration: const InputDecoration(labelText: 'Foto'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _createdByController,
                decoration: const InputDecoration(labelText: 'Creado por'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _termsController,
                decoration: const InputDecoration(labelText: 'Términos'),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Estado'),
                  Switch(
                    value: _status,
                    onChanged: (value) {
                      setState(() {
                        _status = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Botón para redirigir a otra página
              ElevatedButton(
                onPressed: _navigateToNewPage,
                child: const Text('Integrar Foto'),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Página')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Vuelve a la página anterior
          },
          child: const Text('Volver'),
        ),
      ),
    );
  }
}
