import 'package:flutter/material.dart';

class FilterAdmin extends StatefulWidget {
  const FilterAdmin({super.key});

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  int? selectedGroup;

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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Botón de aplicar filtro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
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
