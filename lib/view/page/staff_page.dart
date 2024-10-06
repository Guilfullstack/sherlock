import 'package:flutter/material.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/page/login_page.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Image.asset(
            'images/logo.png',
          ),
          title: const Text(
            'SHERLOK',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
                icon: const Icon(
                  Icons.info,
                  color: Colors.purple,
                )),
            IconButton(
                onPressed: () =>
                    ToolsController.navigate(context, const LoginPage()),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.purple,
                )),
          ],
          shape: const Border(
            bottom: BorderSide(
              color: Colors.white, // Cor da borda
              width: 2.0, // Largura da borda
            ),
          ),
          centerTitle: true,
        ),
        body: Container());
  }
}
