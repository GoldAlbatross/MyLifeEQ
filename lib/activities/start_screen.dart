import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {

  const StartScreen({Key? key}) : super(key: key);
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {

  final key = 'BaseList';
  final List<String> toDoList = [
    'took a step towards my health',
    'took a step towards my goal',
    'added a little bit of fun',
    'added a little bit of study',
    'helped someone in need',
    'experienced happiness today',
    'lazy day'
  ];
  final date = DateTime.now().toString().substring(0, 10);
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
