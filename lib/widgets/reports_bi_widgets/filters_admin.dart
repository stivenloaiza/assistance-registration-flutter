import 'package:flutter/material.dart';

class FilterAdmin extends StatefulWidget {
  const FilterAdmin({super.key});

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  // Variables para almacenar los valores seleccionados
  String name = '';
  int? selectedGroup;
  DateTime? selectedDate;

  // Método para mostrar el selector de fecha
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Selector de grupo (1-5)
                  DropdownButtonFormField<int>(
                    value: selectedGroup,
                    hint: const Text("Seleccionar grupo"),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedGroup = newValue;
                      });
                    },
                    items: List.generate(5, (index) {
                      return DropdownMenuItem(
                        value: index + 1,
                        child: Text("Grupo ${index + 1}"),
                      );
                    }),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Botón de filtro (puedes hacer lo que quieras con los valores aquí)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0, // Elimina la sombra del botón
                    ),
                    onPressed: () {
                      // Aquí puedes agregar la lógica para aplicar los filtros
                      print("Grupo: $selectedGroup");
                    },
                    child: const Text(
                        style: TextStyle(color: Colors.black),
                        "Aplicar Filtro"),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
