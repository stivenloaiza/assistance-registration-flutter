import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Tips de Asistencia en la Empresa'),
        // ),
        body: TipsWidget(),
      ),
    );
  }
}

class TipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tips = [
    {
      'tip': 'Llegar temprano es importante para iniciar el día con energía.',
      'icon': Icons.access_time, // Icono para tiempo
    },
    {
      'tip': 'Realiza solo un filtro para mirar las asistencias, simplificando el proceso.',
      'icon': Icons.filter_list, // Icono de filtro
    },
    {
      'tip': 'El manejo adecuado del tiempo mejora la productividad.',
      'icon': Icons.timer, // Icono de temporizador
    },
    {
      'tip': 'Mantén una comunicación constante con tu equipo para evitar ausencias imprevistas.',
      'icon': Icons.chat, // Icono de comunicación
    },
    {
      'tip': 'Registrar la hora de entrada y salida de manera precisa es clave para un buen control.',
      'icon': Icons.access_alarm, // Icono de alarma
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Icono antes del texto
                  Icon(
                    tips[index]['icon'],
                    color: Colors.blue, // Cambia el color del icono si lo deseas
                    size: 30,
                  ),
                  SizedBox(width: 12), // Espacio entre el icono y el texto
                  Expanded(
                    child: Text(
                      tips[index]['tip'],
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
