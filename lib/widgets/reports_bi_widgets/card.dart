import 'package:flutter/material.dart';

class TipsCards extends StatelessWidget {
  const TipsCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTipCard(
          tip: 'Llegar temprano es importante para iniciar el día con energía.',
          icon: Icons.access_time,
        ),
        const SizedBox(height: 8.0),
        _buildTipCard(
          tip: 'Realiza solo un filtro para mirar las asistencias, simplificando el proceso.',
          icon: Icons.filter_list,
        ),
        const SizedBox(height: 8.0),
        _buildTipCard(
          tip: 'El manejo adecuado del tiempo mejora la productividad.',
          icon: Icons.timer,
        ),
        const SizedBox(height: 8.0),
        _buildTipCard(
          tip: 'Mantén una comunicación constante con tu equipo para evitar ausencias imprevistas.',
          icon: Icons.chat,
        ),
        const SizedBox(height: 8.0),
        _buildTipCard(
          tip: 'Registrar la hora de entrada y salida de manera precisa es clave para un buen control.',
          icon: Icons.access_alarm,
        ),
      ],
    );
  }

  Widget _buildTipCard({required String tip, required IconData icon}) {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40.0,
              color: Colors.grey,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                tip,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}