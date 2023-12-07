import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageTaker extends StatefulWidget {
  const ImageTaker({super.key});

  @override
  State<ImageTaker> createState() => _ImageTakerState();
}

class _ImageTakerState extends State<ImageTaker> {
  File? file;
  String? url;
  getImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      file = File(image.path);
      var imagename = basename(image.path);
      var refstorage = FirebaseStorage.instance.ref(imagename);
      await refstorage.putFile(file!);
      url = await refstorage.getDownloadURL();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker"),
      ),
      body: Column(
        children: [
          MaterialButton(
            onPressed: () {
              getImage();
            },
            child: const Text("choose OR take Image"),
          ),
          if (url != null)
            Image.network(
              url!,
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
        ],
      ),
    );
  }
}
