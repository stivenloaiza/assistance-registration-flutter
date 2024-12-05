import 'package:flutter/material.dart';

void main() {
  runApp(DeviceManagementApp());
}

class DeviceManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeviceManagementScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DeviceManagementScreen extends StatefulWidget {
  @override
  _DeviceManagementScreenState createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  List<Map<String, dynamic>> devices = [
    {"id": "firebase-id-1", "name": "iPad 9A", "location": "Piso 4 Black Bird", "status": "Activo", "loginCode": "123456"},
    {"id": "firebase-id-2", "name": "Cámara B", "location": "Pasillo", "status": "Inactivo", "loginCode": "654321"},
    {"id": "firebase-id-3", "name": "Router C", "location": "Oficina", "status": "Activo", "loginCode": "789012"},
  ];

  final _formKey = GlobalKey<FormState>();
  String? _deviceName, _deviceLocation, _deviceStatus, _loginCode;
  bool isEditing = false;
  String? editingDeviceId;

  void _openModal({Map<String, dynamic>? device}) {
    setState(() {
      isEditing = device != null;
      editingDeviceId = device?['id'];
      _deviceName = device?['name'];
      _deviceLocation = device?['location'];
      _deviceStatus = device?['status'];
      _loginCode = device?['loginCode'];
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isEditing ? 'Editar Dispositivo' : 'Nuevo Dispositivo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _deviceName,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _deviceName = value,
              ),
              TextFormField(
                initialValue: _deviceLocation,
                decoration: InputDecoration(labelText: 'Ubicación'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo requerido' : null,
                onSaved: (value) => _deviceLocation = value,
              ),
              DropdownButtonFormField<String>(
                value: _deviceStatus,
                decoration: InputDecoration(labelText: 'Estado'),
                items: ['Activo', 'Inactivo']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _deviceStatus = value),
                validator: (value) =>
                    value == null ? 'Seleccione un estado' : null,
              ),
              TextFormField(
                initialValue: _loginCode,
                decoration: InputDecoration(labelText: 'Código de Inicio de Sesión (6 dígitos)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo requerido';
                  }
                  if (value.length != 6 || int.tryParse(value) == null) {
                    return 'Debe ser un número de 6 dígitos';
                  }
                  return null;
                },
                onSaved: (value) => _loginCode = value,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveDevice,
                child: Text(isEditing ? 'Actualizar' : 'Crear'),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDevice() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (isEditing) {
        // Actualizar un dispositivo existente
        setState(() {
          final deviceIndex =
              devices.indexWhere((device) => device['id'] == editingDeviceId);
          devices[deviceIndex] = {
            "id": editingDeviceId,
            "name": _deviceName!,
            "location": _deviceLocation!,
            "status": _deviceStatus!,
            "loginCode": _loginCode!, // Permitir editar el código de inicio de sesión
          };
        });
      } else {
        // Crear un nuevo dispositivo
        setState(() {
          devices.add({
            "id": "firebase-id-${devices.length + 1}", // Simula un ID de Firebase
            "name": _deviceName!,
            "location": _deviceLocation!,
            "status": _deviceStatus!,
            "loginCode": _loginCode!, // Usar el código ingresado por el usuario
          });
        });
      }
      Navigator.of(context).pop();
    }
  }

  void _deleteDevice(String id) {
    setState(() {
      devices.removeWhere((device) => device['id'] == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administración de Dispositivos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return Card(
              child: ListTile(
                title: Text(device['name']),
                subtitle: Text('Ubicación: ${device['location']} - Código: ${device['loginCode']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _openModal(device: device),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDevice(device['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openModal(),
        child: Icon(Icons.add),
      ),
    );
  }
}
