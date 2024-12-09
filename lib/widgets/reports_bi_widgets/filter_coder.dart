import 'package:flutter/material.dart';

class FilterUser extends StatefulWidget {
  const FilterUser({super.key});

  @override
  State<FilterUser> createState() => _FilterUserState();
}

class _FilterUserState extends State<FilterUser> {
  bool showAbsenceDates = false;

  // Ejemplo de fechas de inasistencias
  List<String> absenceDates = [
    "2024-01-01",
    "2024-02-15",
    "2024-03-10",
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        const Text("Estadísticas de Usuario"),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Contenedor de las 2 filas verticales y 3 filas horizontales
              Container(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Columna 1 (Asistencias Totales y Exitosas)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildStatCard('Asistencias Totales', '150'),
                        const SizedBox(height: 16),
                        _buildStatCard('Asistencias Exitosas', '140'),
                      ],
                    ),
                    // Columna 2 (Inasistencias)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showAbsenceDates = !showAbsenceDates;
                            });
                          },
                          child: _buildStatCard('Inasistencias', '10'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Si se presiona "Inasistencias", mostrar las fechas
              if (showAbsenceDates)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.blue.shade50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Fechas de Inasistencias:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      for (var date in absenceDates)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(date),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ));
  }

  // Método para crear las tarjetas de las estadísticas
  Widget _buildStatCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FilterUser(),
  ));
}
