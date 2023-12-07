import 'package:flutter/material.dart';

class CustomLogoAuth extends StatelessWidget {

  const CustomLogoAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(70),
      ),
      child: Image.asset(
        "images/notes.jpg",
        height: 40,
      ),
    );
  }
}
