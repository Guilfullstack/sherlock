import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/widgets/imput_text.dart';

// ignore: must_be_immutable
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
                widthFactor: 0.4,
                child: TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      userController.loginSystem(
                          context,
                          userController.login.text,
                          userController.password.text);
                    }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 90, 29, 160)),
                  ),
                  child: const Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
