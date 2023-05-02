import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  dynamic xxx = 0;
  final String dailyTasks = 'DailyTasks';
  final String blocks = 'Gathered Blocks';
  final date = DateTime.now().toString().substring(0, 10);
  final List<String> toDoList = ['took a step towards my health', 'took a step towards my goal',
    'added a little bit of fun', 'added a little bit of study',
    'helped someone in need', 'experienced happiness today', 'lazy day'
  ];
  List<dynamic> array = [];

  void increment(int index) async {
    final element = array[index];
    final collection = FirebaseFirestore.instance.collection(element);
    final document = await collection.doc(element).get();
    final count = document.get(element) as int;
    // collection.doc(dailyTasks).update({dailyTasks: count + 1});
    await FirebaseFirestore.instance
        .collection(element)
        .doc(element)
        .set({element: count + 1}, SetOptions(merge: true));
    print('+++++++++-> $index<-+++++++++++');
    print('+++++++++-> $element<-+++++++++++');
    print('\n++++++++++++++++$array++++++++++++++\n');
  }



  void deleteTask(int index) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(date).get();
    if(snapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = snapshot.docs.first;
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> list = data[dailyTasks] as List<dynamic>;
      if (index >= 0 && index < list.length) {
        var key = list[index] as String;
        list.removeAt(index);
        await FirebaseFirestore.instance.collection(date).doc(documentSnapshot.id).update({dailyTasks: list});






      }
    }
  }



void saveList() async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(dailyTasks).get();
  if(snapshot.docs.isEmpty) {
    FirebaseFirestore.instance.collection(dailyTasks).add({dailyTasks: toDoList});
    for(var str in toDoList) {
      await FirebaseFirestore.instance
          .collection(str)
          .doc(str)
          .set({str: 0}, SetOptions(merge: true));

    }
  }

  QuerySnapshot currentData = await FirebaseFirestore.instance.collection(date).get();
  if(currentData.docs.isEmpty) {
    FirebaseFirestore.instance.collection(date).add({dailyTasks: toDoList});
  }
}

  Future<List<String>> getList() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection(date).get();
      final data = snapshot.docs.first.data() as Map<String, dynamic>;
      final list = data[dailyTasks] as List<dynamic>;
      List<String> tempList = [];
      tempList = List<String>.from(list);
      return tempList;
  }



  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    saveList();
    List<String> tempList = await getList();
    setState(() {
      array = tempList;

    });
  }


  @override
  void initState() {
    super.initState();
    initFirebase();
  }

  void openLibrary() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.grey.shade600,
            appBar: AppBar(
                backgroundColor: Colors.deepOrange.shade400,
                title: Text(blocks)),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Column(
                  children: const [
                    Text(
                      'Описание действия\n',
                      style: TextStyle(fontSize: 26),
                    ),
                    Text(
                      'Тут будет описано как пользоваться приложением в целом и описание за что отвечает конкретная кнопка на которую нажал пользователь',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),

              ),
            ));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.grey.shade800,
            body: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
                itemCount: array.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(array[index]),
                    onDismissed: (direction) async {
                      increment(index);
                      deleteTask(index);

                    },
                    child: Card(
                      elevation: 10.0,
                      shadowColor: Colors.black,
                      color: Colors.transparent,
                      margin: const EdgeInsets.all(20),
                      child: ListTile(
                        title: Text(array[index],style: const TextStyle(fontSize: 15, fontFamily: 'BrunoAceSC'),),
                        tileColor: Colors.deepOrange.shade400,
                        contentPadding: const EdgeInsets.only(left: 16.0),
                        shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),),
                        trailing: IconButton(
                          onPressed: () => openLibrary(),
                          color: Colors.black,
                          iconSize: 18,
                          icon: const Icon(Icons.info_outline),
                        ),
                      ),
                    ),
                  );
                }
            )
        )
    );
  }
}

//'took a step towards my health', 'took a step towards my goal', 'added a little bit of fun', 'added a little bit of study', 'helped someone in need', 'experienced happiness today', 'lazy day'


// void saveList() async {
//   FirebaseFirestore.instance.collection(currentList).add({date: toDoList});
//   for (var i in toDoList) {
//     FirebaseFirestore.instance.collection(i).add({blocks: 0});
//   }
// }
