import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterData extends StatefulWidget {
  const FilterData({super.key});

  @override
  State<FilterData> createState() => _FilterDataState();
}

class _FilterDataState extends State<FilterData> {
  Stream<QuerySnapshot> streamdata =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CollectionReference users =
              FirebaseFirestore.instance.collection("users");

          DocumentReference doc1 = users.doc("1");
          DocumentReference doc2 = users.doc("2");

          WriteBatch batch = FirebaseFirestore.instance.batch();
          batch.set(doc1,{
            "name": "Esso",
            "age": 20,
            "money": 500,
            "lang": ["en", "ger"]
          });
          batch.set(doc2, {
            "name": "Nemo",
            "age": 30,
            "money": 1200,
            "lang": ["en", "fr"]
          });
          batch.commit();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          "Filter",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
          child: StreamBuilder(
              stream: streamdata,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("ERROR"));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text("Loading ...."));
                }

                return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, i) {
                    return InkWell(
                      onTap: () {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(snapshot.data!.docs[i].id);

                        FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot snapshot =
                              await transaction.get(documentReference);

                          if (snapshot.exists) {
                            var snapshotData = snapshot.data();

                            if (snapshotData is Map<String, dynamic>) {
                              int money = snapshotData['money'] + 100;
                              transaction
                                  .update(documentReference, {'money': money});
                            }
                          }
                        });
                      },
                      child: Card(
                        child: ListTile(
                          trailing: Text(
                            "${snapshot.data.docs[i]['money']}\$",
                            style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                          title: Text(
                            "${snapshot.data.docs[i]['name']}",
                            style: const TextStyle(fontSize: 20),
                          ),
                          subtitle: Text(
                            "${snapshot.data!.docs[i]['age']}",
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                    );
                  },
                );
              })),
    );
  }
}
