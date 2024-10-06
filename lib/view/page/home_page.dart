import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/history.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/widgets/card_funtions.dart';
import 'package:sherlock/view/widgets/card_panel_info.dart';
import 'package:sherlock/view/widgets/card_panel_stages.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserTeam? currentUser;
  List<Stage>? listStages = [];
  List<String>? listTokenDesbloqued = [];
  UserController userController = UserController();
  PlayController playController = PlayController();
  StreamSubscription<DocumentSnapshot>? userSubscription;
  bool _isPopupVisible = false;

  @override
  void initState() {
    super.initState();
    _retrieveCurrentUser();
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    super.dispose();
  }

  Future<void> _retrieveCurrentUser() async {
    try {
      UserTeam? userTeamFromHive = await userController.getUserHive();
      List<Stage>? listStagesFromHive =
          await playController.getStageListFromHive();
      setState(() {
        currentUser = userTeamFromHive;
        listStages = listStagesFromHive;
        listTokenDesbloqued = userTeamFromHive!.listTokenDesbloqued;
        _listenToDatabaseChanges(userTeamFromHive.id!);
      });
    } catch (e) {
      debugPrint("erro home: $e");
    }
  }

  void _listenToDatabaseChanges(String id) {
    userSubscription = FirebaseFirestore.instance
        .collection('Teams')
        .doc(id)
        .snapshots()
        .listen((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        UserTeam updatedUser =
            UserTeam.fromJson(snapshot.data() as Map<String, dynamic>);
        await userController.saveUserHive(updatedUser);
        setState(() {
          currentUser = updatedUser;
        });
        await _checkIfUserIsFrozen();
      }
    });
  }

  Future<void> _checkIfUserIsFrozen() async {
    if (currentUser != null) {
      if (currentUser!.status == Status.Congelado && !_isPopupVisible) {
        _isPopupVisible = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: Color(0xFF212A3E),
                title: Icon(Icons.ac_unit, size: 50, color: Colors.blue),
                content: Text(
                  'Sua equipe está conjelada',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ).then((_) {
          setState(() {
            _isPopupVisible = false;
          });
        });
      } else if (currentUser!.status != Status.Congelado && _isPopupVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          _isPopupVisible = false;
        });
      }
    }
  }

  void execultCode(BuildContext context, String token) async {
    List<Stage> listStage = await playController.getStageListFromHive();
    UserTeam? userTeam = UserTeam();
    for (var stage in listStage) {
      if (stage.token == token) {
        if (listTokenDesbloqued!.contains(stage.token)) {
          if (context.mounted) {
            ToolsController.dialogMensage(
                context, 'Info', 'Essa prova já está desbloqueada!');
          }
        } else {
          userTeam = await userController.getUserHive();
          userTeam!.listTokenDesbloqued!.add(token);
          await userController.saveUserHive(userTeam);
          userController.updateTeams(userTeam);
          userController.addHistory(History(
              idTeam: currentUser!.id,
              description:
                  "Equipe \"${currentUser!.name}\" desbloqueou a prova \"${stage.description}\""));

          setState(() {
            listTokenDesbloqued = userTeam!.listTokenDesbloqued;
          });
          if (context.mounted) {
            ToolsController.scafoldMensage(
                context, Colors.green, 'Prova desbloqueada com sucesso!');
          }
        }
        return;
      }
    }
    if (context.mounted) {
      ToolsController.scafoldMensage(context, Colors.red, 'Código inválido!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Image.asset(
          'images/logo.png',
        ),
        title: const Text(
          'SHERLOCK',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                ToolsController.navigate(context, const AboutPage());
              },
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
      ),
      backgroundColor: const Color(0xFF212A3E),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Exibe as informações do usuário se estiver disponível
          currentUser != null
              ? CardPanelInfo(
                  credit: currentUser!.credit ?? 0,
                  status: currentUser?.status ?? Status.Jogando,
                  useCardFrezee: currentUser!.useCardFrezee ?? false,
                  useCardProtect: currentUser!.useCardProtect ?? false,
                )
              : const CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CardFuntions(
                    icon: Symbols.map,
                    nome: 'Mapa',
                    onTap: () {
                      playController.showFullScreenImage(
                          context, 'images/mapa.png');
                    }),
                const SizedBox(
                  width: 20,
                ),
                CardFuntions(
                    icon: Symbols.poker_chip,
                    nome: 'Cartas',
                    onTap: () {
                      playController.navigateCardPage(context);
                    }),
              ],
            ),
          ),
          CardPanelStages(
            liststages: listStages,
            listTokenStageDesbloqued: listTokenDesbloqued,
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              final formKey = GlobalKey<FormState>();
              final codeController = TextEditingController();

              return AlertDialog(
                backgroundColor: const Color(0xFF212A3E),
                title: const Text(
                  'Desbloquear Prova',
                  style: TextStyle(color: Colors.white),
                ),
                content: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        controller: codeController,
                        decoration: const InputDecoration(
                          labelText: 'Inserir código',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Código',
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        cursorColor: Colors.white,
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
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final String token = codeController.text;
                        execultCode(context, token);

                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text('Desbloquear',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.purple,
        child: const Icon(
          Icons.key,
          color: Color(0xFF212A3E),
        ),
      ),
    );
  }
}
