import 'package:asia_project/auth/pages/login.dart';
import 'package:asia_project/auth/pages/register.dart';
import 'package:asia_project/views/devicemanagementapp.dart';
import 'package:asia_project/views/login_devices.dart';
// import 'package:asia_project/views/login_devices.dart';
import 'package:asia_project/views/notifications_screen.dart';
import 'views/services_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      initialRoute: '/', // Define la ruta inicial
      routes: {
        '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/loginDevice' : (context) => login_devices(),
        // '/notifications': (context) => NotificationsScreen(),
          // '/': (context) => ServicesPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DeviceManagementApp(),
              ),
            );
            }, 
            child: const Text("Device Management")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
              ),
            );
            }, 
            child: const Text("Notifications")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServicesPage(),
              ),
            );
            }, 
            child: const Text("ServicePage")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
              ),
            );
            }, 
            child: const Text("Login")
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterPage(),
              ),
            );
            }, 
            child: const Text("register")
            ),
             const SizedBox(height: 20,),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => login_devices(),
              ),
            );
            }, 
            child: const Text("login devices")
            )
          ],
        ),
      ),
    );
  }
}

// anton tiruriruirur