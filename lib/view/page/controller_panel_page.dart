import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/code.dart';
import 'package:sherlock/model/history.dart';
import 'package:sherlock/model/stage.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_staf.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/custom_dropdown.dart';
import 'package:sherlock/view/widgets/imput_text.dart';
import 'package:sherlock/view/widgets/list_team_controller.dart';

class ControllerPanelPage extends StatefulWidget {
  const ControllerPanelPage({super.key});

  @override
  State<ControllerPanelPage> createState() => _ControllerPanelPageState();
}

class _ControllerPanelPageState extends State<ControllerPanelPage>
    with SingleTickerProviderStateMixin {
  UserController userController = UserController();
  PlayController playController = PlayController();
  bool historyVisible = false;
  late TabController _tabController;
  ValueNotifier<bool> isHistoryVisible = ValueNotifier<bool>(true);
  Category value2 = Category.protect;
  Category value2Edit = Category.protect;
  late String selectionStaff = "Prova";
  late String selectionStaffEdit = "Prova";
  String valueDropDown = "Adicionar";
  bool hasLoadedMembers = false;
  int membersNumeber = 0;

  @override
  void initState() {
    super.initState();
    userController.listTeamSubscription;
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      isHistoryVisible.value =
          _tabController.index != 3; // Update visibility based on selected tab
    });
    //Provider.of<UserController>(context, listen: false).subscribeToTeams();
    //userController.loadTeams();
  }

  @override
  void dispose() {
    userController.listTeamSubscription?.cancel();
    playController.dispose();
    userController.dispose();
    userController.addMemberFocusNode.dispose();
    super.dispose();
  }

  String generateRandomCode(int length) {
    final random = Random();
    const availableChars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final randomString = List.generate(length,
            (index) => availableChars[random.nextInt(availableChars.length)])
        .join();
    return randomString;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Painel de controle'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.group), text: 'Equipes'),
              Tab(icon: Icon(Icons.admin_panel_settings), text: 'Admins'),
              Tab(icon: Icon(Icons.person), text: 'Staff'),
              Tab(icon: Icon(Icons.settings), text: 'Codigo'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                setState(() {
                  userController.logout(context);
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Wrap(
            children: [
              SizedBox(
                width: 824,
                height: MediaQuery.of(context).size.height - 135,
                // height: MediaQuery.of(context).size.width > 830
                //     ? MediaQuery.of(context).size.height - 100
                //     : MediaQuery.of(context).size.height / 2 - 20,
                //height: 500,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    pageTeams(),
                    pageAdm(),
                    pageStaff(),
                    pageTolken(),
                  ],
                ),
              ),
              ValueListenableBuilder<bool>(
                valueListenable: isHistoryVisible,
                builder: (context, value, child) {
                  print(
                      "Histórico Visível: $value"); // Impressão para depuração
                  return value
                      ? history(context, true)
                      : listCodeStage(context, playController, 400);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  //pagina equipes
  Padding pageTeams() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChangeNotifierProvider<UserController>(
        create: (context) => UserController()..teamStream,
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            return Center(
              child: Wrap(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 830
                        ? MediaQuery.of(context).size.height - 140
                        : MediaQuery.of(context).size.height / 2 - 100,
                    child: Card(
                      elevation: 3,
                      shadowColor: const Color.fromARGB(67, 41, 41, 41),
                      color: const Color.fromRGBO(189, 189, 189, 189),
                      child: Form(
                        key: userController.formKey,
                        child: _addTeams(
                            context, false, false, false, userController),
                      ),
                    ),
                  ),
                  //lista das equipes
                  listUsers(context, userController, 400),
                  // history(context)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //paginas adm
  Padding pageAdm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChangeNotifierProvider<UserController>(
        create: (context) => UserController()..admStream,
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            return Center(
              child: Wrap(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 830
                        ? MediaQuery.of(context).size.height - 140
                        : MediaQuery.of(context).size.height / 2 - 100,
                    child: Card(
                      elevation: 3,
                      shadowColor: const Color.fromARGB(67, 41, 41, 41),
                      color: const Color.fromRGBO(189, 189, 189, 189),
                      child: Form(
                        key: userController.formKey,
                        child: _addTeams(
                            context, true, false, false, userController),
                      ),
                    ),
                  ),
                  //lista das equipes
                  listUsersAdm(context, userController, 400),
                  // history(context)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  //pagina staff
  Padding pageStaff() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChangeNotifierProvider<UserController>(
        create: (context) => UserController()..staffStream,
        child: Consumer<UserController>(
          builder: (context, userController, child) {
            return Center(
              child: Wrap(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 830
                        ? MediaQuery.of(context).size.height - 140
                        : MediaQuery.of(context).size.height / 2 - 100,
                    child: Card(
                      elevation: 3,
                      shadowColor: const Color.fromARGB(67, 41, 41, 41),
                      color: const Color.fromRGBO(189, 189, 189, 189),
                      child: Form(
                        key: userController.formKey,
                        child: _addTeams(
                            context, true, false, true, userController),
                      ),
                    ),
                  ),
                  //lista das equipes
                  listUsersStaff(context, userController, 400),
                  // history(context)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

// pagina codigos
  Padding pageTolken() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ChangeNotifierProvider<PlayController>(
        create: (context) => PlayController()..codeStream,
        child: Consumer<PlayController>(
          builder: (context, playController, child) {
            return Center(
              child: Wrap(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width > 830
                        ? MediaQuery.of(context).size.height - 140
                        : MediaQuery.of(context).size.height / 2 - 100,
                    child: Card(
                      elevation: 3,
                      shadowColor: const Color.fromARGB(67, 41, 41, 41),
                      color: const Color.fromRGBO(189, 189, 189, 189),
                      child: Form(
                          key: playController.formKeyPlay,
                          child: _addTolkien(
                              context, playController, false, false)),
                    ),
                  ),
                  //lista das equipes
                  listCode(context, playController, 400),
                  // history(context)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

// lista equipes
  SizedBox listUsers(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 100,
      child: FutureBuilder(
          future: Future.delayed(const Duration(microseconds: 200)),
          builder: (context, snapshot) {
            return Card(
              color: const Color.fromRGBO(189, 189, 189, 189),
              child: StreamBuilder<List<UserTeam>>(
                stream: userController.teamStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    debugPrint("${snapshot.error}");
                    return const Center(
                        child: Text('Erro ao carregas as equipes'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Não há nenhuma equipe'));
                  }

                  final listTeamn = snapshot.data!;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: ListView.builder(
                      itemCount: listTeamn.length,
                      itemBuilder: (context, index) {
                        final team = listTeamn[index];
                        return ListTeamController(
                          addValue: true,
                          equipe: team.name,
                          credit: team.credit,
                          status: playController.statusToString(team.status!),
                          onTapRemove: () {
                            userController.removeUser(0, team.id.toString());
                          },
                          onTapEdit: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.grey,
                              isScrollControlled: false,
                              context: context,
                              builder: (BuildContext context) {
                                userController.memberId.text = team.id ?? "";
                                userController.id.text = team.id ?? "";
                                userController.nameEdit.text = team.name ?? "";
                                userController.loginEdit.text =
                                    team.login ?? "";
                                userController.passwordEdit.text =
                                    team.password ?? "";
                                return Form(
                                  key: userController.formKeyEditTeam,
                                  child: _addTeams(context, false, true, false,
                                      userController),
                                );
                              },
                            );
                          },
                          onTapAddValue: () {
                            userController.addValueStatus.clear();
                            addValue(teamsDropDown, context, userController,
                                team, valueDropDown);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            );
          }),
    );
  }

// lista usuario adm
  SizedBox listUsersAdm(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 100,
      child: Card(
        color: const Color.fromRGBO(189, 189, 189, 189),
        child: StreamBuilder<List<UserAdm>>(
          stream: userController.admStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              debugPrint("${snapshot.error}");
              return const Center(child: Text('Erro ao carrega Adms'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Não há nenhum Adm'));
            }

            final listAdm = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: listAdm.length,
                itemBuilder: (context, index) {
                  final team = listAdm[index];
                  return ListTeamController(
                    user: true,
                    equipe: team.login,
                    //credit: team.credit,
                    onTapRemove: () {
                      userController.removeUser(1, team.id.toString());
                    },
                    onTapEdit: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.grey,
                        isScrollControlled: false,
                        context: context,
                        builder: (BuildContext context) {
                          userController.id.text = team.id ?? "";
                          userController.nameEdit.text = team.name ?? "";
                          userController.loginEdit.text = team.login ?? "";
                          userController.passwordEdit.text =
                              team.password ?? "";
                          return Form(
                            key: userController.formKeyEditTeam,
                            child: _addTeams(
                                context, true, true, false, userController),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

// lista usuario staff
  SizedBox listUsersStaff(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 100,
      child: Card(
        color: const Color.fromRGBO(189, 189, 189, 189),
        child: StreamBuilder<List<UserStaff>>(
          stream: userController.staffStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              debugPrint("${snapshot.error}");
              return const Center(child: Text('Erro ao carrega Adms'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Não há nenhum Adm'));
            }

            final listStaff = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: listStaff.length,
                itemBuilder: (context, index) {
                  final staff = listStaff[index];
                  return ListTeamController(
                    user: true,
                    equipe: staff.login,
                    //credit: staff.credit,
                    onTapRemove: () {
                      userController.removeUser(2, staff.id.toString());
                    },
                    onTapEdit: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.grey,
                        isScrollControlled: false,
                        context: context,
                        builder: (BuildContext context) {
                          userController.id.text = staff.id ?? "";
                          userController.loginEdit.text = staff.login ?? "";
                          userController.passwordEdit.text =
                              staff.password ?? "";
                          selectionStaffEdit = staff.office ?? "";
                          return Form(
                            key: userController.formKeyEditTeam,
                            child: _addTeams(
                                context, false, true, true, userController),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

// listar codigos
  SizedBox listCode(
    BuildContext context,
    PlayController playController,
    double width,
  ) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 100,
      child: Card(
        color: const Color.fromRGBO(189, 189, 189, 189),
        child: StreamBuilder<List<Code>>(
          stream: playController.codeStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              debugPrint("${snapshot.error}");
              return const Center(child: Text('Erro ao carregar Códigos'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Não há nenhum Código'));
            }

            final listCode = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                  const Center(
                    child: Text(
                      'Lista de Codigos',
                      style: TextStyle(fontSize: 18, color: Colors.purple),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: listCode.length,
                      itemBuilder: (context, index) {
                        final code = listCode[index];
                        return ListTeamController(
                          user: true,
                          code: true,
                          equipe: code.description,
                          status: code.token,
                          credit: code.value,
                          category: playController
                              .categoryToString(code.category as Category),
                          onTapRemove: () {
                            playController.removePlay(0, code.id.toString());
                          },
                          onTapEdit: () {
                            showDialog(
                                context: context,
                                builder: (builder) {
                                  playController.id.text = code.id ?? "";
                                  playController.tokenEdit.text =
                                      code.token ?? "";
                                  playController.descriptionEdit.text =
                                      code.description ?? "";
                                  playController.puzzleEdit.text =
                                      code.puzzle ?? "";
                                  playController.valueEdit.text =
                                      code.value.toString();
                                  value2Edit = code.category!;
                                  return Form(
                                    key: playController.formKeyPlayEdit,
                                    child: AlertDialog(
                                      backgroundColor: Colors.grey,
                                      content: SizedBox(
                                        height: 500,
                                        width: 450,
                                        child: _addTolkien(context,
                                            playController, true, false),
                                      ),
                                    ),
                                  );
                                });
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

// lista de condigos das provas
  Padding listCodeStage(
    BuildContext context,
    PlayController playController,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: SizedBox(
        width: width,
        height: MediaQuery.of(context).size.width > 830
            ? MediaQuery.of(context).size.height - 140
            : MediaQuery.of(context).size.height / 2 - 100,
        child: Card(
          color: const Color.fromRGBO(189, 189, 189, 189),
          child: StreamBuilder<List<Stage>>(
            stream: playController.codeStreamFilter,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                debugPrint("${snapshot.error}");
                return const Center(child: Text('Erro ao carregar Códigos'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Não há nenhum Código'));
              }

              final listCode = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Lista de Provas',
                        style: TextStyle(fontSize: 18, color: Colors.purple),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listCode.length,
                        itemBuilder: (context, index) {
                          final code = listCode[index];
                          return ListTeamController(
                            user: true,
                            code: true,
                            stage: true,
                            equipe: code.description,
                            status: code.token,
                            credit: 0,
                            // category: playController
                            //     .categoryToString(code.category as Category),
                            onTapRemove: () {
                              playController.removePlay(1, code.id.toString());
                            },
                            onTapEdit: () {
                              showDialog(
                                  context: context,
                                  builder: (builder) {
                                    playController.id.text = code.id ?? "";
                                    playController.tokenEdit.text =
                                        code.token ?? "";
                                    playController.descriptionEdit.text =
                                        code.description ?? "";
                                    playController.puzzleEdit.text =
                                        code.puzzle ?? "";
                                    playController.valueEdit.text = "0";
                                    value2Edit = Category.stage;
                                    return Form(
                                      key: playController.formKeyPlayEdit,
                                      child: AlertDialog(
                                        backgroundColor: Colors.grey,
                                        content: SizedBox(
                                          height: 500,
                                          width: 450,
                                          child: StatefulBuilder(builder:
                                              (BuildContext context, setState) {
                                            return _addTolkien(context,
                                                playController, true, true);
                                          }),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            //
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

// historico
  Padding history(BuildContext context, bool historyVisible) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Visibility(
        visible: MediaQuery.of(context).size.width > 1329 || historyVisible,
        child: SizedBox(
          width: 400,
          height: MediaQuery.of(context).size.width > 830
              ? MediaQuery.of(context).size.height - 140
              : MediaQuery.of(context).size.height / 2 - 20,
          child: Card(
            elevation: 3,
            shadowColor: const Color.fromRGBO(189, 189, 189, 189),
            color: const Color.fromRGBO(189, 189, 189, 189),
            child: StatefulBuilder(builder: (BuildContext context, setState) {
              return ListView(
                children: [
                  teamsDropDown(setState),
                  Card(
                    color: const Color.fromARGB(0, 255, 255, 255),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height - 220,
                      child: StreamBuilder<List<History>>(
                        stream: userController.historyStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            debugPrint("${snapshot.error}");
                            return const Center(
                                child: Text('Erro ao carregar histórico'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('Não há nenhum histórico'));
                          }

                          final listHistoryc = snapshot.data!;

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListView.builder(
                              itemCount: listHistoryc.length,
                              itemBuilder: (context, index) {
                                final history = listHistoryc[index];
                                if (userController.teamDropDownHistory ==
                                        'Todos' ||
                                    history.idTeam ==
                                        userController.teamIdHistory) {
                                  return ListTeamController(
                                    dateHistory: history.date,
                                    user: true,
                                    history: false,
                                    equipe: history.description,
                                    onTapRemove: () {
                                      userController.removeUser(
                                          3, history.id.toString());
                                    },
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Padding teamsDropDown(StateSetter setState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<UserTeam>>(
        stream: userController.teamStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Nenhuma equipe encontrada.');
          } else {
            List<UserTeam> teams = snapshot.data!;
            List<String> teamNames = ['Todos'];
            Map<String, String> teamIdMap = {};

            for (var team in teams) {
              String name = team.name ?? 'Não há equipes';
              String id = team.id!;
              teamNames.add(name);
              teamIdMap[name] = id;
            }

            return CustomDropdown(
              value: userController.teamDropDownHistory,
              title: "Histórico",
              items: teamNames,
              onChanged: (newValue) {
                setState(() {
                  userController.teamDropDownHistory = newValue!;
                  userController.updateTeamIdHistory(teamIdMap[newValue]);
                });
              },
            );
          }
        },
      ),
    );
  }

  Container _addTeams(BuildContext context, bool addAdm, bool update,
      bool staff, UserController userController) {
    bool obscureVisible = true, obsucreVisibleComfirm = true;
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      //width: 500,
      child: FocusTraversalGroup(
        // policy: OrderedTraversalPolicy(),
        child: ListView(
          children: [
            Center(
              child: Text(
                staff == false
                    ? update == false
                        ? addAdm == true
                            ? "Adicionar Administrador"
                            : 'Adicionar Equipe'
                        : 'Atualizar'
                    : update == true
                        ? 'Atualizar Staff'
                        : 'Adicionar Staff',
                style: const TextStyle(fontSize: 18, color: Colors.purple),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Visibility(
                visible:
                    (addAdm == false && update == true && staff == false) ||
                            update == false && staff == false && addAdm == false
                        ? true
                        : false,
                child: ImputTextFormField(
                  title: 'Nome da Equipe',
                  controller: update == false
                      ? userController.name
                      : userController.nameEdit,
                ),
              ),
            ),
            ImputTextFormField(
              title: 'Login',
              controller: update == false //|| staff == false
                  ? userController.login
                  : userController.loginEdit,
            ),
            StatefulBuilder(builder: (BuildContext context, setState) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: ImputTextFormField(
                      obscure: obscureVisible,
                      icon: IconButton(
                        focusNode: FocusNode(skipTraversal: true),
                        onPressed: () {
                          setState(() {
                            obscureVisible = !obscureVisible;
                          });
                        },
                        icon: Icon(
                          obscureVisible == false
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.purple,
                        ),
                      ),
                      title: 'Senha',
                      controller: update == false
                          ? userController.password
                          : userController.passwordEdit,
                      validator: (value) => value.length < 5
                          ? 'Precisa  ter no minimo 6 caracteres'
                          : null,
                    ),
                  ),
                  ImputTextFormField(
                    obscure: obsucreVisibleComfirm,
                    icon: IconButton(
                      focusNode: FocusNode(skipTraversal: true),
                      onPressed: () {
                        setState(() {
                          obsucreVisibleComfirm = !obsucreVisibleComfirm;
                        });
                      },
                      icon: Icon(
                        obsucreVisibleComfirm == false
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.purple,
                      ),
                    ),
                    title: 'Confirmar Senha',
                    controller: update == false
                        ? userController.passwordComfirm
                        : userController.passwordEditComfirm,
                    validator: (value) {
                      if (value != userController.password.text &&
                          value != userController.passwordEdit.text) {
                        return "Senhas diferentes";
                      }
                      if (value!.length < 6) {
                        return "Sua senha deve ter mínimo 6 caracteres";
                      }
                      if (value.isEmpty) {
                        return "Confirme sua senha";
                      }
                      return null;
                    },
                  ),

                  Visibility(
                    visible: (staff == true && update == false) ||
                            (staff == true && update == true)
                        ? true
                        : false,
                    child: Column(
                      children: [
                        selectStaff(
                          'Prova',
                          update == true ? selectionStaffEdit : selectionStaff,
                          'Prova',
                          (value) {
                            setState(() {
                              update == true
                                  ? selectionStaffEdit = 'Prova'
                                  : selectionStaff = 'Prova';
                              if (update == true) {
                                userController.selectionStaffEdit = 'Prova';
                              }
                            });
                          },
                        ),
                        selectStaff(
                          'Banco',
                          update == true ? selectionStaffEdit : selectionStaff,
                          'Banco',
                          (value) {
                            setState(() {
                              update == true
                                  ? selectionStaffEdit = 'Banco'
                                  : selectionStaff = 'Banco';
                              if (update == true) {
                                userController.selectionStaffEdit = 'Banco';
                              }
                            });
                          },
                        ),
                        selectStaff(
                          'Todos',
                          update == true ? selectionStaffEdit : selectionStaff,
                          'Todos',
                          (value) {
                            setState(() {
                              update == true
                                  ? selectionStaffEdit = 'Todos'
                                  : selectionStaff = 'Todos';
                              if (update == true) {
                                userController.selectionStaffEdit = 'Todos';
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   height: 200,
                  //   child: ListView.builder(
                  //       itemCount: userController.membersTeam.length,
                  //       itemBuilder: (builder, index) {
                  //         setState(() {});
                  //         return Text(userController.membersTeam[index]);
                  //       }),
                  // ),
                  Wrap(
                    alignment: MediaQuery.of(context).size.width > 1329 ||
                            update == true
                        ? WrapAlignment.center
                        : WrapAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userController.loading == false
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (update == true) {
                                    if (userController
                                        .formKeyEditTeam.currentState!
                                        .validate()) {
                                      if (staff == false &&
                                          addAdm == true &&
                                          update == true) {
                                        //atualizar adm
                                        final newUserAdmEdit = UserAdm(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateAdm(newUserAdmEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        //exitWindows();
                                      }
                                      if (staff == true && update == true) {
                                        //atualizar staff
                                        final newUserStaffEdit = UserStaff(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                          office: selectionStaffEdit,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateStaff(newUserStaffEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        //exitWindows();
                                      }
                                      if (staff == true && update == false) {
                                        //add Staff
                                        final newUserStaff = UserStaff(
                                          login: userController.login.text,
                                          password:
                                              userController.password.text,
                                          office: selectionStaff,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .addUserStaff(newUserStaff);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                      } else {
                                        if (update == false) {
                                          //addAdm
                                          if (addAdm == true) {
                                            setState(() {
                                              userController.loading = true;
                                            });
                                            final newUserAdm = UserAdm(
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                            );
                                            await userController
                                                .addUserAdm(newUserAdm);
                                            setState(() {
                                              userController.loading = false;
                                            });
                                            //add Equipe
                                          } else if (addAdm == false) {
                                            final newUserTeams = UserTeam(
                                              name: userController.name.text,
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                              credit: 0,
                                            );
                                            setState(() {
                                              userController.loading = true;
                                            });

                                            await userController
                                                .addUserTeam(newUserTeams);
                                            setState(() {
                                              userController.loading = false;
                                            });
                                          }
                                          //Atualizar Equipe
                                        } else if (update == true) {
                                          // atualizar equipe
                                          final newUserTeamsEdit = UserTeam(
                                            id: userController.id.text,
                                            name: userController.nameEdit.text,
                                            login:
                                                userController.loginEdit.text,
                                            password: userController
                                                .passwordEdit.text,
                                          );
                                          setState(() {
                                            userController.loading = true;
                                          });
                                          await userController
                                              .updateTeams(newUserTeamsEdit);
                                          setState(() {
                                            userController.loading = false;
                                          });
                                          exitWindows();
                                        }
                                      }
                                    }
                                  } else {
                                    if (userController.formKey.currentState!
                                        .validate()) {
                                      if (staff == false &&
                                          addAdm == true &&
                                          update == true) {
                                        //atualizar adm
                                        final newUserAdmEdit = UserAdm(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateAdm(newUserAdmEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      }
                                      if (staff == true && update == true) {
                                        //atualizar staff
                                        final newUserStaffEdit = UserStaff(
                                          id: userController.id.text,
                                          login: userController.loginEdit.text,
                                          password:
                                              userController.passwordEdit.text,
                                          office: selectionStaffEdit,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .updateStaff(newUserStaffEdit);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      }
                                      if (staff == true && update == false) {
                                        //add Staff
                                        final newUserStaff = UserStaff(
                                          login: userController.login.text,
                                          password:
                                              userController.password.text,
                                          office: selectionStaff,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await userController
                                            .addUserStaff(newUserStaff);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                      } else {
                                        if (update == false) {
                                          //addAdm
                                          if (addAdm == true) {
                                            setState(() {
                                              userController.loading = true;
                                            });
                                            final newUserAdm = UserAdm(
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                            );
                                            await userController
                                                .addUserAdm(newUserAdm);
                                            setState(() {
                                              userController.loading = false;
                                            });
                                            //exitWindows;
                                            //add Equipe
                                          } else if (addAdm == false) {
                                            //add team
                                            final newUserTeams = UserTeam(
                                              name: userController.name.text,
                                              login: userController.login.text,
                                              password:
                                                  userController.password.text,
                                              credit: 0,
                                              listMembers: userController
                                                  .membersTeam
                                                  .toList(),
                                            );
                                            setState(() {
                                              userController.loading = true;
                                            });

                                            await userController
                                                .addUserTeam(newUserTeams);
                                            setState(() {
                                              userController.membersTeam
                                                  .clear();
                                              userController.loading = false;
                                            });
                                          }
                                          //Atualizar Equipe
                                        } else if (update == true) {
                                          // atualizar equipe
                                          final newUserTeamsEdit = UserTeam(
                                            id: userController.id.text,
                                            name: userController.nameEdit.text,
                                            login:
                                                userController.loginEdit.text,
                                            password: userController
                                                .passwordEdit.text,
                                          );
                                          setState(() {
                                            userController.loading = true;
                                          });
                                          await userController
                                              .updateTeams(newUserTeamsEdit);
                                          setState(() {
                                            userController.loading = false;
                                          });
                                          exitWindows();
                                        }
                                      }
                                    }
                                  }
                                },
                                child: Text(update == false
                                    ? "Adicionar"
                                    : "Atualizar"))
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      //botão historico
                      Visibility(
                        visible: MediaQuery.of(context).size.width > 1250 ||
                                update == true
                            ? false
                            : true,
                        child: StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  historyVisible = true;
                                  debugPrint("${userController.history}");
                                });

                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Form(
                                          key: userController.formKeyEditTeam,
                                          child: history(context, true));
                                    });
                                historyVisible = false;
                              },
                              child: const Text("Historico"),
                            ),
                          );
                        }),
                      ),
                      Visibility(
                        visible: (addAdm == false &&
                                    update == true &&
                                    staff == false) ||
                                update == false &&
                                    staff == false &&
                                    addAdm == false
                            ? true
                            : false,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: addMembers(
                              false,
                              userController.memberId.text,
                              userController.membersTeam,
                              update == true ? true : false),
                        ),
                      ),
                      // Botão adicionar equipes
                      // Botão remover equipes
                      // Dropdown para acessar o histórico das equipes
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

// add codigo
  Container _addTolkien(BuildContext context, PlayController playController,
      bool update, bool editStage) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      //width: 500,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: ListView(
          children: [
            Center(
              child: Text(
                update == true ? 'Atualizar Código' : 'Adicionar Codigo',
                style: const TextStyle(fontSize: 18, color: Colors.purple),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ImputTextFormField(
                title: 'Descrição',
                controller: update == true
                    ? playController.descriptionEdit
                    : playController.description,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ImputTextFormField(
                icon: IconButton(
                  focusNode: FocusNode(skipTraversal: true),
                  onPressed: () {
                    update == true
                        ? playController.tokenEdit.text = generateRandomCode(6)
                        : playController.token.text = generateRandomCode(6);
                  },
                  icon: const Icon(Icons.generating_tokens),
                  color: Colors.purple,
                ),
                title: 'Codigo',
                controller: update == true
                    ? playController.tokenEdit
                    : playController.token,
              ),
            ),

            //categoria
            StatefulBuilder(builder: (BuildContext context, setState) {
              return Column(
                children: [
                  Visibility(
                    visible:
                        editStage == true && update == true || update == false
                            ? true
                            : false,
                    child: categorySelected(
                      'Prova',
                      update == true ? value2Edit : value2,
                      Category.stage,
                      (value) {
                        setState(() {
                          update == true
                              ? value2Edit = Category.stage
                              : value2 = Category.stage;
                          update == true
                              ? playController.valueEdit.text = "0"
                              : playController.value.text = "0";
                        });
                      },
                    ),
                  ),
                  Visibility(
                    visible: value2 == Category.stage ||
                            (value2Edit == Category.stage &&
                                value2 == Category.stage) ||
                            (value2Edit == Category.stage && update == true) ||
                            (value2 == Category.stage && update == true)
                        ? true
                        : false,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ImputTextFormField(
                        maxLines: 4,
                        title: 'Enigma',
                        controller: update == true
                            ? playController.puzzleEdit
                            : playController.puzzle,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: (value2 == Category.stage ||
                                value2Edit == Category.stage) &&
                            update == true &&
                            editStage == true
                        ? false
                        : true,
                    child: Column(
                      children: [
                        categorySelected(
                          'Adicionar',
                          update == true ? value2Edit : value2,
                          Category.receive,
                          (value) {
                            setState(() {
                              update == true
                                  ? value2Edit = Category.receive
                                  : value2 = Category.receive;
                            });
                          },
                        ),
                        categorySelected(
                          'Subtrair',
                          update == true ? value2Edit : value2,
                          Category.pay,
                          (value) {
                            setState(() {
                              update == true
                                  ? value2Edit = Category.pay
                                  : value2 = Category.pay;
                            });
                          },
                        ),
                        categorySelected(
                          'Congelar',
                          update == true ? value2Edit : value2,
                          Category.freezing,
                          (value) {
                            setState(() {
                              update == true
                                  ? value2Edit = Category.freezing
                                  : value2 = Category.freezing;
                              update == true
                                  ? playController.valueEdit.text = "0"
                                  : playController.value.text = "0";
                            });
                          },
                        ),
                        categorySelected(
                          'Escudo',
                          update == true ? value2Edit : value2,
                          Category.protect,
                          (value) {
                            setState(() {
                              update == true
                                  ? value2Edit = Category.protect
                                  : value2 = Category.protect;
                              update == true
                                  ? playController.valueEdit.text = "0"
                                  : playController.value.text = "0";
                            });
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ImputTextFormField(
                            enabled: value2 == Category.pay ||
                                    value2 == Category.receive ||
                                    value2Edit == Category.pay ||
                                    value2Edit == Category.receive
                                ? true
                                : false,
                            title: 'Valor',
                            controller: update == true
                                ? playController.valueEdit
                                : playController.value,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: userController.loading == false
                            ? ElevatedButton(
                                onPressed: () async {
                                  if (update == true) {
                                    //update code
                                    if (playController
                                        .formKeyPlayEdit.currentState!
                                        .validate()) {
                                      if (value2Edit == Category.stage) {
                                        playController.categoryEdit.text =
                                            playController.categoryToString(
                                                    value2Edit) ??
                                                "";
                                        final updateCode = Stage(
                                          id: playController.id.text,
                                          token: playController.tokenEdit.text,
                                          description: playController
                                              .descriptionEdit.text,
                                          puzzle:
                                              playController.puzzleEdit.text,
                                          //category: value2Edit,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController
                                            .updateCodeStage(updateCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      } else if (value2Edit != Category.stage) {
                                        playController.categoryEdit.text =
                                            playController.categoryToString(
                                                    value2Edit) ??
                                                "";
                                        final updateCode = Code(
                                          id: playController.id.text,
                                          token: playController.tokenEdit.text,
                                          description: playController
                                              .descriptionEdit.text,
                                          // puzzle: playController.puzzleEdit.text,
                                          category: value2Edit,
                                          value: playController
                                                  .valueEdit.text.isEmpty
                                              ? 0
                                              : double.parse(playController
                                                  .valueEdit.text),
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController
                                            .updateCode(updateCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        exitWindows();
                                      }
                                    }
                                  } else if (update == false) {
                                    if (playController.formKeyPlay.currentState!
                                        .validate()) {
                                      //add stage
                                      if (value2 == Category.stage) {
                                        final newCode = Stage(
                                          token: playController.token.text,
                                          description:
                                              playController.description.text,
                                          puzzle: playController.puzzle.text,
                                          category: value2,
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController
                                            .addCodeStage(newCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        playController.token.clear();
                                      } else if (value2 != Category.stage) {
                                        //add code
                                        final newCode = Code(
                                          token: playController.token.text,
                                          description:
                                              playController.description.text,
                                          //puzzle: playController.puzzle.text,
                                          category: value2,
                                          value: playController
                                                  .value.text.isEmpty
                                              ? 0
                                              : double.parse(
                                                  playController.value.text),
                                        );
                                        setState(() {
                                          userController.loading = true;
                                        });
                                        await playController.addCode(newCode);
                                        setState(() {
                                          userController.loading = false;
                                        });
                                        playController.token.clear();
                                      }
                                    }
                                  }
                                },
                                child: Text(
                                    update == true ? "Atualizar" : "Adicionar"))
                            : const Center(child: CircularProgressIndicator()),
                      ),
                      // lsita de prova versão mobile
                      Visibility(
                        visible: MediaQuery.of(context).size.width > 1250 ||
                                update == true
                            ? false
                            : true,
                        child: StatefulBuilder(
                            builder: (BuildContext context, setState) {
                          return ElevatedButton(
                            onPressed: () {
                              setState(() {
                                historyVisible = true;
                                debugPrint("${userController.history}");
                              });

                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Form(
                                        key: userController.formKeyEditTeam,
                                        child: listCodeStage(
                                            context, playController, 400));
                                  });
                              historyVisible = false;
                            },
                            child: const Text("Provas"),
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  StatefulBuilder addMembers(
      bool hasLoadedMembers, String idTeams, List member, bool update) {
    return StatefulBuilder(builder: (BuildContext context, setState) {
      if (update == true && hasLoadedMembers == false) {
        // Carrega os membros apenas uma vez
        try {
          userController.getListMembers(idTeams).then((userTeams) {
            setState(() {
              member = userTeams;
              membersNumeber = member.length;
              hasLoadedMembers = true; // Marca como carregado
            });
            // hasLoadedMembers != hasLoadedMembers;
          }).catchError((error) {
            // Tratar o erro se necessário
            debugPrint('Erro ao carregar membros: $error');
          });
        } catch (e) {
          debugPrint("$e");
        }
      }
      return ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                backgroundColor: Colors.grey,
                content: SizedBox(
                  width: 400,
                  height: 408,
                  child: StatefulBuilder(
                      builder: (BuildContext context, setStateDialog) {
                    return ListView(
                      children: [
                        ImputTextFormField(
                          title: "Nome do Membro",
                          controller: userController.addMember,
                          focusNode: userController.addMemberFocusNode,
                          onFieldSubmitted: (value) {
                            setStateDialog(() {
                              member.add(value);
                              userController.addMember.clear();
                              FocusScope.of(context).requestFocus(
                                  userController.addMemberFocusNode);
                            });
                          },
                          icon: IconButton(
                            onPressed: () {
                              setStateDialog(() {
                                member.add(userController.addMember.text);
                                userController.addMember.clear();
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            height: 300,
                            width: 400,
                            child: ListView.builder(
                              itemCount: member.length,
                              itemBuilder: (context, index) {
                                final listMember = member[index];
                                return ListTeamController(
                                  user: true,
                                  equipe: listMember,
                                  onTapRemove: () {
                                    setStateDialog(() {
                                      member.remove(listMember);
                                    });
                                  },
                                  onTapEdit: () {
                                    bool updateLocal = true;
                                    userController.addMemberEdit.text =
                                        listMember;

                                    showDialog(
                                      context: context,
                                      builder: (builder) {
                                        return AlertDialog(
                                          backgroundColor: Colors.black87,
                                          content: ImputTextFormField(
                                            title: updateLocal == true
                                                ? "Atualizar membro"
                                                : "Nome do Membro",
                                            controller: updateLocal == true
                                                ? userController.addMemberEdit
                                                : userController.addMember,
                                            onFieldSubmitted: (value) {
                                              setStateDialog(() {
                                                member[index] = value;
                                                updateLocal == true
                                                    ? userController
                                                        .addMemberEdit
                                                        .clear()
                                                    : userController.addMember
                                                        .clear();
                                                exitWindows();
                                              });
                                            },
                                            icon: IconButton(
                                              onPressed: () {
                                                setStateDialog(() {
                                                  member[index] = userController
                                                      .addMemberEdit.text;
                                                  exitWindows();
                                                });
                                              },
                                              icon: Icon(updateLocal == true
                                                  ? Icons.update
                                                  : Icons.add),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (update == true) {
                              final newMembers = UserTeam(
                                id: idTeams,
                                listMembers: member,
                              );
                              userController.updateTeams(newMembers);
                              setStateDialog(() {
                                hasLoadedMembers = false;
                              });

                              exitWindows(); // Fechar o diálogo
                            } else {
                              exitWindows(); // Fechar o diálogo
                            }
                          },
                          child: Text(update == true ? "Atualizar" : "Salvar"),
                        )
                      ],
                    );
                  }),
                ),
              );
            },
          ).then((_) {
            setState(() {
              hasLoadedMembers = false;
            });
          });
        },
        child: Text("Membros ${member.length}"),
      );
    });
  }

  exitWindows() {
    // hasLoadedMembers = false;
    Navigator.pop(context);
  }

  Padding selectStaff(String titulo, String valor, String groupValue,
      Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: RadioListTile<String>(
        tileColor: Colors.black87,
        activeColor: Colors.purple,
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 24,
          ),
        ),
        value: valor,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }

  Padding categorySelected(String titulo, Category valor, Category groupValue,
      Function(Category?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: RadioListTile<Category>(
        tileColor: Colors.black87,
        activeColor: Colors.purple,
        title: Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            // fontWeight: FontWeight.bold,
            // fontSize: 24,
          ),
        ),
        value: valor,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}

addValue(
  Padding Function(StateSetter setState) teamsDropDown,
  BuildContext context,
  UserController user,
  UserTeam teams,
  String dropDonw,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      exit() {
        Navigator.of(context).pop();
      }

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            backgroundColor: Colors.grey,
            title: Text(teams.name ?? ""),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomDropdown(
                  items: const [
                    "Adicionar",
                    "Subtrair",
                    "Congelar",
                    "Proteção",
                    "Jogando"
                  ],
                  title: "Selecione",
                  value: dropDonw,
                  onChanged: (value) {
                    setState(() {
                      dropDonw = value!;
                      print(dropDonw);
                    });
                  },
                ),
                if (dropDonw == "Adicionar" || dropDonw == "Subtrair")
                  ImputTextFormField(
                    title: "Valor",
                    controller: user.addValueHistoty,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                  ),
                if (dropDonw == "Congelar")
                  StreamBuilder<List<UserTeam>>(
                    stream: user.teamStream, // Sua stream de equipes
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                            'Erro ao carregar equipes: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('Nenhuma equipe disponível');
                      } else {
                        List<UserTeam> availableTeams = snapshot.data!;
                        List<String> teamNames = availableTeams
                            .map((team) => team.name ?? "Sem nome")
                            .toList();

                        // Ajusta a lista de equipes conforme a ação selecionada
                        if (dropDonw == "Congelar") {
                          // Remove a equipe atual da lista para congelar
                          teamNames.remove(teams.name);
                        } else if (dropDonw == "Proteção") {
                          // Adiciona a equipe selecionada na lista e usa como valor
                          teamNames = [teams.name ?? "Sem nome"];
                        }

                        // Garantir que o valor inicial do dropdown seja um dos itens da lista
                        String? selectedTeam = user.teamDropDownHistory;
                        if (dropDonw == "Proteção" && teamNames.isNotEmpty) {
                          selectedTeam = teamNames.first;
                        } else if (!teamNames.contains(selectedTeam)) {
                          selectedTeam =
                              teamNames.isNotEmpty ? teamNames.first : null;
                        }

                        return CustomDropdown(
                          value:
                              selectedTeam, // Certifique-se de que value não é nulo
                          title: "Selecione a equipe",
                          items: teamNames,
                          onChanged: (newValue) {
                            setState(() {
                              user.teamDropDownHistory = newValue!;
                            });
                          },
                        );
                      }
                    },
                  ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  switch (dropDonw) {
                    case "Adicionar":
                      user.addValueStatus.text = user.addValueHistoty.text;
                      final credit = double.parse(user.addValueStatus.text) +
                          teams.credit!;
                      user.addValueStatus.text = credit.toString();
                      final userTeam = UserTeam(
                        id: teams.id,
                        credit: double.parse(user.addValueStatus.text),
                      );

                      final history = History(
                          idTeam: teams.id,
                          description:
                              "Adicionado ${user.addValueHistoty.text} a Equipe ${teams.name}");
                      await user.addHistory(history);
                      await user.updateTeams(userTeam);
                      user.addValueStatus.clear();
                      user.addValueHistoty.clear();
                      break;
                    case "Subtrair":
                      final double enteredValue =
                          double.parse(user.addValueHistoty.text);
                      final double currentCredit = teams.credit!;
                      // Calcula o novo valor do crédito após a subtração
                      final double newCredit = currentCredit - enteredValue;
                      // Garante que o crédito não seja menor que zero
                      final double credit =
                          newCredit < 0 ? teams.credit! : newCredit;
                      user.addValueStatus.text = credit.toString();
                      final userTeam = UserTeam(
                        id: teams.id,
                        credit: double.parse(user.addValueStatus.text),
                      );
                      final history = History(
                          idTeam: teams.id,
                          description:
                              "Subtraido ${user.addValueHistoty.text} a equipe ${teams.name}");
                      await user.addHistory(history);
                      await user.updateTeams(userTeam);
                      user.addValueStatus.clear();
                      user.addValueHistoty.clear();
                      break;
                    case "Congelar":
                      user.statusTeams = Status.Congelado;
                      final userTeam = UserTeam(
                        id: teams.id,
                        status: user.statusTeams,
                      );
                      final history = History(
                          idTeam: teams.id,
                          description:
                              "Equipe ${teams.name} congela equipe ${user.teamDropDownHistory}");
                      await user.addHistory(history);
                      await user.updateTeams(userTeam);

                      break;
                    case "Proteção":
                      user.statusTeams = Status.Protegido;
                      final userTeam = UserTeam(
                        id: teams.id,
                        status: user.statusTeams,
                      );
                      final history = History(
                          idTeam: teams.id,
                          description: "Equipe ${teams.name} usa proteção");
                      await user.addHistory(history);
                      await user.updateTeams(userTeam);
                      break;
                    case "Jogando":
                      user.statusTeams = Status.Jogando;
                      final userTeam = UserTeam(
                        id: teams.id,
                        status: user.statusTeams,
                      );
                      await user.updateTeams(userTeam);
                    default:
                  }
                  exit();
                },
                child: const Text("Aplicar"),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Cancelar"))
            ],
          );
        },
      );
    },
  );
}
