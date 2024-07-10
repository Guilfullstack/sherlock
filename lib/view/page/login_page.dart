import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/widgets/imput_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserController userController = UserController();

  // Função para verificar se o usuário está logado
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Navega para a tela inicial se o usuário estiver logado
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); // Chave para o formulário

    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 10),
              FractionallySizedBox(
                widthFactor: 0.4,
                child: TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      userController.loginSystem(
                          context,
                          userController.login.text.trim(),
                          userController.password.text.trim());
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
