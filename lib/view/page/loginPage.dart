import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/user_adm.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //Expanded(child: Container()),
            Image.asset(
              'images/logo.png',
              //width: 100,
              // height: 100,
            ),
            TextFormField(
              controller: userController.email,
            ),
            TextFormField(
              controller: userController.password,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {},
                  child: const Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    UserAdm newAdm = UserAdm(
                        login: userController.email.text,
                        password: userController.password.text);
                    userController.addUserAdm(newAdm);
                  },
                  child: const Text('Cadastro'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
