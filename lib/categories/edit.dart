import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/customButtonAdd.dart';
import 'package:flutter_firebase/components/customTextFormAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCategory extends StatefulWidget {
  final String oldname;
  final String docid;
  const EditCategory({super.key, required this.oldname, required this.docid});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  bool isLoading = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  editCategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        // ignore: unused_local_variable
        await categories.doc(widget.docid).update({"name": name.text});
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
        // ignore: avoid_print
        print("Error $e");
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldname;
    super.initState();
  }
    @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Category",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formstate,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: CustomTextFormAdd(
                        hint: "Enter Your Name",
                        mycontroller: name,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be Empty";
                          }
                          return null;
                        }),
                  ),
                  CustomButtonAdd(
                    onPressed: () async {
                      await editCategory();
                    },
                    title: "Save",
                  )
                ],
              ),
            ),
    );
  }
}
