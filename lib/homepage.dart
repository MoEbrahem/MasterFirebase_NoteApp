import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/categories/edit.dart';
import 'package:flutter_firebase/note/view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getdata() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.of(context).pushNamed("addcategory");
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text(
          "HomePage",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ViewNote(categoryid: data[i].id)
                            )
                            );
                  },
                  onLongPress: () {
                    // ignore: use_build_context_synchronously
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Warning ',
                      desc: 'اختر ما تريد',
                      btnCancelText: "حذف",
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection("categories")
                            .doc(data[i].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("homepage");
                      },
                      btnOkText: "تعديل",
                      btnOkOnPress: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditCategory(
                                oldname: data[i]['name'], docid: data[i].id)));
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/folder.png",
                            height: 100,
                          ),
                          Text("${data[i]["name"]}"),
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
