import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  String _packName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('packs').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                      title: Text(snapshot.data!.docs[index].get('pack')),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep_outlined),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('packs')
                              .doc(snapshot.data!.docs[index].id)
                              .delete();
                        },
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    FirebaseFirestore.instance
                        .collection('packs')
                        .doc(snapshot.data!.docs[index].id)
                        .delete();
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: const Text('Добавление пачки сигарет'),
                  content: const Text(
                      'Дайте имя вашей пачке сиг типа Усманыч или типа пиписька'),
                  actions: [
                    TextField(
                      onChanged: (text) {
                        _packName = text;
                      },
                    ),
                    ElevatedButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('packs')
                              .add({'pack': _packName});
                          Navigator.of(context).pop();
                        },
                        child: const Text('Добавить'))
                  ],
                );
              });
        },
      ),
    );
  }
}
