import 'package:flutter/material.dart';
import "widgets.dart";

class HeaderAdmin extends StatefulWidget {
  const HeaderAdmin({Key? key}) : super(key: key);

  @override
  _HeaderAdminState createState() => _HeaderAdminState();
}

class _HeaderAdminState extends State<HeaderAdmin> {
  String _title = 'Overview';

  void _changeTitle() {
    setState(() {
      _title = _title == 'Overview' ? 'Dashboard' : 'Overview';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Establece el color de fondo a blanco
      child: Padding(
        padding: EdgeInsets.only(
          top: 60.0,
          left: 30.0,
        ), // Padding de 60 píxeles arriba y 30 a la izquierda
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconWidget(),
            Padding(
              padding: EdgeInsets.only(
                  right: 16.0), // Padding adicional a la derecha
              child: Text(
                "REPORTES CODERS", // Asegúrate de que el texto esté en un formato correcto
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
