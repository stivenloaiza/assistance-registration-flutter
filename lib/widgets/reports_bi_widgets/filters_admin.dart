import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilterAdmin extends StatefulWidget {
  final Function(String) onGroupSelected;

  const FilterAdmin({super.key, required this.onGroupSelected});

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  String? selectedGroup;
  List<String> groupTitles = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('groups').get();
      setState(() {
        groupTitles = querySnapshot.docs.map((doc) => doc['title'] as String).toList();
      });
    } catch (e) {
      print("Error loading groups: $e");
    }
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
                      child: DropdownButtonFormField<String>(
                        value: selectedGroup,
                        hint: const Text("Seleccionar grupo"),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGroup = newValue;
                          });
                          if (newValue != null) {
                            widget.onGroupSelected(newValue);
                          }
                        },
                        items: groupTitles.map((title) {
                          return DropdownMenuItem(
                            value: title,
                            child: Text(title),
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
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                  ),
                  onPressed: () {
                    if (selectedGroup != null) {
                      widget.onGroupSelected(selectedGroup!);
                    }
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
