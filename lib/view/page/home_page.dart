import 'package:flutter/material.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/card_funtions.dart';
import 'package:sherlock/view/widgets/card_panel_info.dart';
import 'package:sherlock/view/widgets/card_panel_stages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserTeam? currentUser;
  List<Stage>? listStages = [];
  List<Code>? listCode = [];
  List<String>? listTokenDesbloked = [];
  UserController userController = UserController();
  PlayController playController = PlayController();
  TextEditingController codeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _retrieveCurrentUser();
  }

  Future<void> _retrieveCurrentUser() async {
    try {
      UserTeam? userTeamFromHive = await userController.getUserHive();
      List<Stage>? listStagesFromHive =
          await playController.getStageListFromHive();

      List<Code>? listCodeFromHive = await playController.getCodeListFromHive();

      setState(() {
        currentUser = userTeamFromHive;
        listStages = listStagesFromHive;
        listCode = listCodeFromHive;
        listTokenDesbloked = currentUser!.listTokenDesbloqued;
      });
    } catch (e) {
      print("erro home: $e");
    }
  }

  void execultCode(String token) async {
    UserTeam? userTeam = await userController.getUserHive();
    List<Stage> listStage = await playController.getStageListFromHive();

    for (var stage in listStage) {
      if (stage.token == token) {
        // Verifica se o token já está na lista
        if (userTeam!.listTokenDesbloqued!.contains(stage.token)) {
          ToolsController.dialogMensage(
              context, 'Info', 'Essa prova já está desbloqueada!');
        } else {
          userController.updateUserTeamHive('listTokenDesbloqued', token);
          setState(() {});
          ToolsController.scafoldMensage(
              context, Colors.green, 'Prova desbloqueada com sucesso!');
        }
        return;
      }
    }
    ToolsController.scafoldMensage(context, Colors.red, 'Código inválido!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: Image.asset(
          'images/logo.png',
        ),
        title: const Text(
          'SHERLOK',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.info,
                color: Colors.purple,
              )),
          IconButton(
              onPressed: () => userController.logout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.purple,
              )),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.white, // Cor da borda
            width: 2.0, // Largura da borda
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black12,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Exibe as informações do usuário se estiver disponível
              currentUser != null
                  ? CardPanelInfo(
                      credit: currentUser!.credit ?? 0,
                      status: currentUser!.status ?? Status.Jogando,
                    )
                  : const CircularProgressIndicator(),
              //const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardFuntions(icon: Icons.map, nome: 'Mapa', onTap: () {}),
                    const SizedBox(
                      width: 10,
                    ),
                    CardFuntions(
                        icon: Icons.card_giftcard,
                        nome: 'Cartas',
                        onTap: () {}),
                  ],
                ),
              ),
              CardPanelStages(
                liststages: listStages,
                listTokenStageDesbloqued: listTokenDesbloked,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final _formKey = GlobalKey<FormState>();
              final codeController = TextEditingController();

              return AlertDialog(
                title: const Text('Desbloquear Prova'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: codeController,
                        decoration:
                            const InputDecoration(labelText: 'Inserir código'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'O código não pode ser vazio';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final String token = codeController.text;
                        execultCode(token);
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Desbloquear'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.grey,
        child: const Icon(
          Icons.key,
          color: Colors.purple,
        ),
      ),
    );
  }
}
