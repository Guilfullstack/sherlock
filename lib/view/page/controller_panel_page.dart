import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sherlock/controller/user_controller.dart';
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
    Provider.of<UserController>(context, listen: false).loadTeams();
    //userController.loadTeams();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Controller Panel'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ChangeNotifierProvider<UserController>(
            create: (context) => UserController()..loadTeams(),
            child: Consumer<UserController>(
                builder: (context, userController, child) {
              return Center(
                child: Wrap(
                  children: [
                    SizedBox(
                      //width: 500,
                      height: MediaQuery.of(context).size.width > 1024
                          ? MediaQuery.of(context).size.height - 100
                          : MediaQuery.of(context).size.height / 2 - 50,
                      child: Card(
                        elevation: 3,
                        shadowColor: const Color.fromRGBO(189, 189, 189, 189),
                        color: const Color.fromRGBO(189, 189, 189, 189),
                        child: Form(
                          key: userController.formKey,
                          child: _addTeams(context, false, userController),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 500,
                      height: MediaQuery.of(context).size.width > 1024
                          ? MediaQuery.of(context).size.height - 100
                          : MediaQuery.of(context).size.height / 2 - 50,
                      child: Card(
                        elevation: 3,
                        shadowColor: const Color.fromRGBO(189, 189, 189, 189),
                        color: const Color.fromRGBO(189, 189, 189, 189),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.builder(
                            itemCount: userController.listTeamn.length,
                            itemBuilder: (context, index) {
                              final team = userController.listTeamn[index];
                              if (userController.listTeamn.isEmpty) {
                                return const Center(
                                    child: Text(
                                  "Sem equipes",
                                  style: TextStyle(color: Colors.white),
                                ));
                              } else {
                                return ListTeamController(
                                  equipe: team.name,
                                  onTapRemove: () {
                                    userController
                                        .removeTeams(team.id.toString());
                                  },
                                  onTapEdit: () {
                                    setState(() {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.black,
                                          isScrollControlled: false,
                                          context: context,
                                          builder: (BuildContext context) {
                                            print(MediaQuery.of(context)
                                                .size
                                                .width);
                                            userController.id.text =
                                                team.id ?? "";
                                            userController.loginEdit.text =
                                                team.login ?? "";
                                            userController.passwordEdit.text =
                                                team.password ?? "";
                                            return Form(
                                              key: userController
                                                  .formKeyEditTeam,
                                              child: _addTeams(context, true,
                                                  userController),
                                            );
                                          });
                                    });
                                  },
                                  onDesktop:
                                      MediaQuery.of(context).size.width > 1329
                                          ? true
                                          : false,
                                  onTapHistory: () {},
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    history(context)
                  ],
                ),
              );
            }),
          ),
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

  Container _addTeams(
      BuildContext context, bool update, UserController userController) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
      ),
      child: Column(
        children: [
          Text(
            update == false ? 'Adicionar Equipe' : 'Atualizar Equipe',
            style: const TextStyle(fontSize: 18, color: Colors.purple),
          ),
          ImputTextFormField(
            title: 'Nome da Equipe',
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
                          if (update == false) {
                            final newUserTeams = UserTeam(
                              name: userController.login.text,
                              login: userController.login.text,
                              password: userController.password.text,
                            );
                            setState(() {
                              userController.loading = true;
                            });

                            await userController.addUserTeam(newUserTeams);
                            setState(() {
                              userController.loading = false;
                            });
                          } else {
                            final newUserTeamsEdit = UserTeam(
                              id: userController.id.text,
                              name: userController.loginEdit.text,
                              login: userController.loginEdit.text,
                              password: userController.passwordEdit.text,
                            );
                            setState(() {
                              userController.loading = true;
                            });
                            await userController.updateTeams(newUserTeamsEdit);
                            setState(() {
                              userController.loading = false;
                            });
                            Navigator.pop(context);
                          }
                        },
                        child:
                            Text(update == false ? "Adicionar" : "Atualizar"))
                    : const Center(child: CircularProgressIndicator()),
              ),

              Visibility(
                visible:
                    MediaQuery.of(context).size.width > 1329 || update == true
                        ? false
                        : true,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      historyVisible = true;
                      print(userController.history);
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
}
