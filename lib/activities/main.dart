import 'package:flutter/material.dart';
import 'package:my_life_eq/activities/home.dart';
import 'package:my_life_eq/activities/start_screen.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const StartScreen(),
    '/my_life_eq': (context) => const Home(),
  },
));

