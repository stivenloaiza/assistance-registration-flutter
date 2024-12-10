import 'package:flutter/material.dart';

class FilterCoder extends StatefulWidget {
  const FilterCoder({super.key});

  @override
  State<FilterCoder> createState() => _FilterCoderState();
}

class _FilterCoderState extends State<FilterCoder> {
  // Variables para almacenar los valores seleccionados
  int? selectedGroup;
  int? selectedNumber;

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
                // Fila con el título "Grupo" y el selector de grupo
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

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Distribuir botones
                  children: [
                    // Botón 1
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0, // Elimina la sombra del botón
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber =
                              1; // Establece el número seleccionado como 1
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
                        elevation: 0.0, // Elimina la sombra del botón
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber =
                              2; // Establece el número seleccionado como 2
                        });
                        print("Botón 2 presionado");
                      },
                      child: const Text(
                        "Semena",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Botón 3
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0, // Elimina la sombra del botón
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber =
                              3; // Establece el número seleccionado como 3
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
                        elevation: 0.0, // Elimina la sombra del botón
                      ),
                      onPressed: () {
                        setState(() {
                          selectedNumber =
                              4; // Establece el número seleccionado como 4
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

                // Botón de aplicar filtro
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0, // Elimina la sombra del botón
                  ),
                  onPressed: () {
                    // Lógica para aplicar el filtro
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
