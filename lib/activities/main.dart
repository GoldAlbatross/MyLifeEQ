import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_life_eq/activities/home.dart';
import 'package:my_life_eq/activities/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const StartScreen(),
      '/my_life_eq': (context) => const Home(),
    },
  ));
}
