import 'package:flutter/material.dart';
import "widgets.dart";

class HeaderCoder extends StatefulWidget {
  const HeaderCoder({Key? key}) : super(key: key);

  @override
  _HeaderCoderState createState() => _HeaderCoderState();
}

class _HeaderCoderState extends State<HeaderCoder> {
  String _title = 'Overview';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(top: 70.0, left: 30.0, bottom: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: 16.0), // Padding adicional a la derecha
              child: Text(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  "REPORTES"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0, // Elimina la sombra del botón
              ),
              onPressed: () {
                // Acción cuando se presiona el botón
                print('Cerrar sesión');
              },
              child: Text(
                style: TextStyle(color: Colors.black),
                'Cerrar sesión',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
