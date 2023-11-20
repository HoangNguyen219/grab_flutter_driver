import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {

   const CustomElevatedButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:  onPressed,
      style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all(Colors.black),
      ),
      //arrived true and completed false -> ongoing
      child:  Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}