import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Expanded(child: Container()),
          Image.asset(
            'images/sherlockLogo.png',
            width: 100,
            height: 100,
          ),
          TextField(),
          TextField(),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
