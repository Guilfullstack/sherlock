import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sherlock/controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  LoginController loginController = LoginController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Expanded(child: Container()),
          Image.asset(
            'images/logo.png',
            //width: 100,
            // height: 100,
          ),
          TextFormField(
            controller: loginController.email,
          ),
          TextFormField(
            controller: loginController.password,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await loginController.login(
                    loginController.email!.text,
                    loginController.password!.text,
                  );
                },
                child: Text('Login'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await loginController.registerUser(
                    loginController.email!.text,
                    loginController.password!.text,
                  );
                },
                child: Text('Register'),
              ),
            ],
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
