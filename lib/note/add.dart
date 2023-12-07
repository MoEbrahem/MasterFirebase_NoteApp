import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/customButtonAdd.dart';
import 'package:flutter_firebase/components/customTextFormAdd.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/note/view.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  bool isLoading = false;

  File? file;
  String? url;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  addnote(context) async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.docid)
        .collection('note');

    if (formstate.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        // ignore: unused_local_variable
        DocumentReference response = await notes.add({
          "notes": note.text,
          "url"  : url ?? 'none',
        });
        // ignore: use_build_context_synchronously
        Navigator.of(context).push( MaterialPageRoute(
              builder: (context) => ViewNote(categoryid: widget.docid)));
      } catch (e) {
        isLoading = false;
        setState(() {});
        // ignore: avoid_print
        print("Error $e");
      }
    }
  }

  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
      var imagename = basename(image.path);
      var refstorage = FirebaseStorage.instance.ref('images/$imagename');
      await refstorage.putFile(file!);
      url = await refstorage.getDownloadURL();
    }

    setState(() {});
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
          "Add Note",
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
                        // ignore: body_might_complete_normally_nullable
                        validator: (val) {
                          if (val == "") {
                            return "Can't be Empty";
                          }
                        }),
                  ),
                  CustomUploadImage(
                    onPressed: () async{
                      await getImage();
                    },
                    title: "Upload Image",
                    isSelected: url == null ? false : true,
                  ),
                  const SizedBox(height:7),
                  CustomButtonAdd(
                    onPressed: () async{
                      await addnote(context);
                    },
                    title: "Add Note",
                  ),
                  
                ],
              ),
            ),
    );
  }
}
