import 'package:flutter/material.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/view/widgets/imput_text.dart';

class ControllerPanelPage extends StatefulWidget {
  const ControllerPanelPage({super.key});

  @override
  State<ControllerPanelPage> createState() => _ControllerPanelPageState();
}

class _ControllerPanelPageState extends State<ControllerPanelPage> {
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controller Panel'),
        ),
        body: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Adicionar Equipes'),
                subtitle: Column(
                  children: [
                    ImputTextFormField(
                      title: 'Nome da Equipe',
                      controller: userController.login,
                    ),
                    ImputTextFormField(
                      title: 'Senha',
                      controller: userController.password,
                    ),
                    ImputTextFormField(
                      title: 'Comfirmar Senha',
                      controller: userController.password,
                    ),
                    Row(
                      children: [
                        //Botão adicionar equipes
                        //Botão remover equipes
                        //Dropdown para acessar o historico das equpes Historico
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Equipes'),
                subtitle: Column(
                  children: [
                    //Lista de equipes,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
