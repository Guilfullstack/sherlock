import 'package:flutter/material.dart';

class Menssage extends StatelessWidget {
  final String menssage;
  const Menssage({super.key, required this.menssage});

  @override
  Widget build(BuildContext context) {
    return showMenssage(context, menssage);
  }
}

showMenssage(BuildContext context, String text) {
  
}
