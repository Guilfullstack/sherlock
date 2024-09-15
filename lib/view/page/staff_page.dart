import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';

class StaffPage extends StatefulWidget {
  const StaffPage({super.key});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  UserController user = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Staff'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                user.logout(context);
              },
            )
          ],
        ),
        body: Container());
  }
}
