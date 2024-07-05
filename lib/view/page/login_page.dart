import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/widgets/imput_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); // Chave para o formulário

    return Scaffold(
      backgroundColor: Colors.black87,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'images/logo.png',
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    ImputTextFormField(
                        title: "Login", controller: userController.login),
                    const SizedBox(height: 20),
                    ImputTextFormField(
                        title: "Senha", controller: userController.password),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: ElevatedButton(
                  onPressed: () async {
                    userController.loginSystem(
                        context,
                        userController.login.text,
                        userController.password.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 20),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
