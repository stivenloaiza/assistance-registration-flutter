import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final CollectionReference devicesCollection =
      FirebaseFirestore.instance.collection('devices');

  final _formKey = GlobalKey<FormState>();
  String? _deviceName, _deviceLocation, _loginCode;
  bool? _deviceStatus;
  bool isEditing = false;
  String? editingDeviceId;

  void _openModal({Map<String, dynamic>? device}) {
    setState(() {
      isEditing = device != null;
      editingDeviceId = device?['id'];
      _deviceName = device?['name'];
      _deviceLocation = device?['location'];
      _loginCode = device?['loginCode'];
      _deviceStatus = device?['status'] ?? false;
    });

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                    DropdownButtonFormField<bool>(
                      value: _deviceStatus,
                      decoration: InputDecoration(labelText: 'Estado'),
                      items: [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Activo'),
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('Inactivo'),
                        ),
                      ],
                      onChanged: (value) => setState(() => _deviceStatus = value),
                      validator: (value) =>
                          value == null ? 'Seleccione un estado' : null,
                    ),
                    TextFormField(
                      initialValue: _loginCode,
                      decoration: InputDecoration(
                          labelText: 'Código de Inicio de Sesión (6 dígitos)'),
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
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveDevice() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (isEditing) {
        await devicesCollection.doc(editingDeviceId).update({
          "name": _deviceName!,
          "location": _deviceLocation!,
          "status": _deviceStatus!,
          "loginCode": _loginCode!,
        });
      } else {
        await devicesCollection.add({
          "name": _deviceName!,
          "location": _deviceLocation!,
          "status": _deviceStatus!,
          "loginCode": _loginCode!,
        });
      }
      Navigator.of(context).pop();
    }
  }

  Future<void> _deleteDevice(String id) async {
    await devicesCollection.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: devicesCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final devices = snapshot.data!.docs.map((doc) {
            return {
              "id": doc.id,
              ...doc.data() as Map<String, dynamic>,
            };
          }).toList();
          return ListView.builder(
            itemCount: devices.length,
            itemBuilder: (context, index) {
              final device = devices[index];
              return Card(
                child: ListTile(
                  title: Text(device['name']),
                  subtitle: Text(
                      'Ubicación: ${device['location']} - Código: ${device['loginCode']}'),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openModal(),
        child: Icon(Icons.add),
      ),
    );
  }
}
