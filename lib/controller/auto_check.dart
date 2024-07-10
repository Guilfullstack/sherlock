/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/page/home_page.dart';
import 'package:sherlock/view/page/login_page.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    UserController auth = Provider.of<UserController>(context);

    if (auth.isLoading) {
      return loading();
    } else if (auth.user == null) {
      return LoginPage();
    } else {
      // Verifica se o e-mail do usuário foi verificado antes de conceder acesso ao aplicativo
      bool isEmailVerified = auth.user!.emailVerified;
      if (isEmailVerified) {
        //dashboard ou tela inicial
        return const HomePage();
      } else {
        // E-mail não verificado, redireciona para a tela de login para confirmar o e-mail
        return LoginPage();
      }
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
*/