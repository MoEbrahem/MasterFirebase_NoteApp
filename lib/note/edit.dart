import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/customButtonAdd.dart';
import 'package:flutter_firebase/components/customTextFormAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/note/view.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String categoryid;
  final String oldnote;

  const EditNote(
      {super.key,
      required this.notedocid,
      required this.categoryid,
      required this.oldnote});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isLoading = false;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  // ignore: non_constant_identifier_names
  EditNote() async {
    CollectionReference notesCollection = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryid)
        .collection("note");

    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        // ignore: unused_local_variable
        await notesCollection
            .doc(widget.notedocid)
            .update({"notes": note.text});
        // ignore: use_build_context_synchronously
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(
                  categoryid: widget.categoryid,
                )));
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
    note.text = widget.oldnote;
    super.initState();
  }

  @override
  void dispose() {
    note.dispose();
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
                        hint: "Enter Your Note",
                        mycontroller: note,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be Empty";
                          }
                          return null;
                        }),
                  ),
                  CustomButtonAdd(
                    onPressed: () async {
                      await EditNote();
                    },
                    title: "Save",
                  )
                ],
              ),
            ),
    );
  }
}
