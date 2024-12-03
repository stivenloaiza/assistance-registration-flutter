import 'package:asia_project/widgets/student_table.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
     
      title: 'Mi App Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: StudentTable(), 
    );
  }
}


class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
 
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla Principal'),
      ),
      body: Center(
        child: Text(
          '¡Hola, Mundo!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
