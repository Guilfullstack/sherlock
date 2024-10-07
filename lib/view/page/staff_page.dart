import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/tools_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/history.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/page/about.dart';
import 'package:sherlock/view/page/page%20Panel/list_users.dart';
import 'package:sherlock/view/page/page%20Panel/list_users_staff.dart';
import 'package:sherlock/view/widgets/list_team_controller.dart';

class StaffPage extends StatefulWidget {
  final String staffId;
  final String staffOffice;
  const StaffPage(
      {super.key, required this.staffId, required this.staffOffice});

  @override
  State<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends State<StaffPage> {
  List<Map<String, dynamic>> stageDetails = [];

  PlayController playController = PlayController();
  UserController userController = UserController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Condição para exibir provas

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Card.filled(
                            color: const Color.fromARGB(0, 0, 0, 0),
                            child: ListUsers<Map<String, dynamic>>(
                              aspectRatio: 5,
                              size: MediaQuery.of(context).size.width,
                              stream:
                                  playController.getListStaff(widget.staffId),
                              emptyMessage: 'Não há provas',
                              errorMessage: 'Erro ao carregar provas',
                              itemBuilder: (context, team, index) {
                                return ListTeamController(
                                  listStageProva: true,
                                  user: true,
                                  code: true,
                                  stage: true,
                                  equipe: "${team['description']}",
                                  status: "${team['token']}",
                                );
                              },
                            ),
                          ),
                        );
                      });
                },
                child: const Text("Mostrar Provas"),
              ),
            ),
          ),
          // Condição para exibir equipes da Polícia

          Expanded(
            child: Card.filled(
              color: const Color.fromARGB(0, 0, 0, 0),
              child: ListUsersStaff<UserTeam>(
                stream: userController.teamStream,
                emptyMessage: 'Não há equipes',
                errorMessage: 'Erro ao carregar equipes',
                itemBuilder: (context, team, index) {
                  return ExpansionTile(
                    title: Text(
                      "${team.name}",
                      style: const TextStyle(color: Colors.white),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListTeamController(
                          listPrision: true,
                          addValue: false,
                          remove: false,
                          equipe: team.name,
                          credit: team.credit,
                          usedCardFreeze: team.useCardFrezee,
                          usedCardProtect: team.useCardProtect,
                          prisionBreak: team.isPrisionBreak,
                          isLoged: team.isLoged,
                          status: playController.statusToString(team.status!),
                          onTapEdit: () {
                            bool isSwitch1On = team.isPrisionBreak ?? false;
                            editStaffPolice(team.id!, context, team,
                                isSwitch1On, widget.staffOffice);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> editStaffPolice(String idTeam, BuildContext context,
      UserTeam team, bool isSwitch1On, String office) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "${team.name}",
              style: const TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(builder: (BuildContext context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: office == "Prova" ? false : true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Prisão",
                          style: TextStyle(color: Colors.white),
                        ),
                        Switch(
                          value: isSwitch1On,
                          onChanged: (value) async {
                            await userController.updateTeams(
                                UserTeam(id: team.id, isPrisionBreak: true));
                            String discription =
                                "Equipe \"${team.name}\" foi presa";
                            if (team.isPrisionBreak == false) {
                              await userController.addHistory(
                                History(
                                  idTeam: team.id,
                                  description: discription,
                                ),
                              );
                            }
                            setState(() {
                              isSwitch1On = true;

                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 300,
                      width: 300,
                      child: members(team.id ?? "", team.listMembers ?? []))
                ],
              );
            }),
          );
        });
  }

  Padding members(
    String idTeams,
    List member,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card.filled(
        color: Colors.black,
        child: ListView.builder(
          itemCount: member.length,
          itemBuilder: (context, index) {
            final listMember = member[index];
            return ListTeamController(
              listStageProva: true,
              user: true,
              equipe: listMember,
            );
          },
        ),
      ),
    );
  }
}
