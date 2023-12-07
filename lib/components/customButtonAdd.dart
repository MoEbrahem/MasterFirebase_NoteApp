import 'package:flutter/material.dart';

class CustomButtonAdd extends StatelessWidget {
  const CustomButtonAdd(
      {super.key, required this.onPressed, required this.title});
  final void Function()? onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      onPressed: onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: Colors.orange,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class CustomUploadImage extends StatelessWidget {
  const CustomUploadImage(
      {super.key, required this.onPressed, required this.title, required this.isSelected});
  final void Function()? onPressed;
  final String title;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
    
      height: 50,
      onPressed: onPressed,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: isSelected==true ? Colors.green:Colors.orange,
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
