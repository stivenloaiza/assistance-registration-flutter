import 'package:asia_project/views/reports_admin_view.dart';
import 'package:asia_project/views/reports_coders_views.dart';
import 'package:asia_project/views/test_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; 

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  print("Existing Firebase Apps before init ${Firebase.apps}");

  try {
    // Check if Firebase is already initialized
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
  } on FirebaseException catch (e) {
    print('Firebase Error: ${e.code}');
    print('Firebase Error Message: ${e.message}');
    print("Firebase after init: ${Firebase.apps}");
  } catch (e) {
    print('Unexpected error during Firebase initialization: $e');
  }

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
      home: const ReportsAdmin(),
    );
  }
}
