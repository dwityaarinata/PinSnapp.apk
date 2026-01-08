import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize database
  await DatabaseHelper().database;
  runApp(const PinSnapApp());
}

class PinSnapApp extends StatelessWidget {
  const PinSnapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinSnap',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.deepPurple),
      home: const LoginScreen(),
    );
  }
}
