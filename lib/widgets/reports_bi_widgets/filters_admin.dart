import 'package:flutter/material.dart';
import 'package:asia_project/controllers/group_controller.dart';
import 'package:asia_project/models/group_model.dart';
import 'package:asia_project/services/group_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterAdmin extends StatefulWidget {
  const FilterAdmin({super.key});

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  int? selectedGroup;
  late GroupController _groupController;
  late Future<List<GroupModel>> _groupsFuture;

  @override
  void initState() {
    super.initState();
    // Inicializa el controlador y carga los grupos
    final groupService = GroupService(firestore: FirebaseFirestore.instance);
    _groupController = GroupController(groupService);
    _groupsFuture = _groupController.findAllGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Image.asset('assets/images/filtra-logo.png', width: 100.0),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FutureBuilder<List<GroupModel>>(
                        future: _groupsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return const Text("Error al cargar grupos");
                          } else if (snapshot.hasData) {
                            final groups = snapshot.data!;
                            return DropdownButtonFormField<int>(
                              value: selectedGroup,
                              hint: const Text("Select group"),
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedGroup = newValue;
                                });
                              },
                              items: groups.map((group) {
                                return DropdownMenuItem(
                                  value: group.time_tolerance,
                                  child: Text(group.title),
                                );
                              }).toList(),
                              dropdownColor: const Color.fromRGBO(255, 255, 255, 1),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color.fromRGBO(247, 242, 250, 1),
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                              ),
                            );
                          } else {
                            return const Text("No se encontraron grupos");
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(elevation: 0.0),
                  onPressed: () {
                    if (selectedGroup != null) {
                      print("Grupo seleccionado: $selectedGroup");
                    } else {
                      print("No se seleccionó ningún grupo");
                    }
                  },
                  child: const Text(
                    "Aplicar Filtro",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
