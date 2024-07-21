import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/play_controller.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/code.dart';
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
  UserController playController = UserController();
  bool historyVisible = false;
  late TabController _tabController;
  ValueNotifier<bool> isHistoryVisible = ValueNotifier<bool>(true);
  String value = "Historico 1";
  Category value2 = Category.stage;

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
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     showDialog(
        //         context: context,
        //         builder: (BuildContext context) {
        //           return AlertDialog(
        //             backgroundColor: Colors.black,
        //             content: SizedBox(
        //                 height: 300,
        //                 width: 300,
        //                 child: _addTeams(context, true, false, userController)),
        //           );
        //         });
        //   },
        //   child: const Icon(Icons.add),
        // ),
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
        body: Wrap(
          children: [
            SizedBox(
              width: 850,
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
                return value
                    ? history(context, true)
                    : listUsers(context, userController, 400);
              },
            ),
          ],
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
                        : MediaQuery.of(context).size.height / 2 - 50,
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
                        : MediaQuery.of(context).size.height / 2 - 50,
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
                        : MediaQuery.of(context).size.height / 2 - 50,
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
                        : MediaQuery.of(context).size.height / 2 - 50,
                    child: Card(
                      elevation: 3,
                      shadowColor: const Color.fromARGB(67, 41, 41, 41),
                      color: const Color.fromRGBO(189, 189, 189, 189),
                      child: Form(
                        key: playController.formKeyPlay,
                        child: _addTolkien(context, playController),
                      ),
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

  SizedBox listUsers(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 50,
      child: Card(
        color: const Color.fromRGBO(189, 189, 189, 189),
        child: StreamBuilder<List<UserTeam>>(
          stream: userController.teamStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              debugPrint("${snapshot.error}");
              return const Center(child: Text('Erro ao carregas as equipes'));
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
                    equipe: team.name,
                    credit: team.credit,
                    onTapRemove: () {
                      userController.removeUser(0, team.id.toString());
                    },
                    onTapEdit: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.black,
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
                                context, false, true, false, userController),
                          );
                        },
                      );
                    },
                    onDesktop: MediaQuery.of(context).size.width > 1329,
                    onTapHistory: () {},
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  SizedBox listUsersAdm(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 50,
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
                        backgroundColor: Colors.black,
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
                    onDesktop: MediaQuery.of(context).size.width > 1329,
                    onTapHistory: () {},
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  SizedBox listUsersStaff(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 50,
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
                        backgroundColor: Colors.black,
                        isScrollControlled: false,
                        context: context,
                        builder: (BuildContext context) {
                          userController.id.text = staff.id ?? "";
                          userController.loginEdit.text = staff.login ?? "";
                          userController.passwordEdit.text =
                              staff.password ?? "";
                          return Form(
                            key: userController.formKeyEditTeam,
                            child: _addTeams(
                                context, false, true, true, userController),
                          );
                        },
                      );
                    },
                    onDesktop: MediaQuery.of(context).size.width > 1329,
                    onTapHistory: () {},
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
      BuildContext context, PlayController playController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 830
          ? MediaQuery.of(context).size.height - 140
          : MediaQuery.of(context).size.height / 2 - 50,
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
              return const Center(child: Text('Erro ao carrega Codigos'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Não há nenhum Codigo'));
            }

            final listAdm = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: listAdm.length,
                itemBuilder: (context, index) {
                  final code = listAdm[index];
                  return ListTeamController(
                    user: true,
                    equipe: code.description,
                    //credit: code.credit,
                    onTapRemove: () {
                      playController.removePlay(0, code.id.toString());
                    },
                    onTapEdit: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.black,
                        isScrollControlled: false,
                        context: context,
                        builder: (BuildContext context) {
                          playController.id.text = code.id ?? "";
                          playController.token.text = code.token ?? "";
                          playController.description.text =
                              code.description ?? "";
                          playController.value.text = code.value.toString();
                          return Form(
                            key: playController.formKeyPlay,
                            child: _addTeams(
                                context, true, true, false, userController),
                          );
                        },
                      );
                    },
                    onDesktop: MediaQuery.of(context).size.width > 1329,
                    onTapHistory: () {},
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Padding history(BuildContext context, bool historyVisible) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
      child: Visibility(
        visible:
            MediaQuery.of(context).size.width > 1329 || historyVisible == true
                ? true
                : false,
        child: SizedBox(
          width: 400,
          height: MediaQuery.of(context).size.width > 830
              ? MediaQuery.of(context).size.height - 135
              : MediaQuery.of(context).size.height / 2 - 20,
          child: Card(
            elevation: 3,
            shadowColor: const Color.fromRGBO(189, 189, 189, 189),
            color: const Color.fromRGBO(189, 189, 189, 189),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<List<UserTeam>>(
                    stream: userController.teamStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data available');
                      } else {
                        List<String> teamNames = ['Todos'];
                        teamNames.addAll(snapshot.data!
                            .map((team) => team.name ?? 'Não há equipes')
                            .toList());
                        String? dropdownValue =
                            teamNames.isNotEmpty ? teamNames.first : null;

                        return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return CustomDropdown(
                              value: dropdownValue,
                              title: "Historico",
                              items: teamNames,
                              onChanged: (newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
                Card(
                    child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  title: Text(
                    "Equipe",
                    style: TextStyle(
                      color: ThemeData().primaryColorLight,
                    ),
                  ),
                  subtitle: Text(
                    "Fez =>",
                    style: TextStyle(
                      color: ThemeData().primaryColorLight,
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _addTeams(BuildContext context, bool addAdm, bool update,
      bool staff, UserController userController) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      //width: 500,
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
              visible: (addAdm == false && update == true && staff == false) ||
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ImputTextFormField(
              title: 'Senha',
              controller: update == false
                  ? userController.password
                  : userController.passwordEdit,
              validator: (value) => value.length < 5
                  ? 'Precisa  ter no minimo 5 caracteres'
                  : null,
            ),
          ),
          ImputTextFormField(
            title: 'Confirmar Senha',
            controller: update == false
                ? userController.passwordComfirm
                : userController.passwordEditComfirm,
            validator: (value) => value != userController.passwordEdit.text
                ? "Senhas diferentes"
                : value.length < 5
                    ? "Sua senha deve ter mínimo 5 aracteres"
                    : value!.isEmpty
                        ? "Confirme sua senha"
                        : null,
          ),
          StatefulBuilder(builder: (BuildContext context, setState) {
            return Row(
              mainAxisAlignment:
                  MediaQuery.of(context).size.width > 1329 || update == true
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: userController.loading == false
                      ? ElevatedButton(
                          onPressed: () async {
                            if (update == true) {
                              if (userController.formKeyEditTeam.currentState!
                                  .validate()) {
                                if (staff == false &&
                                    addAdm == true &&
                                    update == true) {
                                  //atualizar adm
                                  final newUserAdmEdit = UserAdm(
                                    id: userController.id.text,
                                    login: userController.loginEdit.text,
                                    password: userController.passwordEdit.text,
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
                                if (staff == true && update == true && addAdm) {
                                  //atualizar staff
                                  final newUserStaffEdit = UserStaff(
                                    id: userController.id.text,
                                    login: userController.loginEdit.text,
                                    password: userController.passwordEdit.text,
                                  );
                                  setState(() {
                                    print("id:${userController.id.text}");
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
                                    password: userController.password.text,
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
                                        password: userController.password.text,
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
                                        password: userController.password.text,
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
                                      login: userController.loginEdit.text,
                                      password:
                                          userController.passwordEdit.text,
                                    );
                                    setState(() {
                                      print("id:${userController.id.text}");
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
                                    password: userController.passwordEdit.text,
                                  );
                                  setState(() {
                                    print("id:${userController.id.text}");
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
                                    password: userController.passwordEdit.text,
                                  );
                                  setState(() {
                                    print("id:${userController.id.text}");
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
                                    password: userController.password.text,
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
                                        password: userController.password.text,
                                      );
                                      await userController
                                          .addUserAdm(newUserAdm);
                                      setState(() {
                                        userController.loading = false;
                                      });
                                      //exitWindows;
                                      //add Equipe
                                    } else if (addAdm == false) {
                                      final newUserTeams = UserTeam(
                                        name: userController.name.text,
                                        login: userController.login.text,
                                        password: userController.password.text,
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
                                      login: userController.loginEdit.text,
                                      password:
                                          userController.passwordEdit.text,
                                    );
                                    setState(() {
                                      print("id:${userController.id.text}");
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
                          child:
                              Text(update == false ? "Adicionar" : "Atualizar"))
                      : const Center(child: CircularProgressIndicator()),
                ),
                //botão historico
                Visibility(
                  visible:
                      MediaQuery.of(context).size.width > 1329 || update == true
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
                                  child: history(context, true));
                            });
                        historyVisible = false;
                      },
                      child: const Text("Historico"),
                    );
                  }),
                ),

                // Botão adicionar equipes
                // Botão remover equipes
                // Dropdown para acessar o histórico das equipes
              ],
            );
          }),
        ],
      ),
    );
  }

// add codigo
  Container _addTolkien(BuildContext context, PlayController playController) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      //width: 500,
      child: ListView(
        children: [
          const Center(
            child: Text(
              'Adicionar Codigo',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ImputTextFormField(
                title: 'Descrição', controller: playController.description),
          ),
          ImputTextFormField(title: 'Codigo', controller: playController.token),
          IconButton(
            onPressed: () {
              playController.token.text = generateRandomCode(6);
            },
            icon: const Icon(Icons.generating_tokens),
            color: Colors.amber,
          ),
          //categoria
          StatefulBuilder(builder: (BuildContext context, setState) {
            return Column(
              children: [
                categorySelected(
                  'Prova',
                  value2,
                  Category.stage,
                  (value) {
                    setState(() {
                      value2 = Category.stage;
                    });
                  },
                ),
                categorySelected(
                  'Adicionar',
                  value2,
                  Category.receive,
                  (value) {
                    setState(() {
                      value2 = Category.pay;
                    });
                  },
                ),
                categorySelected(
                  'Subtrair',
                  value2,
                  Category.pay,
                  (value) {
                    setState(() {
                      value2 = Category.receive;
                    });
                  },
                ),
                categorySelected(
                  'Congelar',
                  value2,
                  Category.freezing,
                  (value) {
                    setState(() {
                      value2 = Category.freezing;
                    });
                  },
                ),
                categorySelected(
                  'Escudo',
                  value2,
                  Category.protect,
                  (value) {
                    setState(() {
                      value2 = Category.protect;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ImputTextFormField(
                    enabled:
                        value2 == Category.pay || value2 == Category.receive
                            ? true
                            : false,
                    title: 'Valor',
                    controller: playController.value,
                  ),
                ),
              ],
            );
          }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: userController.loading == false
                    ? ElevatedButton(
                        onPressed: () async {
                          if (playController.formKeyPlay.currentState!
                              .validate()) {
                            print("${playController.token.text}");
                            print("${playController.description.text}");
                            print("${playController.value.text}");
                            print("${value2}");
                            final newCode = Code(
                              token: playController.token.text,
                              description: playController.description.text,
                              category: value2,
                              value: double.parse(playController.value.text),
                            );
                            setState(() {
                              userController.loading = true;
                            });
                            await playController.addCode(newCode);
                            setState(() {
                              userController.loading = false;
                            });
                          }
                        },
                        child: const Text("Adicionar"))
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  exitWindows() {
    Navigator.pop(context);
  }

  Padding categorySelected(String titulo, Category valor, Category groupValue,
      Function(Category?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: RadioListTile<Category>(
        tileColor: Colors.grey,
        activeColor: Colors.green,
        title: Text(
          titulo,
          // style: const TextStyle(
          //   color: Colors.green,
          //   fontWeight: FontWeight.bold,
          //   fontSize: 24,
          // ),
        ),
        value: valor,
        groupValue: groupValue,
        onChanged: onChanged,
      ),
    );
  }
}
