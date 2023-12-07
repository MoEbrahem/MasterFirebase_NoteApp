import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/customButtonAdd.dart';
import 'package:flutter_firebase/components/customTextFormAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isLoading = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories =
      FirebaseFirestore.instance.collection("categories");

  addcategory() async {
    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        // ignore: unused_local_variable
        DocumentReference response = await categories.add({
          "id": FirebaseAuth.instance.currentUser!.uid,
          "name": name.text,
        });
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
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AddCategory",
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
                        }),
                  ),
                  CustomButtonAdd(
                    onPressed: () {
                      addcategory();
                    },
                    title: "Add Category",
                  )
                ],
              ),
            ),
    );
  }
}
