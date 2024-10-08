import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/page/dashboard_panel.dart';
import 'package:sherlock/view/page/home_page.dart';
import 'package:sherlock/view/widgets/imput_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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

    if (!mounted) return;

    if (isLoggedIn) {
      // Navega para a tela correspondente com base na categoria do usuário
      switch (category) {
        case 'Adm':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashboardPanel()));
          break;
        case 'Team':
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
          break;
        default:
          // Caso não haja uma categoria válida, volte para a tela de login
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      checkLoginStatus();
    });
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
                'images/logo2.png',
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600, // Define a largura máxima para o campo
                      ),
                      child: ImputTextFormField(
                          title: "Login", controller: userController.login),
                    ),
                    const SizedBox(height: 20),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600, // Define a largura máxima para o campo
                      ),
                      child: ImputTextFormField(
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Define a largura máxima para o campo
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.4,
                  child: userController.loading == true
                      ? const LinearProgressIndicator()
                      : TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                userController.loading = true;
                              });

                              await userController.loginSystem(
                                  context,
                                  userController.login.text.trim(),
                                  userController.password.text.trim());
                              userController.password.clear();
                              setState(() {
                                userController.loading = false;
                              });
                            }
                          },
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                side: const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue),
                          ),
                          child: const Text('Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ),
                ),
              ),
              if (userController.loading == false)
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 400, // Define a largura máxima para o campo
                  ),
                  child: TextButton(
                      onPressed: () {
                        ToolsController.navigateReturn(
                            context, const AboutPage());
                      },
                      child: const Text(
                        'Saiba mais...',
                        style: TextStyle(color: Colors.blue),
                      )),
                )
            ],
          ),
        ),
      ),
    );
  }
}
