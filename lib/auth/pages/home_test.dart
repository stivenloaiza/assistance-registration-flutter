import 'package:flutter/material.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({Key? key}) : super(key: key);

  @override
  _HomeTestState createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
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