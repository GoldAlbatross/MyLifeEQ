import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {

  const StartScreen({Key? key}) : super(key: key);
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  final key = 'Dima_BaseList';
  final List<String> toDoList = [
    'step to my health',
    'step to my goal',
    'little bit of fun',
    'little bit of study',
    'helped someone',
    'was happy',
    'today lazy day'
  ];
  final date = 'Dima${DateTime.now().toString().substring(0, 10)}';
  bool isFirstStart = true;

  void initFirebase() async {
    isFirstStart = false;
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(key).get();
    if(snapshot.docs.isEmpty) {
      FirebaseFirestore.instance
          .collection(key)
          .doc(key)
          .set({key: toDoList}, SetOptions(merge: true));
      for(var str in toDoList) {
        await FirebaseFirestore.instance
            .collection(str)
            .doc(str)
            .set({str: 0}, SetOptions(merge: false));
      }
    }
  }

  void createDayTasks() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(date).limit(1).get();
    if(snapshot.docs.isEmpty) {
      for(var str in toDoList) {
        await FirebaseFirestore.instance
            .collection(date)
            .add({date: str});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if(isFirstStart) initFirebase();
    createDayTasks();
  }

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
            onPressed: () async {
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
