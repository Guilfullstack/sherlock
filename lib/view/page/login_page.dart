import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/page/controller_panel_page.dart';
import 'package:sherlock/view/page/home_page.dart';
import 'package:sherlock/view/page/staff_page.dart';
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
  bool _obscureText = true;
  // Função para verificar se o usuário está logado
  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String category = prefs.getString('category') ?? '';

    if (isLoggedIn) {
      // Navega para a tela correspondente com base na categoria do usuário
      switch (category) {
        case 'Adm':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ControllerPanelPage()));
          break;
        case 'Team':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          break;
        case 'Staff':
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const StaffPage())); // Substitua 'StaffPage' pela página correta.
          break;
        default:
          // Caso não haja uma categoria válida, volte para a tela de login
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus();
    });
    //checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>(); // Chave para o formulário
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
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
                      title: "Senha",
                      controller: userController.password,
                      obscure: _obscureText == true ? true : false,
                      icon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // Alternar entre visível e oculto
                          });
                        },
                      ),
                    ),
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
