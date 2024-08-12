import 'package:flutter/material.dart';

class ToolsController {
  static void dialogMensage(
      BuildContext context, String title, String mensage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(mensage),
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
}
