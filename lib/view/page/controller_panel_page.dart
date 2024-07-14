import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
import 'package:sherlock/model/user_adm.dart';
import 'package:sherlock/model/user_team.dart';
import 'package:sherlock/view/widgets/imput_text.dart';
import 'package:sherlock/view/widgets/list_team_controller.dart';

class ControllerPanelPage extends StatefulWidget {
  const ControllerPanelPage({super.key});

  @override
  State<ControllerPanelPage> createState() => _ControllerPanelPageState();
}

class _ControllerPanelPageState extends State<ControllerPanelPage> {
  UserController userController = UserController();
  bool historyVisible = false;

  @override
  void initState() {
    super.initState();
    userController.listTeamSubscription;
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
        drawer: Drawer(
          child: ListView(
            children: [
              SizedBox(
                  height: 300, child: listUsers(context, userController, 250)),
              ExpansionTile(
                title: const Text("Adicionar ADM"),
                children: [
                  Container(
                    color: Colors.black,
                    height: 300,
                    child: _addTeams(context, true, false, userController),
                  ),
                ],
              ),
              ExpansionTile(
                title: const Text("Adicionar Staff"),
                children: [
                  Container(
                    color: Colors.black,
                    height: 300,
                    child: _addTeams(context, true, false, userController),
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    content: SizedBox(
                        height: 300,
                        width: 300,
                        child: _addTeams(context, true, false, userController)),
                  );
                });
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          title: const Text('Controller Panel'),
        ),
        body: Padding(
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
                          shadowColor: const Color.fromRGBO(189, 189, 189, 189),
                          color: const Color.fromRGBO(189, 189, 189, 189),
                          child: Form(
                            key: userController.formKey,
                            child: _addTeams(
                                context, false, false, userController),
                          ),
                        ),
                      ),
                      //lista das equipes
                      listUsers(context, userController, 500),
                      history(context)
                    ],
                  ),
                );
              },
            ),
          ),
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
                      userController.removeTeams(team.id.toString());
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
                                  context, false, true, userController),
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

  Visibility history(BuildContext context) {
    return Visibility(
      visible:
          MediaQuery.of(context).size.width > 1329 || historyVisible == true
              ? true
              : false,
      child: SizedBox(
        width: 300,
        height: MediaQuery.of(context).size.width > 1024
            ? MediaQuery.of(context).size.height - 100
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
    );
  }

  Container _addTeams(BuildContext context, bool addAdm, bool update,
      UserController userController) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child: ListView(
        children: [
          Center(
            child: Text(
              update == false
                  ? addAdm == true
                      ? "Adicionar Administrador"
                      : 'Adicionar Equipe'
                  : 'Atualizar Equipe',
              style: const TextStyle(fontSize: 18, color: Colors.purple),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Visibility(
              visible: addAdm == true ? false : true,
              child: ImputTextFormField(
                title: 'Nome da Equipe',
                controller: update == false
                    ? userController.name
                    : userController.nameEdit,
              ),
            ),
          ),
          ImputTextFormField(
            title: 'Login da Equipe',
            controller: update == false
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
                ? userController.password
                : userController.passwordEdit,
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
                          //add ADM
                          if (update == false) {
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

                              await userController.addUserTeam(newUserTeams);
                              setState(() {
                                userController.loading = false;
                              });
                            }
                            //Atualizar Equipe
                          } else if (update == true) {
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
                            await userController.updateTeams(newUserTeamsEdit);
                            setState(() {
                              userController.loading = false;
                            });
                            exitWindows;
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
                              child: history(context));
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
