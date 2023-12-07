import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/note/add.dart';
import 'package:flutter_firebase/note/edit.dart';

class ViewNote extends StatefulWidget {
  final String categoryid;
  const ViewNote({super.key, required this.categoryid});

  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  viewNote() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    viewNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(docid: widget.categoryid)));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () async {
              // GoogleSignIn googleSignIn = GoogleSignIn();
              // googleSignIn.disconnect();
              // await FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("homepage", (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          "View Note",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemBuilder: (context, i) {
                return InkWell(
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Warning ',
                      desc: 'هل انت متأكد من عملية الحذف ؟',
                      btnCancelOnPress: () {},
                      btnOkOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection("categories")
                            .doc(widget.categoryid)
                            .collection('note')
                            .doc(data[i].id)
                            .delete();
                        if (data[i]['url'] != 'none') {
                          FirebaseStorage.instance
                              .refFromURL(data[i]['url'])
                              .delete();
                        }
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ViewNote(categoryid: widget.categoryid)));
                      },
                    ).show();
                  },
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditNote(
                            notedocid: data[i].id,
                            categoryid: widget.categoryid,
                            oldnote: data[i]['notes'])
                            )
                            );
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text("${data[i]['notes']}"),
                          const SizedBox(
                            height: 10,
                          ),
                          if (data[i]['url'] != "none")
                            Image.network(
                              "${data[i]['url']}",
                              height: 80,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
