import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_staf.dart';
import 'package:sherlock/model/user_team.dart';
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
  bool historyVisible = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    userController.listTeamSubscription;
    _tabController = TabController(length: 3, vsync: this);
    //Provider.of<UserController>(context, listen: false).subscribeToTeams();
    //userController.loadTeams();
  }

  @override
  void dispose() {
    userController.listTeamSubscription?.cancel();
    super.dispose();
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
            ],
          ),
          // actions: [
          //   IconButton(
          //     icon: Icon(Icons.search),
          //     onPressed: () {},
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.notifications),
          //     onPressed: () {},
          //   ),
          //   IconButton(
          //     icon: Icon(Icons.account_circle),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        body: Wrap(
          children: [
            SizedBox(
              width: 850,
              height: MediaQuery.of(context).size.height - 135,
              // height: MediaQuery.of(context).size.width > 1024
              //     ? MediaQuery.of(context).size.height - 100
              //     : MediaQuery.of(context).size.height / 2 - 20,
              //height: 500,
              child: TabBarView(
                controller: _tabController,
                children: [
                  pageTeams(),
                  pageAdm(),
                  pageStaff(),
                ],
              ),
            ),
            history(context, true),
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
                    height: MediaQuery.of(context).size.width > 1024
                        ? MediaQuery.of(context).size.height - 100
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
                    height: MediaQuery.of(context).size.width > 1024
                        ? MediaQuery.of(context).size.height - 100
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
                    height: MediaQuery.of(context).size.width > 1024
                        ? MediaQuery.of(context).size.height - 100
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

  SizedBox listUsers(
      BuildContext context, UserController userController, double width) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.width > 1024
          ? MediaQuery.of(context).size.height - 100
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
                      setState(() {
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
                      });
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
      height: MediaQuery.of(context).size.width > 1024
          ? MediaQuery.of(context).size.height - 100
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
                    equipe: team.login,
                    //credit: team.credit,
                    onTapRemove: () {
                      userController.removeUser(1, team.id.toString());
                    },
                    onTapEdit: () {
                      setState(() {
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
                      });
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
      height: MediaQuery.of(context).size.width > 1024
          ? MediaQuery.of(context).size.height - 100
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
                    equipe: staff.login,
                    //credit: staff.credit,
                    onTapRemove: () {
                      userController.removeUser(2, staff.id.toString());
                    },
                    onTapEdit: () {
                      setState(() {
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
                      });
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
          height: MediaQuery.of(context).size.width > 1024
              ? MediaQuery.of(context).size.height - 135
              : MediaQuery.of(context).size.height / 2 - 20,
          child: Card(
            elevation: 3,
            shadowColor: const Color.fromRGBO(189, 189, 189, 189),
            color: const Color.fromRGBO(189, 189, 189, 189),
            child: ListView(
              children: [
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
            ),
          ),
          ImputTextFormField(
            title: 'Confirmar Senha',
            controller: update == false
                ? userController.passwordComfirm
                : userController.passwordEditComfirm,
          ),
          Row(
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
                                  print("id:${userController.id.text}");
                                  userController.loading = true;
                                });
                                await userController.updateAdm(newUserAdmEdit);
                                setState(() {
                                  userController.loading = false;
                                });
                                exitWindows;
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
                                exitWindows;
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
                                await userController.addUserStaff(newUserStaff);
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
                                    await userController.addUserAdm(newUserAdm);
                                    setState(() {
                                      userController.loading = false;
                                    });
                                    exitWindows;
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
                                    password: userController.passwordEdit.text,
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
                                  exitWindows;
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
                                await userController.updateAdm(newUserAdmEdit);
                                setState(() {
                                  userController.loading = false;
                                });
                                exitWindows;
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
                                exitWindows;
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
                                await userController.addUserStaff(newUserStaff);
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
                                    await userController.addUserAdm(newUserAdm);
                                    setState(() {
                                      userController.loading = false;
                                    });
                                    exitWindows;
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
                                    password: userController.passwordEdit.text,
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
                                  exitWindows;
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
              ),
              // DropdownButton<String>(
              //   value: "historico 1",
              //   hint: Text('Select an item'),
              //   items:
              //       ["historico 1", "historico 2"].map((String item) {
              //     return DropdownMenuItem<String>(
              //       value: item,
              //       child: Text(item),
              //     );
              //   }).toList(),
              //   onChanged: (String? newValue) {
              //     // setState(() {
              //     //   _selectedItem = newValue;
              //     // });
              //   },
              // ),
              // Botão adicionar equipes
              // Botão remover equipes
              // Dropdown para acessar o histórico das equipes
            ],
          ),
        ],
      ),
    );
  }

  exitWindows() {
    Navigator.pop(context);
  }
}
