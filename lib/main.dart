import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imagen_api/firebase_options.dart';
import 'package:imagen_api/home.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomeScreen()
    );
  }
}
