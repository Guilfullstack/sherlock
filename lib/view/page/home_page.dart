import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/history.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/page/card_page.dart';
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
  bool _isPop2Visible = false;

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

        await _checkUserStatus(
          isStatusActive: currentUser!.status == Status.Congelado,
          isPopupVisible: _isPopupVisible,
          setPopupVisible: (visible) => _isPopupVisible = visible,
          message: 'Sua equipe está congelada por 10 minutos',
          iconContent: const Icon(Icons.ac_unit,
              size: 50, color: Colors.white), // Ícone de congelamento
        );
        await _checkUserStatus(
          isStatusActive: currentUser!.isPrisionBreak == true,
          isPopupVisible: _isPop2Visible,
          setPopupVisible: (visible) => _isPop2Visible = visible,
          message: 'Sua equipe está presa, pague a fiança',
          iconContent: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_police,
                  size: 50, color: Colors.blue), // Ícones de prisão
              Icon(Icons.lock, size: 50, color: Colors.blue),
            ],
          ),
        );
      }
    });
  }

  Future<void> _checkUserStatus({
    required bool isStatusActive,
    required bool isPopupVisible,
    required Function setPopupVisible,
    required String message,
    required Widget iconContent,
  }) async {
    if (currentUser != null) {
      if (isStatusActive && !isPopupVisible) {
        setPopupVisible(true);
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                backgroundColor: const Color(0xFF212A3E),
                title: Center(
                  child:
                      iconContent, // Ícones personalizados com base no status
                ),
                content: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ).then((_) {
          setState(() {
            setPopupVisible(false);
          });
        });
      } else if (!isStatusActive && isPopupVisible) {
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {
          setPopupVisible(false);
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
      ToolsController.scafoldMensage(
          context, Colors.redAccent, 'Código inválido!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Image.asset(
          'images/logo2.png',
        ),
        title: Text(
          'SHERLOCK',
          style: GoogleFonts.anton(
            textStyle: const TextStyle(
              fontSize: 30, // Aumente o tamanho para dar um impacto maior
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing:
                  2.0, // Espaçamento entre letras para efeito de manchete
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                ToolsController.navigateReturn(context, const AboutPage());
              },
              icon: const Icon(
                Icons.info,
                color: Colors.blue,
              )),
          IconButton(
              onPressed: () => userController.logout(context),
              icon: const Icon(
                Icons.logout,
                color: Colors.blue,
              )),
        ],
        shape: const Border(
          bottom: BorderSide(
            color: Colors.blue, // Cor da borda
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
                    nome: 'Map',
                    onTap: () {
                      playController.showFullScreenImage(
                          context, 'images/mapa.png');
                    }),
                const SizedBox(
                  width: 20,
                ),
                CardFuntions(
                    icon: Symbols.poker_chip,
                    nome: 'Cards',
                    onTap: () {
                      ToolsController.navigateReturn(context, const CardPage());
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
                            borderSide: BorderSide(color: Colors.blue),
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
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Desbloquear',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(
          Icons.key,
          color: Color(0xFF212A3E),
        ),
      ),
    );
  }
}
