import 'package:flutter/material.dart';
import 'package:realtime_face_recognition/views/face-view/face_view.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(
      ),
    );
  }
}