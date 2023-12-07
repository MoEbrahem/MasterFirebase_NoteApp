import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  final String? body;
  const Chat({super.key, required this.body});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: Center(
          child: Text(
        "${widget.body}",
        style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.deepOrange),
      )),
    );
  }
}
