import 'package:flutter/material.dart';

class AdminTest extends StatefulWidget {
  const AdminTest({Key? key}) : super(key: key);

  @override
  _AdminTestState createState() => _AdminTestState();
}

class _AdminTestState extends State<AdminTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Servicios'),
      ),
      body: const Center(
        child: Text(
          'TEST',
          style: TextStyle(
            fontSize: 48, 
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}