import 'package:asia_project/widgets/service_list.dart';
import 'package:flutter/material.dart';


class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  // Opciones de filtro
  final List<String> filterOptions = [
    "Todos",
    "Dispositivos no autorizados",
    "Acceso fallido",
    "Inactividad prolongada"
  ];

  // Estado del filtro seleccionado
  String selectedFilter = "Todos";

  @override
  Widget build(BuildContext context) {
    // Lista completa de ítems
    final List<Map<String, dynamic>> items = [
      {
        "icon": Icons.warning,
        "title": "Dispositivos no autorizados",
        "color": Colors.yellow,
      },
      {
        "icon": Icons.lock,
        "title": "Acceso fallido",
        "color": Colors.red,
      },
      {
        "icon": Icons.schedule,
        "title": "Inactividad prolongada",
        "color": Colors.orange,
      },
      {
        "icon": Icons.verified,
        "title": "Dispositivo autorizado",
        "color": Colors.blue,
      },
    ];

    // Filtrar ítems según el filtro seleccionado
    final filteredItems = selectedFilter == "Todos"
        ? items
        : items.where((item) => item['title'] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        title: Text(
          "Notificaciones",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile.jpg'), // Cambiar por tu imagen
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra de búsqueda
            TextField(
              decoration: InputDecoration(
                hintText: "Search for something",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
            ),
            SizedBox(height: 24),
            // Botón de filtrar con diseño compacto
            ElevatedButton(
              onPressed: () async {
                String? selected = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Selecciona un filtro"),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: filterOptions.map((filter) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pop(context, filter);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(filter),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                );

                if (selected != null) {
                  setState(() {
                    selectedFilter = selected;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.filter_list, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Filtrar",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            // Lista de ítems filtrados
            Expanded(
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return ServiceListTile(
                    icon: item['icon'],
                    title: item['title'],
                    subtitle: "",
                    color: item['color'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
