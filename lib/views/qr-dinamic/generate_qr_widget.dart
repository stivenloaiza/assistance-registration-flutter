import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:otp/otp.dart';

class GenerateQRScreen extends StatefulWidget {
  final String userId; // Recibe el ID del usuario como parámetro

  const GenerateQRScreen({super.key, required this.userId});

  @override
  _GenerateQRScreenState createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  late Timer _timer;
  String _qrData = '';
  String qrMessage = 'Generando QR...';
  int timeLeft = 30; // Tiempo de expiración del QR
  final String otpSecret =
      "HI893Y23B234H9823Y984Y23H4HJK23HJ4HKJ23HIU4H9283Y4932"; // Secret OTP

  @override
  void initState() {
    super.initState();
    _startQRUpdateTimer();
    _fetchUserData(); // Llamar a Firestore para obtener el UID
  }

  // Obtener el UID de Firestore
  void _fetchUserData() async {
    try {
      // Consulta a Firestore para obtener el usuario con un identificador
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Asumiendo que tu colección se llama 'users'
          .doc(widget.userId) // Usar el ID recibido como parámetro
          .get();

      if (snapshot.exists) {
        String userId = snapshot['id']; // Cambia 'id' por el campo correspondiente
        _generateQRData(userId); // Llama a la función para generar el QR con el UID
      } else {
        setState(() {
          qrMessage = 'Usuario no encontrado';
        });
      }
    } catch (e) {
      setState(() {
        qrMessage = 'Error al obtener usuario: $e';
      });
    }
  }

  // Generar el QR con el UID obtenido y actualizar Firestore
  void _generateQRData(String userId) {
    String otp = OTP.generateTOTPCodeString(
      otpSecret,
      DateTime.now().millisecondsSinceEpoch,
      interval: 5, // Duración del OTP
    );

    // Actualizamos el campo 'otp' en Firestore
    FirebaseFirestore.instance.collection('users').doc(userId).update({
      'otp': otp, // Campo que se actualizará en Firestore
    }).then((_) {
      setState(() {
        qrMessage = 'QR generado: $otp'; // Mensaje para mostrar el OTP generado
      });
    }).catchError((e) {
      setState(() {
        qrMessage = 'Error al actualizar OTP en Firestore: $e';
      });
    });

    Map<String, dynamic> userData = {
      "user": userId,
      "type": "QR",
      "otp": otp,
    };

    setState(() {
      _qrData = jsonEncode(userData); // Generar el QR con los datos
    });
  }

  // Temporizador para actualizar la expiración del QR
  void _startQRUpdateTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          qrMessage = 'QR expirado';
          // Actualizamos el campo 'otp' a vacío en Firestore
          FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
            'otp': "", // Ponemos el OTP en blanco
          }).then((_) {
            setState(() {
              qrMessage = 'QR expirado';
            });
          }).catchError((e) {
            setState(() {
              qrMessage = 'Error al limpiar OTP en Firestore: $e';
            });
          });

          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    // Actualizamos el OTP a vacío en Firestore cuando el usuario salga de la vista
    FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'otp': "", // Ponemos el OTP en blanco
    }).then((_) {
      print("OTP limpiado al salir de la vista.");
    }).catchError((e) {
      print("Error al limpiar OTP al salir de la vista: $e");
    });

    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Generar QR"),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_qrData.isNotEmpty)
              QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: 260.0,
                backgroundColor: Colors.white,
              ),
            const SizedBox(height: 16),
            Text(qrMessage),
            if (timeLeft > 0)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  'Expira en: $timeLeft segundos',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
