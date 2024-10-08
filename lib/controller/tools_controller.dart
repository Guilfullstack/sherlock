import 'package:flutter/material.dart';

class ToolsController {
  static void dialogMensage(
      BuildContext context, String title, String mensage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF212A3E),
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          content: Text(
            mensage,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void scafoldMensage(
      BuildContext context, Color color, String mensage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: color, content: Text(mensage)),
    );
  }

  static void navigate(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  static void navigateReturn(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}
