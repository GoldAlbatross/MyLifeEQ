import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: const Image(
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
              image: AssetImage('assets/images/wtf.jpeg')),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepOrange.shade500,
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/my_life_eq');
            },
            child: const Text(
              'Go',
              style: TextStyle(
                  fontSize: 22, color: Colors.black, fontFamily: 'BrunoAceSC'),
            ),
          ),
        ),
    );

  }
}
