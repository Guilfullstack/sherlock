import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/imput_text.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // Chave para o formulário

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
                key: _formKey,
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
                    // Verifica se o formulário é válido
                    if (_formKey.currentState!.validate()) {
                      String login = userController.login.text;
                      String password = userController.password.text;

                      print('Login: $login, Password: $password');
                    }
                    userController.loginSystem(
                        context,
                        userController.login.text,
                        userController.password.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 20),
                    padding: EdgeInsets.symmetric(vertical: 20),
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
