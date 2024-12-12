import 'package:asia_project/views/qr-dinamic/generate_qr_widget.dart';
import 'package:asia_project/views/qr-dinamic/qr_scanner_widget.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seleccionar Acción"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GenerateQRScreen(userId: 'ztBjejaA7sedqntDjMIYcfQwpWG2',)),
                );
              },
              child: const Text("Generar QR"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QRScannerScreen()),
                );
              },
              child: const Text("Escanear QR"),
            ),
          ],
        ),
      ),
    );
  }
}
