import 'package:flutter/material.dart';

class FilterAdmin extends StatefulWidget {
  const FilterAdmin({super.key});

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  // Variables para almacenar los valores seleccionados
  int? selectedGroup;

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
                // Fila con el título "Grupo" y el selector de grupo
                Row(
                  children: [
                    Text(
                      'Grupos:', // Título "Grupo"
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 12), // Espacio entre el título y el dropdown
                    // Selector de grupo (1-5)
                    Expanded(
                      child: DropdownButtonFormField<int>(
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
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Botón de aplicar filtro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0, // Elimina la sombra del botón
                  ),
                  onPressed: () {
                    // Lógica para aplicar el filtro
                    print("Grupo");
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
