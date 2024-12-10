import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:asia_project/models/group_model.dart';
import 'package:asia_project/controllers/group_controller.dart';
import 'package:asia_project/services/group_service.dart';

class FilterCoder extends StatefulWidget {
  const FilterCoder({super.key});

  @override
  State<FilterCoder> createState() => _FilterCoderState();
}

class _FilterCoderState extends State<FilterCoder> {
  String? selectedGroup;
  int? selectedNumber;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Future<List<GroupModel>> _groupFuture;

  @override
  void initState() {
    super.initState();
    final GroupService _groupService = GroupService(firestore: _firestore);
    final GroupController _groupController = GroupController(_groupService);
    _groupFuture = _groupController.findAllGroup();
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
                // Row with the title group and the selector group
                Row(
                  children: [
                    const Text(
                      'Groups:', // Title group
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FutureBuilder<List<GroupModel>>(
                        future: _groupFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Text('No groups available');
                          } else {
                            final groups = snapshot.data!;
                            return DropdownButtonFormField<String>(
                              value: selectedGroup,
                              hint: const Text("Select group"),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGroup = newValue;
                                });
                              },
                              items: groups.map((group) {
                                return DropdownMenuItem<String>(
                                  value: group.description ?? "Not description",
                                  child: Text(group.description ?? "Not description"),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Botón 1
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 1;
                        });
                        print("Botón 1 presionado");
                      },
                      child: const Text(
                        "Hoy",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Botón 2
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 2;
                        });
                        print("Botón 2 presionado");
                      },
                      child: const Text(
                        "Semana",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Botón 3
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 3;
                        });
                        print("Botón 3 presionado");
                      },
                      child: const Text(
                        "Mes",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Botón 4
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber = 4;
                        });
                        print("Botón 4 presionado");
                      },
                      child: const Text(
                        "Todos",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Botton apply filter
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                  ),
                  onPressed: () {
                    // Logic for the filter
                    print("Grupo: $selectedGroup, Número: $selectedNumber");
                  },
                  child: const Text(
                    style: TextStyle(color: Colors.black),
                    "Aplicar Filtro",
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
