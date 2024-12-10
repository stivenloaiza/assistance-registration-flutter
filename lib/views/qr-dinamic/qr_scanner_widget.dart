import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Para formatear la fecha y hora

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({Key? key}) : super(key: key);

  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  late MobileScannerController _cameraController;
  bool _isProcessing =
      false; // Variable para asegurarnos de que solo procesemos un QR a la vez

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController();
  }

  @override
  void dispose() {
    _cameraController.dispose(); // Liberar recursos al cerrar la pantalla
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Escanear QR"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color.fromRGBO(52, 60, 106, 1),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Color.fromRGBO(52, 60, 106, 1),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: MobileScanner(
          controller: _cameraController,
          onDetect: (capture) async {
            // Evitar procesar un QR si ya estamos en proceso
            if (_isProcessing) return;

            setState(() {
              _isProcessing = true; // Marcar que estamos procesando
            });

            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              final qrData = barcode.rawValue;

              // Mostrar el diálogo mientras verificamos el OTP
              showDialog(
                context: context,
                builder: (_) => const AlertDialog(
                  title: Text("Verificando QR..."),
                  content: CircularProgressIndicator(),
                ),
              );

              if (qrData != null) {
                // Procesamos el QR y verificamos el OTP
                await _verifyOTPAndRegisterAttendance(qrData, context);
                _cameraController
                    .stop(); // Detenemos la cámara después de un escaneo exitoso
                break; // Rompemos el bucle después de un escaneo exitoso
              }
            }

            setState(() {
              _isProcessing = false; // Desmarcar el proceso una vez terminado
            });
          },
        ),
      ),
    );
  }

  // Función para verificar el OTP y registrar la asistencia
  Future<void> _verifyOTPAndRegisterAttendance(
      String qrData, BuildContext context) async {
    try {
      // Decodificar los datos del QR
      final Map<String, dynamic> qrDecoded =
          Map<String, dynamic>.from(jsonDecode(qrData));
      final String userId = qrDecoded["user"];
      final String otpFromQR = qrDecoded["otp"];

      // Obtener el OTP actual del usuario desde Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      // Cerrar el diálogo de verificación una vez que el proceso termine
      Navigator.of(context).pop(); // Cierra el diálogo de "Verificando QR..."

      if (snapshot.exists) {
        // Obtener el OTP del usuario desde Firestore
        String otpFromFirestore = snapshot['otp'];

        // Comparar el OTP del QR con el de Firestore
        if (otpFromQR == otpFromFirestore) {
          // Si los OTP coinciden, registrar la asistencia
          await _registerAttendance(userId);

          // Mostrar mensaje de éxito
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Código QR Detectado"),
              content: const Text('Registro exitoso, bienvenido'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Cerrar el diálogo
                    Navigator.of(context).pop(); // Volver a la página anterior
                  },
                  child: const Text("Cerrar"),
                ),
              ],
            ),
          );
        } else {
          // Si los OTP no coinciden
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("Error"),
              content: const Text('OTP no válido o expirado'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cerrar"),
                ),
              ],
            ),
          );
        }
      } else {
        // Si el usuario no existe
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: const Text('Usuario no encontrado en Firestore'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cerrar"),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print("Error al verificar OTP: $e");
      // Cerrar el diálogo de verificación
      Navigator.of(context).pop();

      // Mostrar un error genérico si algo falla
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: const Text('Hubo un problema al procesar el QR.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cerrar"),
            ),
          ],
        ),
      );
    }
  }

  // Función para registrar la asistencia en Firestore
  Future<void> _registerAttendance(String userId) async {
    try {
      final String dispositiveId =
          "IdDispositive"; // Cambiar por el identificador real del dispositivo
      final String groupId =
          "IdGroup"; // Cambiar por el identificador real del grupo
      final String timeStamp = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(DateTime.now()); // Fecha y hora actuales

      // Crear el registro de asistencia
      await FirebaseFirestore.instance.collection('attendance').add({
        'AttendanceStatus': "onTime", // Suponemos que el usuario está a tiempo
        'Dispositive': dispositiveId,
        'Group': groupId,
        'TimeStamp': timeStamp,
        'Type': "QR",
        'User': userId,
      });

      print("Asistencia registrada correctamente.");
    } catch (e) {
      print("Error al registrar asistencia: $e");
    }
  }
}
