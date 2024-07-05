import 'package:flutter/material.dart';

class ControllerPanelPage extends StatefulWidget {
  const ControllerPanelPage({super.key});

  @override
  State<ControllerPanelPage> createState() => _ControllerPanelPageState();
}

class _ControllerPanelPageState extends State<ControllerPanelPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controller Panel'),
        ),
        body: const Column(
          children: [
            Card(
              child: ListTile(
                title: Text('Adicionar Equipes'),
                subtitle: Column(children: [
                  //campo text nome
                  //campo text senha
                  //compo text confirma senha
                  Row(
                    children: [
                      //Botão adicionar equipes
                      //Botão remover equipes
                      //Dropdown para acessar o historico das equpes Historico
                    ],
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
                ],),
              ),
            )
          ],
        ),
      ),
    );
  }
}
