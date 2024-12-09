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
      child: Padding(
        padding: EdgeInsets.only(
            top: 60.0,
            left: 30.0), // Padding de 60 píxeles arriba y 30 a la izquierda
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconWidget(),
            Padding(
              padding: EdgeInsets.only(
                  right: 16.0), // Padding adicional a la derecha
              child: Text(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  "Mis reportes"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                side: BorderSide(color: Colors.white, width: 2), // Borde blanco
                padding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onPressed: () {
                // Acción cuando se presiona el botón
                print('Iniciar sesión');
              },
              child: Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white), // Estilo del texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
