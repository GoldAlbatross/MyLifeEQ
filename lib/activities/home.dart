import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final String blocks = 'Gathered Blocks';
  final date = 'Dima${DateTime.now().toString().substring(0, 10)}';

  void incrementValue(String key) async {
    var snapshot = await FirebaseFirestore.instance.collection(key).doc(key).get();
    final num = snapshot.data()![key] as int?;
    if (num != null) {
      await FirebaseFirestore.instance
          .collection(key)
          .doc(key)
          .set({key: num + 1}, SetOptions(merge: true));
    }
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
            body: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(date).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) return const Text('Done!');
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 60),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: Key(snapshot.data!.docs[index].id),
                        onDismissed: (direction) async {
                          incrementValue(snapshot.data!.docs[index].get(date));
                          FirebaseFirestore.instance.collection(date).doc(snapshot.data!.docs[index].id).delete();
                        },
                        child: Card(
                          elevation: 10.0,
                          shadowColor: Colors.black,
                          color: Colors.transparent,
                          margin: const EdgeInsets.all(20),
                          child: ListTile(
                            title: Text(
                              snapshot.data!.docs[index].get(date),
                              style: const TextStyle(fontSize: 16,
                              fontFamily: 'BrunoAceSC'),
                            ),
                            tileColor: Colors.deepOrange.shade400,
                            contentPadding: const EdgeInsets.only(left: 16.0),
                            shape:  const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)),),
                            trailing: IconButton(
                              onPressed: () => openLibrary(),
                              color: Colors.black,
                              iconSize: 20,
                              icon: const Icon(Icons.info_outline),
                            ),
                          ),
                        ),
                      );
                    }
                );
              },
            ),
        )
    );
  }
}




