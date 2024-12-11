  import 'package:asia_project/controllers/attendance_controller.dart';
  import 'package:asia_project/models/attendance_model.dart';
  import 'package:asia_project/services/attendance_service.dart';
  import 'package:asia_project/utils/utilApplication.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/material.dart';
  import 'package:asia_project/models/group_reports_model.dart';
  import 'package:asia_project/controllers/group_reports_controller.dart';
  import 'package:asia_project/services/group_service.dart';

  class FilterCoder extends StatefulWidget {
    final Function(String) onGroupSelected; // Callback para pasar el grupo seleccionado

    const FilterCoder({super.key, required this.onGroupSelected});

    @override
    State<FilterCoder> createState() => _FilterCoderState();
  }

  class _FilterCoderState extends State<FilterCoder> {
    String? selectedGroup;
    int? selectedNumber;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    late Future<List<GroupModel>> _groupFuture;
    final String userId = "PdYx885x9lac4u7Xx40X";

    @override
    void initState() {
      super.initState();
      final GroupService _groupService = GroupService(firestore: _firestore);
      final GroupController _groupController = GroupController(_groupService);
      _groupFuture = _groupController.findAllGroupByUserId(userId);
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
                        'Groups:',
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
                                    print("select $selectedGroup");
                                  });
                                  if (newValue != null) {
                                    final String _groupById = UtilApplication.filterIdGroupBySelectedGroup(groups, newValue);
                                    widget.onGroupSelected(_groupById);
                                    print("Group selected: $newValue");
                                  }

                                  // Pass the selected group to the parent widget
                                  widget.onGroupSelected(newValue ?? "");
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
                          final attendanceFuture = UtilApplication.attendanceFindByDateRangeInstance(_firestore, "1", userId).then((value){
                            print("Today");
                            print(value);
                          });

                        },
                        child: const Text(
                          "Today",
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
                          final attendanceFuture = UtilApplication.attendanceFindByDateRangeInstance(_firestore, "7", userId).then((value){
                            print("Week");
                            print(value);
                          });
                        },
                        child: const Text(
                          "Week",
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
                          final attendanceFuture = UtilApplication.attendanceFindByDateRangeInstance(_firestore, "1 mes", userId).then((value){
                            print("Month");
                            print(value);
                          });
                        },
                        child: const Text(
                          "Month",
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
                          final attendanceFuture = UtilApplication.getAllAttendanceByUserIdInstance(_firestore, userId).then((value){
                            print("All");
                            value.forEach((element){
                              print("attendanceFuture ${element.timeStamp} ${element.user}");
                            });

                          });
                        },
                        child: const Text(
                          "All",
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
                      "Filter Apply",
                    ),
                  ),
                  // Other widgets here
                ],
              ),
            ),
          ],
        ),
      );
    }

  }

