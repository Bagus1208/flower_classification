import 'package:firebase_core/firebase_core.dart';
import 'package:flower_classification/views/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Klasifikasi Bunga',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.green),
      ),
      home: const HomePage(),
    );
  }
}
